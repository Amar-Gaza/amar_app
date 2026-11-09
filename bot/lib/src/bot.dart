import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'geocoder.dart';
import 'masar.dart';
import 'store.dart';
import 'telegram.dart';
import 'texts.dart';
import 'vision.dart';

/// Order flow over Telegram:
/// /start → share contact → OTP → vendor → product → qty → cart →
/// address or location → quote → confirm → status updates.
class AmarBot {
  AmarBot(
    this._tg,
    this._api,
    this._store,
    this._geocoder,
    this._ai,
    this._token,
  );

  final Geocoder _geocoder;
  final Assistant _ai;
  final String _token;

  final Telegram _tg;
  final Masar _api;
  final SessionStore _store;

  static const Duration _orderPoll = Duration(seconds: 30);
  static const String _cash = 'cash_on_delivery';
  static const String _offerOpen = 'sent';

  final Map<int, String> _vendorNames = {};
  final Random _random = Random.secure();
  List<String>? _paymentMethods;
  bool _polling = false;

  static final Map<String, dynamic> _menu = Telegram.reply([
    [T.newOrder, T.myCart],
    [T.myOrders, T.logout],
  ]);

  Future<void> run() async {
    _store.load();
    Timer.periodic(_orderPoll, (_) => _pollOrders());
    stdout.writeln('AMAR bot is running.');
    var offset = 0;
    while (true) {
      try {
        final updates = await _tg.getUpdates(offset);
        for (final update in updates) {
          offset = (update['update_id'] as int) + 1;
          _enqueue(update);
        }
      } catch (e) {
        stderr.writeln('getUpdates: $e');
        await Future<void>.delayed(const Duration(seconds: 5));
      }
    }
  }

  // ---------------- dispatch ----------------

  /// One queue per chat: a slow AI reply never blocks other customers,
  /// and a customer's own messages still run in order.
  final Map<int, Future<void>> _chains = {};
  final Map<String, List<Map>> _albums = {};
  static const Duration _albumWait = Duration(milliseconds: 1500);

  void _enqueue(Map<String, dynamic> update) {
    final message = update['message'] as Map?;
    final callback = update['callback_query'] as Map?;
    final chat = (message ?? callback?['message'] as Map?)?['chat'] as Map?;
    final chatId = chat?['id'] as int?;
    if (chatId == null) return;

    // Photos sent together arrive one by one: answer them as one case.
    final group = message?['media_group_id'] as String?;
    if (message != null && group != null) {
      final first = !_albums.containsKey(group);
      _albums.putIfAbsent(group, () => []).add(message);
      if (!first) return;
      Future<void>.delayed(_albumWait, () {
        final parts = _albums.remove(group) ?? [message];
        _chain(chatId, {
          'update_id': update['update_id'],
          'message': {...message, '_album': parts},
        });
      });
      return;
    }
    _chain(chatId, update);
  }

  void _chain(int chatId, Map<String, dynamic> update) {
    _chains[chatId] = (_chains[chatId] ?? Future<void>.value())
        .then((_) => _handle(update))
        .catchError((Object e) => stderr.writeln('chain $chatId: $e'));
  }

  Future<void> _handle(Map<String, dynamic> update) async {
    final message = update['message'] as Map?;
    final callback = update['callback_query'] as Map?;
    final chat = (message ?? callback?['message'] as Map?)?['chat'] as Map?;
    final chatId = chat?['id'] as int?;
    if (chatId == null) return;
    // Private chats only: sessions hold a customer's token.
    if (chat?['type'] != 'private') return;

    final session = _store.of(chatId);
    try {
      if (callback != null) {
        await _onCallback(chatId, session, callback);
      } else if (message != null) {
        await _onMessage(chatId, session, message);
      }
    } on MasarFailure catch (e) {
      if (e.code == Masar.unauthenticated && session.signedIn) {
        session.signOut();
        await _tg.send(chatId, T.sessionExpired,
            markup: Telegram.removeKeyboard);
      } else {
        await _tg.send(chatId, T.error(e.message));
      }
    } catch (e) {
      stderr.writeln('update ${update['update_id']}: $e');
      await _tg.send(chatId, T.failed).catchError((_) {});
    } finally {
      await _store.save();
    }
  }

