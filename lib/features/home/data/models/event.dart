import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/pricing.dart';

class Event {
  final String event_id;
  final String event_name;
  final String event_date;
  final String cover_image_url;
  final String venue;
  final String region;
  final String max_sit;
  final String deadline;
  final String event_description;
  final List<EventCategory> category;
  final String status;
  final List<EventPricing> pricing;
  final String event_name_slug;

  Event(
      {required this.event_id,
      required this.event_name,
      required this.event_date,
      required this.cover_image_url,
      required this.venue,
      required this.region,
      required this.max_sit,
      required this.deadline,
      required this.event_description,
      required this.category,
      required this.status,
      required this.pricing,
      required this.event_name_slug});

  factory Event.fromJson(Map<String, dynamic> json) {
    List<EventPricing> eventPricingList = [];
    if (json['pricing'] != null) {
      eventPricingList = (json['pricing'] as List)
          .map((pricingJson) => EventPricing.fromJson(pricingJson))
          .toList();
    }
    List<EventCategory> eventCategoryList = [];
    if (json['event_category_id'] != null) {
      eventCategoryList = (json['event_category_id'] as List)
          .map((categoryJson) => EventCategory.fromJson(categoryJson))
          .toList();
    }
    return Event(
        event_id: json['_id']?.toString() ?? '',
        event_name: json['event_name']?.toString() ?? '',
        event_date: json['event_date']?.toString() ?? '',
        cover_image_url: json['cover_image_url']?.toString() ?? '',
        venue: json['venue']?.toString() ?? '',
        region: json['region']?.toString() ?? '',
        max_sit: json['max_sit']?.toString() ?? '',
        deadline: json['deadline']?.toString() ?? '',
        event_description: json['event_description']?.toString() ?? '',
        category: eventCategoryList,
        status: json['status']?.toString() ?? '',
        pricing: eventPricingList,
        event_name_slug: json['event_name_slug']?.toString() ?? '');
  }
}
