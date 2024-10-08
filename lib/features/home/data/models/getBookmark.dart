import 'package:ticketing_app/features/home/data/models/pricing.dart';

class GetBookmarkModel {
  final String id;
  final String user_id;
  final List<BookmarkEventModel> event;
  GetBookmarkModel(
      {required this.id, required this.user_id, required this.event});

  factory GetBookmarkModel.fromJson(Map<String, dynamic> json) {
    List<BookmarkEventModel> eventList = [];
    if (json['event_id'] != null) {
      eventList = (json['event_id'] as List)
          .map((eventJson) => BookmarkEventModel.fromJson(eventJson))
          .toList();
    }
    return GetBookmarkModel(
        id: json['_id']?.toString() ?? '',
        user_id: json['user_id']?.toString() ?? '',
        event: eventList);
  }
}

class BookmarkEventModel {
  final String event_id;
  final String event_name;
  final String event_date;
  final String cover_image_url;
  final String venue;
  final String region;
  final String max_sit;
  final String deadline;
  final String event_description;
  final String status;
  final List<EventPricing> pricing;
  final String event_name_slug;
///////////////The category is causing error on the main Event model.
  BookmarkEventModel(
      {required this.event_id,
      required this.event_name,
      required this.event_date,
      required this.cover_image_url,
      required this.venue,
      required this.region,
      required this.max_sit,
      required this.deadline,
      required this.event_description,
      required this.status,
      required this.pricing,
      required this.event_name_slug});

  factory BookmarkEventModel.fromJson(Map<String, dynamic> json) {
    List<EventPricing> eventPricingList = [];
    if (json['pricing'] != null) {
      eventPricingList = (json['pricing'] as List)
          .map((pricingJson) => EventPricing.fromJson(pricingJson))
          .toList();
    }

    return BookmarkEventModel(
        event_id: json['_id']?.toString() ?? '',
        event_name: json['event_name']?.toString() ?? '',
        event_date: json['event_date']?.toString() ?? '',
        cover_image_url: json['cover_image_url']?.toString() ?? '',
        venue: json['venue']?.toString() ?? '',
        region: json['region']?.toString() ?? '',
        max_sit: json['max_sit']?.toString() ?? '',
        deadline: json['deadline']?.toString() ?? '',
        event_description: json['event_description']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        pricing: eventPricingList,
        event_name_slug: json['event_name_slug']?.toString() ?? '');
  }
}