  Future<void> _onMessage(int chatId, Session s, Map message) async {
    final text = (message['text'] as String?)?.trim();
    final from = message['from'] as Map?;
    final name = from?['first_name'] as String?;

    if (text == '/start') return _start(chatId, s);
    if (message['contact'] is Map) {
      return _onContact(chatId, s, message['contact'] as Map, from);
    }
    if (s.step == Step.otp && text != null) {
      return _onOtp(chatId, s, text, from);
    }

    final album = (message['_album'] as List?)?.cast<Map>() ?? [message];
    final photos = [
      for (final m in album)
        if (_photoId(m) case final id?) id,
    ];
    if (photos.isNotEmpty) {
      final caption = album
          .map((m) => (m['caption'] as String?)?.trim() ?? '')
          .where((c) => c.isNotEmpty)
          .join('\n');
      return _onPhotos(chatId, s, photos, caption, name);
    }
    final other = _otherMedia(message);
    if (other != null) return _tg.send(chatId, other);

    if (message['location'] is Map) {
      if (s.signedIn && s.step == Step.location) {
        return _onLocation(chatId, s, message['location'] as Map);
      }
      return _tg.send(chatId, T.locationNoFlow);
    }
    if (text == null || text.isEmpty) {
      return _tg.send(chatId, T.unknown, markup: s.signedIn ? _menu : null);
    }

    const menuButtons = [T.newOrder, T.myCart, T.myOrders, T.logout, T.back];
    if (!s.signedIn && menuButtons.contains(text)) {
      return _tg.send(chatId, T.loginFirst);
    }
    if (s.signedIn) {
      switch (text) {
        case T.newOrder:
          s.step = Step.idle;
          return _showVendors(chatId);
        case T.myCart:
          s.step = Step.idle;
          return _showCart(chatId, s);
        case T.myOrders:
          s.step = Step.idle;
          return _showOrders(chatId, s);
        case T.logout:
          _ai.forget(chatId);
          return _logout(chatId, s);
        case T.back:
          s
            ..step = Step.idle
            ..clearCheckout();
          return _tg.send(chatId, T.welcomeBack, markup: _menu);
      }
      if (s.step == Step.details) {
        return _onDetails(chatId, s, text == T.skip ? null : text);
      }
      if (s.step == Step.location) {
        final point = parseCoordinates(text);
        if (point != null) {
          return _onLocation(
              chatId, s, {'latitude': point.$1, 'longitude': point.$2});
        }
        return _tg.send(chatId, T.askLocation);
      }
    }
    return _askAi(chatId, s, text: text, name: name);
  }

  // ---------------- AI assistant ----------------

  /// Largest size of a photo, or an image sent as a file.
  static String? _photoId(Map message) {
    final sizes = message['photo'] as List?;
    if (sizes != null && sizes.isNotEmpty) {
      return (sizes.last as Map)['file_id'] as String?;
    }
    final doc = message['document'] as Map?;
    final mime = doc?['mime_type'] as String? ?? '';
    return mime.startsWith('image/') ? doc!['file_id'] as String? : null;
  }

  /// A friendly answer for media the assistant cannot read.
  static String? _otherMedia(Map m) {
    if (m['voice'] != null || m['audio'] != null) return T.noVoice;
    if (m['video'] != null || m['video_note'] != null) return T.noVideo;
    if (m['animation'] != null || m['sticker'] != null) return T.sticker;
    if (m['document'] != null) return T.noDocument;
    if (m['poll'] != null || m['dice'] != null || m['game'] != null) {
      return T.unknown;
    }
    return null;
  }

  Future<void> _onPhotos(
    int chatId,
    Session s,
    List<String> fileIds,
    String caption,
    String? name,
  ) async {
    if (!_ai.enabled) return _tg.send(chatId, T.aiOff);
    await _tg.send(chatId, fileIds.length == 1 ? T.analyzing : T.analyzingMany);
    final images = <List<int>>[];
    for (final id in fileIds.take(5)) {
      final bytes = await _ai.telegramFile(_token, id);
      if (bytes == null) return _tg.send(chatId, T.imageTooBig);
      images.add(bytes);
    }
    return _askAi(chatId, s, text: caption, images: images, name: name);
  }

