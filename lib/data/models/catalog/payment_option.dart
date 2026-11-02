import '../masar/masar_models.dart';

/// A way to pay at checkout; a bank transfer names the store's gateway.
class PaymentOption {
  const PaymentOption({required this.method, this.gateway});

  final String method;
  final StoreGateway? gateway;

  bool same(PaymentOption other) =>
      method == other.method && gateway?.id == other.gateway?.id;
}
