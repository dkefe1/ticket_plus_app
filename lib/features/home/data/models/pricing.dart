class EventPricing {
  final String sit_type;
  final String price;
  final String benefits;

  EventPricing(
      {required this.sit_type, required this.price, required this.benefits});

  factory EventPricing.fromJson(Map<String, dynamic> json) {
    return EventPricing(
        sit_type: json['sit_type']?.toString() ?? '',
        price: json['price']?.toString() ?? '',
        benefits: json['benefits']?.toString() ?? '');
  }
}
