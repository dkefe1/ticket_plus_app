class EventCategory {
  final String id;
  final String category_name;
  final String cover_image_url;
  final String is_active;

  EventCategory(
      {required this.id,
      required this.category_name,
      required this.cover_image_url,
      required this.is_active});

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
        id: json['id']?.toString() ?? '',
        category_name: json['category_name']?.toString() ?? '',
        cover_image_url: json['cover_image_url']?.toString() ?? '',
        is_active: json['is_active']?.toString() ?? '');
  }
}
