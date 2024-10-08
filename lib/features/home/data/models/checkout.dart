class Checkout {
  final String tx_ref;
  final String checkout_url;
  Checkout({required this.tx_ref, required this.checkout_url});

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(tx_ref: json['tx_ref'], checkout_url: json['checkout_url']);
  }
}
