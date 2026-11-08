import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/route_args.dart';
import '../../../core/constants/app_env.dart';
import '../../../data/models/catalog/picked_location.dart';
import '../../../data/models/masar/masar_models.dart';
import '../../../data/services/customer/address_service.dart';

/// A separate address chooser for AI drafts: the regular checkout address
/// picker requires CheckoutController, which doesn't exist yet in chat.
/// Returns ONLY a confirmed, saved Masar Address. On cancel it returns null.
class AiAddressSelectionScreen extends StatefulWidget {
  const AiAddressSelectionScreen({
    super.key, this.openMapImmediately = false, this.language,
  });

  final bool openMapImmediately;
  final String? language;

  @override
  State<AiAddressSelectionScreen> createState() =>
      _AiAddressSelectionScreenState();
}

class _AiAddressSelectionScreenState extends State<AiAddressSelectionScreen> {
  late Future<List<Address>> _addresses;
  bool _busy = false;

  bool get _arabic => (widget.language ?? Localizations.localeOf(context).languageCode) != 'en';
  String _tr(String ar, String en) => _arabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _reload();
    if (widget.openMapImmediately) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pickMap();
      });
    }
  }

  void _reload() {
    _addresses = Get.find<AddressService>().list().timeout(
      const Duration(seconds: 20),
    );
  }

  void _returnAddress(Address address) {
    if (!mounted) return;
    Get.back<Address>(result: address);
  }

  Future<void> _create({PickedLocation? point}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final address = await Get.toNamed<Address>(
        AppRoutes.checkoutAddressNew,
        arguments: AddressFormArgs(point: point),
      );
      if (!mounted) return;
      if (address != null) {
        _returnAddress(address);
      } else {
        setState(_reload);
      }
    } catch (_) {
      if (mounted) _showError();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickMap() async {
    if (_busy) return;
    if (!AppEnv.hasMaps) {
      _showError();
      return;
    }
    setState(() => _busy = true);
    try {
      // The real map returns a point; the real address form saves it through
      // Masar. Returning from the form takes the user back to the chat.
      final point = await Get.toNamed<PickedLocation>(AppRoutes.mapPicker);
      if (!mounted || point == null) return;
      // Release the guard before navigating into the address form.
      setState(() => _busy = false);
      await _create(point: point);
    } catch (_) {
      if (mounted) _showError();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_tr(
        'تعذّر فتح العناوين. جرّب مرة ثانية.',
        'Unable to open addresses. Please try again.',
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('اختار عنوان التوصيل', 'Select a delivery address')),
      ),
      body: FutureBuilder<List<Address>>(
        future: _addresses,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_tr('تعذّر تحميل العناوين', 'Could not load addresses')),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => setState(_reload),
                    child: Text(_tr('إعادة المحاولة', 'Retry')),
                  ),
                ],
              ),
            );
          }
          final addresses = snapshot.data ?? const <Address>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                _tr(
                  'اختار عنواناً محفوظاً، أو أضف عنواناً جديداً من الخريطة.',
                  'Choose a saved address or add a new one using the map.',
                ),
              ),
              const SizedBox(height: 12),
              if (addresses.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(_tr(
                    'ما عندك عناوين محفوظة بعد.',
                    'You have no saved addresses yet.',
                  )),
                ),
              for (final a in addresses)
                Card(
                  child: ListTile(
                    enabled: !_busy,
                    leading: Icon(a.isDefault
                        ? Icons.home_outlined : Icons.location_on_outlined),
                    title: Text((a.label ?? '').trim().isEmpty
                        ? _tr('عنوان محفوظ', 'Saved address')
                        : a.label!),
                    subtitle: a.details == null || a.details!.trim().isEmpty
                        ? null : Text(a.details!),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _returnAddress(a),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy ? null : _create,
                icon: const Icon(Icons.add_location_alt_outlined),
                label: Text(_tr('إضافة عنوان جديد', 'Add new address')),
              ),
              const SizedBox(height: 8),
              if (AppEnv.hasMaps)
                OutlinedButton.icon(
                  onPressed: _busy ? null : _pickMap,
                  icon: const Icon(Icons.map_outlined),
                  label: Text(_tr('اختار موقعاً على الخريطة', 'Pick on map')),
                ),
            ],
          );
        },
      ),
    );
  }
}
