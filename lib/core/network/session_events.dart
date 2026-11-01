import 'dart:async';

import '../storage/secure_token_storage.dart';

class SessionEvents {
  final StreamController<SessionRole> _controller =
      StreamController<SessionRole>.broadcast();

  Stream<SessionRole> get unauthorized => _controller.stream;

  void emitUnauthorized(SessionRole role) => _controller.add(role);
}