  Future<void> _askAi(
    int chatId,
    Session s, {
    String? text,
    List<List<int>> images = const [],
    String? name,
  }) async {
    if (!_ai.enabled) {
      return _tg.send(chatId, T.unknown, markup: s.signedIn ? _menu : null);
    }
    await _tg.typing(chatId);
    final AiReply reply;
    try {
      reply = await _ai.reply(
        chatId,
        text: text,
        images: images,
        signedIn: s.signedIn,
        name: name,
      );
    } on Object catch (e) {
      stderr.writeln('ai: $e');
      return _tg.send(chatId, T.aiFailed, markup: s.signedIn ? _menu : null);
    }
    final buttons = <List<(String, String)>>[
      if (reply.action == AiAction.inspection) [(T.bookInspection, 'insp')],
      if (reply.action == AiAction.browse) [(T.newOrder, 'browse')],
      if (reply.action == AiAction.orders) [(T.myOrders, 'orders')],
      if (reply.action == AiAction.cart) [(T.myCart, 'cart')],
      if (images.isNotEmpty) [(T.anotherPhoto, 'photo')],
    ];
    final chunks = _split(reply.text);
    for (var i = 0; i < chunks.length; i++) {
      final last = i == chunks.length - 1;
      await _tg.send(chatId, chunks[i],
          markup: last && buttons.isNotEmpty ? Telegram.inline(buttons) : null);
    }
  }

  /// Telegram caps a message at 4096 characters.
  static List<String> _split(String text, [int size = 3900]) {
    final parts = <String>[];
    var rest = text;
    while (rest.length > size) {
      var cut = rest.lastIndexOf('\n', size);
      if (cut < size ~/ 2) cut = size;
      parts.add(rest.substring(0, cut).trim());
      rest = rest.substring(cut).trim();
    }
    if (rest.isNotEmpty) parts.add(rest);
    return parts;
  }

  Future<void> _onCallback(int chatId, Session s, Map callback) async {
    await _tg.answer(callback['id'] as String);
    final parts = (callback['data'] as String? ?? '').split(':');
    // Photo help works before login; everything else needs a session.
    if (parts.first == 'photo') return _tg.send(chatId, T.sendPhoto);
    if (parts.first == 'insp' && !s.signedIn) {
      return _tg.send(chatId, T.inspectionLogin);
    }
    if (!s.signedIn) return _tg.send(chatId, T.loginFirst);

    int? arg(int i) => parts.length > i ? int.tryParse(parts[i]) : null;

    switch (parts.first) {
      case 'insp':
        await _tg.send(chatId, T.pickProvider);
        return _showVendors(chatId);
      case 'browse':
        s.step = Step.idle;
        return _showVendors(chatId);
      case 'orders':
        s.step = Step.idle;
        return _showOrders(chatId, s);
      case 'cart':
        s.step = Step.idle;
        return _showCart(chatId, s);
      case 'v':
        return _pickVendor(chatId, s, arg(1)!);
      case 'p':
        return _pickProduct(chatId, s, arg(1)!);
      case 'q':
        return _addToCart(chatId, s, arg(1)!);
      case 'more':
        return s.vendorId == null
            ? _showVendors(chatId)
            : _showProducts(chatId, s);
      case 'clear':
        s.clearCart();
        return _tg.send(chatId, T.cartCleared, markup: _menu);
      case 'checkout':
        return _checkout(chatId, s);
      case 'a':
        s
          ..step = Step.idle
          ..addressId = arg(1);
        return _quote(chatId, s);
      case 'confirm':
        return _place(chatId, s);
      case 'cancel':
        s
          ..step = Step.idle
          ..clearCheckout();
        return _tg.send(chatId, T.cancelled, markup: _menu);
      case 'oa':
        await _api.approveOffer(s.token!, arg(1)!, arg(2)!);
        return _tg.send(chatId, T.offerApproved);
      case 'or':
        await _api.rejectOffer(s.token!, arg(1)!, arg(2)!);
        return _tg.send(chatId, T.offerRejected);
    }
  }

  // ---------------- login ----------------

  Future<void> _start(int chatId, Session s) async {
    if (s.signedIn) {
      s.step = Step.idle;
      return _tg.send(chatId, '${T.welcomeBack}\n\n${T.photoHint}',
          markup: _menu);
    }
    s.step = Step.contact;
    await _tg.send(chatId, T.welcome,
        markup: Telegram.requestContact(T.shareContact));
  }

  Future<void> _onContact(int chatId, Session s, Map contact, Map? from) async {
    if (contact['user_id'] != from?['id']) {
      return _tg.send(chatId, T.contactNotYours);
    }
    final phone = normalizePhone(contact['phone_number'] as String);
    await _api.sendOtp(phone);
    s
      ..phone = phone
      ..step = Step.otp;
    await _tg.send(chatId, T.otpSent(phone), markup: Telegram.removeKeyboard);
  }

