import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/pricing.dart';
import 'package:ticketing_app/features/home/data/models/profile.dart';

class TicketModel {
  final String id;
  final String phone_number;
  final String entrance_code;
  final String price;
  final TicketEventModel event;
  final String ticket_type;
  final Profile profile;
  final String sit_type;

  TicketModel(
      {required this.id,
      required this.phone_number,
      required this.entrance_code,
      required this.price,
      required this.event,
      required this.ticket_type,
      required this.profile,
      required this.sit_type});

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw Exception("No tickets found");
    }
    print('Event ID JSON: ${json['event_id']}');

    // Print the contents of bought_by
    print('Bought By JSON: ${json['bought_by']}');
    return TicketModel(
      id: json['_id']?.toString() ?? '',
      phone_number: json['phone_number']?.toString() ?? '',
      entrance_code: json['enterance_code']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      event: TicketEventModel.fromJson(json['event_id'] ?? {}),
      ticket_type: json['ticket_type']?.toString() ?? '',
      profile: Profile.fromJson(json['bought_by'] ?? {}),
      sit_type: json['sit_type']?.toString() ?? '',
    );
  }
}

class TicketEventModel {
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

  TicketEventModel(
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

  factory TicketEventModel.fromJson(Map<String, dynamic> json) {
    List<EventPricing> eventPricingList = [];
    if (json['pricing'] != null) {
      eventPricingList = (json['pricing'] as List)
          .map((pricingJson) => EventPricing.fromJson(pricingJson))
          .toList();
    }
    List<EventCategory> eventCategoryList = [];
    if (json['event_category_id'] != null) {
      eventCategoryList = (json['event_category_id'] as List).map((categoryId) {
        // Assuming categoryId is a String
        return EventCategory(
            id: categoryId,
            category_name: '',
            cover_image_url: '',
            is_active: '');
      }).toList();
    }
    return TicketEventModel(
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
