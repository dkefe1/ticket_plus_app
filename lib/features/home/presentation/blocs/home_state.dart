import 'package:ticketing_app/features/home/data/models/bookmark.dart';
import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/checkout.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/data/models/getBookmark.dart';
import 'package:ticketing_app/features/home/data/models/profile.dart';
import 'package:ticketing_app/features/home/data/models/returnRequest.dart';
import 'package:ticketing_app/features/home/data/models/returnTicket.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';

abstract class EventState {}

class EventInitialState extends EventState {}

class EventLoadingState extends EventState {}

class EventSuccessfulState extends EventState {
  final List<Event> event;
  EventSuccessfulState(this.event);
}

class EventFailureState extends EventState {
  final String error;
  EventFailureState(this.error);
}

class EventCategoryInitialState extends EventState {}

class EventCategoryLoadingState extends EventState {}

class EventCategorySuccessfulState extends EventState {
  final List<EventCategory> category;
  EventCategorySuccessfulState(this.category);
}

class EventCategoryFailureState extends EventState {
  final String error;
  EventCategoryFailureState(this.error);
}

class RecommendedEventInitialState extends EventState {}

class RecommendedEventLoadingState extends EventState {}

class RecommendedEventSuccessfulState extends EventState {
  final List<TicketEventModel> event;
  RecommendedEventSuccessfulState(this.event);
}

class RecommendedEventFailureState extends EventState {
  final String error;
  RecommendedEventFailureState(this.error);
}

class UpcomingEventLoadingState extends EventState {}

class UpcomingEventSuccessfulState extends EventState {
  final List<Event> event;
  UpcomingEventSuccessfulState(this.event);
}

class UpcomingEventFailureState extends EventState {
  final String error;
  UpcomingEventFailureState(this.error);
}

class SearchEventLoadingState extends EventState {}

class SearchEventSuccessfulState extends EventState {
  final List<Event> event;
  SearchEventSuccessfulState(this.event);
}

class SearchEventFailureState extends EventState {
  final String error;
  SearchEventFailureState(this.error);
}

abstract class PromotionalEventState {}

class PromotionalEventInitialState extends PromotionalEventState {}

class PromotionalEventLoadingState extends PromotionalEventState {}

class PromotionalEventSuccessfulState extends PromotionalEventState {
  final List<Event> event;
  PromotionalEventSuccessfulState(this.event);
}

class PromotionalEventFailureState extends PromotionalEventState {
  final String error;
  PromotionalEventFailureState(this.error);
}

abstract class BuyTicketState {}

class BuyTicketInitialState extends BuyTicketState {}

class BuyTicketLoadingState extends BuyTicketState {}

class BuyTicketSuccessfulState extends BuyTicketState {
  final Checkout checkout;
  BuyTicketSuccessfulState(this.checkout);
}

class BuyTicketFailureState extends BuyTicketState {
  final String error;
  BuyTicketFailureState(this.error);
}

abstract class TicketState {}

class GetTicketInitialState extends TicketState {}

class GetTicketLoadingState extends TicketState {}

class GetTicketSuccessfulState extends TicketState {
  final List<TicketModel> ticket;
  GetTicketSuccessfulState(this.ticket);
}

class GetTicketFailureState extends TicketState {
  final String error;
  GetTicketFailureState(this.error);
}

abstract class BookmarkState {}

class BookmarkInitialState extends BookmarkState {}

class BookmarkLoadingState extends BookmarkState {}

class BookmarkSuccessfulState extends BookmarkState {
  final Bookmark bookmark;
  BookmarkSuccessfulState(this.bookmark);
}

class BookmarkFailureState extends BookmarkState {
  final String error;
  BookmarkFailureState(this.error);
}

class GetBookmarkLoadingState extends BookmarkState {}

class GetBookmarkSuccessfulState extends BookmarkState {
  final List<GetBookmarkModel> bookmarks;
  GetBookmarkSuccessfulState(this.bookmarks);
}

class GetBookmarkFailureState extends BookmarkState {
  final String error;
  GetBookmarkFailureState(this.error);
}

class DeleteBookmarkLoadingState extends BookmarkState {}

class DeleteBookmarkSuccessfulState extends BookmarkState {}

class DeleteBookmarkFailureState extends BookmarkState {
  final String error;
  DeleteBookmarkFailureState(this.error);
}

//Profile related States

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessfulState extends ProfileState {
  final Profile profile;
  ProfileSuccessfulState(this.profile);
}

class ProfileFailureState extends ProfileState {
  final String error;
  ProfileFailureState(this.error);
}

abstract class UpdateProfileState {}

class UpdateProfileInitialState extends UpdateProfileState {}

class UpdateProfileLoadingState extends UpdateProfileState {}

class UpdateProfileSuccessfulState extends UpdateProfileState {}

class UpdateProfileFailureState extends UpdateProfileState {
  final String error;
  UpdateProfileFailureState(this.error);
}

abstract class RequestReturnState {}

class RequestReturnInitialState extends RequestReturnState {}

class RequestReturnLoadingState extends RequestReturnState {}

class RequestReturnSuccessfulState extends RequestReturnState {
  final RequestReturn requestReturn;
  RequestReturnSuccessfulState(this.requestReturn);
}

class RequestReturnFailureState extends RequestReturnState {
  final String error;
  RequestReturnFailureState(this.error);
}

abstract class ReturnTicketState {}

class ReturnTicketInitialState extends ReturnTicketState {}

class ReturnTicketLoadingState extends ReturnTicketState {}

class ReturnTicketSuccessfulState extends ReturnTicketState {
  final List<ReturnTicket> returnRequest;
  ReturnTicketSuccessfulState(this.returnRequest);
}

class ReturnTicketFailureState extends ReturnTicketState {
  final String error;
  ReturnTicketFailureState(this.error);
}

abstract class CancelRequestState {}

class CancelReturnRequestInitialState extends CancelRequestState {}

class CancelReturnRequestLoadingState extends CancelRequestState {}

class CancelReturnRequestSuccessfulState extends CancelRequestState {}

class CancelReturnRequestFailureState extends CancelRequestState {
  final String error;
  CancelReturnRequestFailureState(this.error);
}