  Future<void> _onOtp(int chatId, Session s, String text, Map? from) async {
    final code = text.replaceAll(RegExp(r'[^0-9]'), '');
    final phone = s.phone;
    if (code.isEmpty || phone == null) return _tg.send(chatId, T.otpWrong);

    final name = [from?['first_name'], from?['last_name']]
        .whereType<String>()
        .join(' ')
        .trim();
    try {
      s.token = await _api.verifyOtp(
        phone,
        code,
        name: name.length >= 2 ? name.substring(0, min(name.length, 60)) : null,
      );
    } on MasarFailure catch (e) {
      return _tg.send(chatId, '${T.otpWrong}\n${T.error(e.message)}');
    }
    s.step = Step.idle;
    await _tg.send(chatId, '${T.signedIn}\n\n${T.photoHint}', markup: _menu);
  }

  Future<void> _logout(int chatId, Session s) async {
    try {
      await _api.logout(s.token!);
    } on MasarFailure {
      // Sign out locally regardless of the server answer.
    }
    s.signOut();
    await _tg.send(chatId, T.loggedOut, markup: Telegram.removeKeyboard);
  }

  // ---------------- catalog and cart ----------------

  Future<void> _showVendors(int chatId) async {
    final s = _store.of(chatId);
    final vendors = await _api.vendors(s.token!);
    if (vendors.isEmpty) return _tg.send(chatId, T.noVendors);
    for (final v in vendors) {
      _vendorNames[v['id'] as int] = v['name'].toString();
    }
    await _tg.send(chatId, T.pickVendor,
        markup: Telegram.inline([
          for (final v in vendors) [(v['name'].toString(), 'v:${v['id']}')],
        ]));
  }

  Future<void> _pickVendor(int chatId, Session s, int vendorId) async {
    if (s.cart.isNotEmpty && s.vendorId != vendorId) {
      s.clearCart();
      await _tg.send(chatId, T.otherVendorReset);
    }
    s
      ..vendorId = vendorId
      ..vendorName = _vendorNames[vendorId] ?? s.vendorName;
    await _showProducts(chatId, s);
  }

  Future<void> _showProducts(int chatId, Session s) async {
    final products = (await _api.products(s.token!, s.vendorId!))
        .where((p) =>
            p['in_stock'] != false &&
            ((p['options'] as List?) ?? const []).isEmpty)
        .toList();
    if (products.isEmpty) return _tg.send(chatId, T.noProducts);
    await _tg.send(chatId, T.pickProduct(s.vendorName ?? ''),
        markup: Telegram.inline([
          for (final p in products)
            [('${p['name']} • ${moneyOf(p['price'])}', 'p:${p['id']}')],
        ]));
  }

  Future<void> _pickProduct(int chatId, Session s, int productId) async {
    final p = await _api.product(s.token!, productId);
    final vendorId = p['vendor_id'] as int?;
    if (vendorId != null && vendorId != s.vendorId) {
      if (s.cart.isNotEmpty) {
        s.clearCart();
        await _tg.send(chatId, T.otherVendorReset);
      }
      s
        ..vendorId = vendorId
        ..vendorName = _vendorNames[vendorId];
    }
    s
      ..pendingProductId = productId
      ..pendingProductName = p['name'].toString();
    await _tg.send(chatId, T.pickQty(p['name'].toString(), moneyOf(p['price'])),
        markup: Telegram.inline([
          [('1', 'q:1'), ('2', 'q:2'), ('3', 'q:3')],
          [('4', 'q:4'), ('5', 'q:5'), ('10', 'q:10')],
        ]));
  }

  Future<void> _addToCart(int chatId, Session s, int qty) async {
    final id = s.pendingProductId;
    if (id == null) return _showCart(chatId, s);
    final existing = s.cart.where((l) => l.productId == id).firstOrNull;
    if (existing != null) {
      existing.qty += qty;
    } else {
      s.cart.add(CartLine(id, s.pendingProductName ?? '', qty));
    }
    s
      ..pendingProductId = null
      ..pendingProductName = null
      ..clearCheckout();
    await _showCart(chatId, s);
  }

  Future<void> _showCart(int chatId, Session s) async {
    if (s.cart.isEmpty) return _tg.send(chatId, T.cartEmpty, markup: _menu);
    await _tg.send(chatId, T.cart(s.vendorName ?? '', _cartLines(s)),
        markup: Telegram.inline([
          [(T.addMore, 'more')],
          [(T.checkout, 'checkout')],
          [(T.clearCart, 'clear')],
        ]));
  }

