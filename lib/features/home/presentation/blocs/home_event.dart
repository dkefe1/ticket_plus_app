import 'package:ticketing_app/features/home/data/models/bookmark.dart';
import 'package:ticketing_app/features/home/data/models/buyTicket.dart';
import 'package:ticketing_app/features/home/data/models/returnRequest.dart';
import 'package:ticketing_app/features/home/data/models/updateProfile.dart';

abstract class EventListEvent {}

class GetEventListEvent extends EventListEvent {}

class GetEventCategoryEvent extends EventListEvent {}

class GetRecommendedEventListEvent extends EventListEvent {}

class GetUpcomingEventListEvent extends EventListEvent {}

class GetSearchEvent extends EventListEvent {
  String searchText;
  GetSearchEvent(this.searchText);
}

abstract class PromotionalEventListEvent {}

class GetPromotionalEventList extends PromotionalEventListEvent {}

abstract class BuyTicketEvent {}

class PostBuyTicketEvent extends BuyTicketEvent {
  final BuyTicket buyTicket;
  PostBuyTicketEvent(this.buyTicket);
}

abstract class TicketEvent {}

class GetTicketEvent extends TicketEvent {}

abstract class BookmarkEvent {}

class PostBookmarkEvent extends BookmarkEvent {
  final Bookmark bookmark;
  PostBookmarkEvent(this.bookmark);
}

class GetBookmarkEvent extends BookmarkEvent {}

class DeleteBookmarkEvent extends BookmarkEvent {
  final String deleteId;
  DeleteBookmarkEvent(this.deleteId);
}

//Profile related Events
abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

abstract class UpdateProfileEvent {}

class PatchUpdateProfileEvent extends UpdateProfileEvent {
  final UpdateProfile updateProfile;
  PatchUpdateProfileEvent(this.updateProfile);
}

abstract class RequestReturnEvent {}

class PostRequestReturnEvent extends RequestReturnEvent {
  final RequestReturn requestReturn;
  PostRequestReturnEvent(this.requestReturn);
}

abstract class ReturnTicketEvent {}

class GetReturnTicketEvent extends ReturnTicketEvent {}

abstract class CancelRequestEvent {}

class CancelReturnRequestEvent extends CancelRequestEvent {
  final String requestId;
  CancelReturnRequestEvent(this.requestId);
}