  String _cartLines(Session s) =>
      s.cart.map((l) => '• ${l.name} × ${l.qty}').join('\n');

  // ---------------- checkout ----------------

  Future<void> _checkout(int chatId, Session s) async {
    if (s.cart.isEmpty) return _tg.send(chatId, T.cartEmpty, markup: _menu);
    s
      ..clearCheckout()
      ..step = Step.location;

    final saved = await _api.addresses(s.token!);
    if (saved.isNotEmpty) {
      await _tg.send(chatId, T.pickAddress,
          markup: Telegram.inline([
            for (final a in saved)
              [
                (
                  [a['label'], a['details']]
                      .whereType<String>()
                      .where((e) => e.isNotEmpty)
                      .join(' — '),
                  'a:${a['id']}',
                ),
              ],
          ]));
    }
    await _tg.send(chatId, T.askLocation,
        markup: Telegram.requestLocation(T.sendLocation, T.back));
  }

  Future<void> _onLocation(int chatId, Session s, Map location) async {
    if (s.step != Step.location || s.cart.isEmpty) {
      return _tg.send(chatId, T.unknown, markup: _menu);
    }
    s
      ..lat = (location['latitude'] as num).toDouble()
      ..lng = (location['longitude'] as num).toDouble()
      ..step = Step.details;
    await _tg.send(chatId, T.askDetails,
        markup: Telegram.reply([
          [T.skip],
          [T.back],
        ]));
  }

  Future<void> _onDetails(int chatId, Session s, String? details) async {
    final place = await _geocoder.label(s.lat!, s.lng!);
    final note = details?.trim();
    final Map<String, dynamic> address;
    try {
      address = await _api.addAddress(
        s.token!,
        lat: s.lat!,
        lng: s.lng!,
        // Same label the app builds: "city، neighborhood، street".
        label: place ?? T.addressLabel,
        details: _joinOrNull([place, note]),
      );
    } on MasarFailure catch (e) {
      // Out of zone or invalid point: ask for the location again instead
      // of leaving the customer stuck on the description step.
      s
        ..lat = null
        ..lng = null
        ..step = Step.location;
      await _tg.send(chatId, T.error(e.message));
      return _tg.send(chatId, T.askLocation,
          markup: Telegram.requestLocation(T.sendLocation, T.back));
    }
    s
      ..addressId = address['id'] as int
      ..step = Step.idle;
    await _quote(chatId, s);
  }

  Future<void> _quote(int chatId, Session s) async {
    if (s.cart.isEmpty || s.addressId == null || s.vendorId == null) {
      return _tg.send(chatId, T.cartEmpty, markup: _menu);
    }
    await _tg.send(chatId, T.quoting, markup: _menu);
    final quote = await _api.quote(
      s.token!,
      vendorId: s.vendorId!,
      cart: [
        for (final l in s.cart) {'product_id': l.productId, 'qty': l.qty},
      ],
      addressId: s.addressId!,
      paymentMethod: await _paymentMethod(),
    );
    s
      ..quoteToken = quote['quote_token'] as String
      ..idempotencyKey = _newKey();

    final breakdown = ((quote['breakdown'] as List?) ?? const [])
        .whereType<Map>()
        .map((b) => '${labelOf(b['label'])}: ${b['formatted'] ?? ''}')
        .join('\n');
    await _tg.send(
      chatId,
      T.quote('${_cartLines(s)}\n\n$breakdown', moneyOf(quote['total'])),
      markup: Telegram.inline([
        [(T.confirm, 'confirm')],
        [(T.cancel, 'cancel')],
      ]),
    );
  }

  Future<void> _place(int chatId, Session s) async {
    final quoteToken = s.quoteToken;
    final key = s.idempotencyKey;
    if (quoteToken == null || key == null) {
      return _tg.send(chatId, T.cartEmpty, markup: _menu);
    }
    final Map<String, dynamic> order;
    try {
      order = await _api.placeOrder(s.token!,
          quoteToken: quoteToken, idempotencyKey: key, note: null);
    } on MasarFailure catch (e) {
      if (e.code == Masar.quoteExpired || e.code == Masar.quoteUsed) {
        await _tg.send(chatId, T.quoteAgain);
        return _quote(chatId, s);
      }
      rethrow;
    }
    final status = order['status'] as Map? ?? const {};
    s
      ..watched['${order['id']}'] = status['key']?.toString() ?? ''
      ..clearCart();
    await _tg.send(
      chatId,
      T.placed(order['code'].toString(), labelOf(status['label'])),
      markup: _menu,
    );
  }

  Future<String?> _paymentMethod() async {
    _paymentMethods ??=
        (((await _api.config())['payment_methods'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList();
    final methods = _paymentMethods!;
    if (methods.contains(_cash)) return _cash;
    return methods.firstOrNull;
  }

  String _newKey() =>
      List.generate(16, (_) => _random.nextInt(256).toRadixString(16))
          .map((h) => h.padLeft(2, '0'))
          .join();

  // ---------------- orders ----------------

  Future<void> _showOrders(int chatId, Session s) async {
    final orders = await _api.orders(s.token!);
    if (orders.isEmpty) return _tg.send(chatId, T.noOrders, markup: _menu);
    final lines = <String>[];
    for (final o in orders) {
      final status = o['status'] as Map? ?? const {};
      lines.add(T.orderLine(
          o['code'].toString(), labelOf(status['label']), moneyOf(o['total'])));
      // Follow open orders made from the app too.
      if (status['is_terminal'] != true) {
        s.watched.putIfAbsent('${o['id']}', () => status['key'].toString());
      }
    }
    await _tg.send(chatId, '${T.lastOrders}\n${lines.join('\n')}',
        markup: _menu);
  }

  /// Tells each customer when an order they follow changes status, and
  /// shows a price offer when one is waiting for them.
  Future<void> _pollOrders() async {
    if (_polling) return;
    _polling = true;
    try {
      for (final entry in _store.entries.toList()) {
        final chatId = entry.key;
        final s = entry.value;
        final token = s.token;
        if (token == null || s.watched.isEmpty) continue;

        for (final id in s.watched.keys.toList()) {
          try {
            final order = await _api.order(token, int.parse(id));
            final status = order['status'] as Map? ?? const {};
            final key = status['key']?.toString() ?? '';
            if (key != s.watched[id]) {
              // Record the status only after the message went out, so a
              // failed send is retried on the next poll instead of lost.
              await _tg.send(
                  chatId,
                  T.statusChanged(
                      order['code'].toString(), labelOf(status['label'])));
              s.watched[id] = key;
              await _maybeOffer(chatId, s, token, order);
            }
            if (status['is_terminal'] == true) s.watched.remove(id);
          } on MasarFailure catch (e) {
            if (e.code == Masar.unauthenticated) {
              s.signOut();
              await _tg.send(chatId, T.sessionExpired,
                  markup: Telegram.removeKeyboard);
              break;
            }
          } catch (e) {
            stderr.writeln('poll order $id: $e');
          }
        }
      }
      await _store.save();
    } finally {
      _polling = false;
    }
  }

  Future<void> _maybeOffer(
      int chatId, Session s, String token, Map<String, dynamic> order) async {
    final orderId = order['id'] as int;
    final Map<String, dynamic> offer;
    try {
      offer = await _api.offer(token, orderId);
    } on MasarFailure {
      return; // No offer for this order.
    }
    final offerId = offer['id'] as int?;
    if (offerId == null ||
        offer['status'] != _offerOpen ||
        s.shownOffers.contains(offerId)) {
      return;
    }
    s.shownOffers.add(offerId);
    await _tg.send(
      chatId,
      T.offer(order['code'].toString(), moneyOf(offer['total'])),
      markup: Telegram.inline([
        [
          (T.approve, 'oa:$orderId:$offerId'),
          (T.reject, 'or:$orderId:$offerId')
        ],
      ]),
    );
  }
}

String? _joinOrNull(List<String?> parts) {
  final text = parts
      .whereType<String>()
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .join(' - ');
  return text.isEmpty ? null : text;
}

/// Telegram shares numbers with the country code, often without "+".
String normalizePhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('00')) return '+${digits.substring(2)}';
  if (digits.startsWith('0')) return '+970${digits.substring(1)}';
  return '+$digits';
}

/// Reads "lat, lng" from typed text or a maps link (Telegram Desktop and
/// Web cannot share a location). Returns null when nothing valid is found.
(double, double)? parseCoordinates(String text) {
  final match =
      RegExp(r'(-?\d{1,2}\.\d+)\s*,\s*(-?\d{1,3}\.\d+)').firstMatch(text);
  if (match == null) return null;
  final lat = double.parse(match.group(1)!);
  final lng = double.parse(match.group(2)!);
  if (lat.abs() > 90 || lng.abs() > 180) return null;
  return (lat, lng);
}
