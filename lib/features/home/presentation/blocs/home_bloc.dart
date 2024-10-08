import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/features/home/data/models/bookmark.dart';
import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/checkout.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/data/models/getBookmark.dart';
import 'package:ticketing_app/features/home/data/models/profile.dart';
import 'package:ticketing_app/features/home/data/models/returnRequest.dart';
import 'package:ticketing_app/features/home/data/models/returnTicket.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/data/repositories/homeRepository.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_state.dart';

class EventBloc extends Bloc<EventListEvent, EventState> {
  HomeRepository homeRepository;
  EventBloc(this.homeRepository) : super(EventInitialState()) {
    on<GetEventListEvent>(_onGetEventListEvent);
    on<GetEventCategoryEvent>(_onGetEventCategoryEvent);
    on<GetRecommendedEventListEvent>(_onGetRecommendedEventListEvent);
    on<GetUpcomingEventListEvent>(_onGetUpcomingEventListEvent);
    on<GetSearchEvent>(_onGetSearchEvent);
  }

  void _onGetEventListEvent(GetEventListEvent event, Emitter emit) async {
    emit(EventLoadingState());
    try {
      List<Event> event = await homeRepository.getEvent();
      emit(EventSuccessfulState(event));
    } catch (e) {
      emit(EventFailureState(e.toString()));
    }
  }

  void _onGetEventCategoryEvent(
      GetEventCategoryEvent event, Emitter emit) async {
    emit(EventCategoryLoadingState());
    try {
      List<EventCategory> category = await homeRepository.getEventCategory();
      emit(EventCategorySuccessfulState(category));
    } catch (e) {
      emit(EventCategoryFailureState(e.toString()));
    }
  }

  void _onGetRecommendedEventListEvent(
      GetRecommendedEventListEvent event, Emitter emit) async {
    emit(RecommendedEventLoadingState());
    try {
      List<TicketEventModel> recommendedEvent =
          await homeRepository.getRecommendedEvent();
      emit(RecommendedEventSuccessfulState(recommendedEvent));
    } catch (e) {
      emit(RecommendedEventFailureState(e.toString()));
    }
  }

  void _onGetUpcomingEventListEvent(
      GetUpcomingEventListEvent event, Emitter emit) async {
    emit(UpcomingEventLoadingState());
    try {
      List<Event> upcomingEvent = await homeRepository.getUpcomingEvent();
      emit(UpcomingEventSuccessfulState(upcomingEvent));
    } catch (e) {
      emit(UpcomingEventFailureState(e.toString()));
    }
  }

  void _onGetSearchEvent(GetSearchEvent event, Emitter emit) async {
    emit(SearchEventLoadingState());
    try {
      List<Event> searchEvent =
          await homeRepository.searchEvent(event.searchText);
      emit(SearchEventSuccessfulState(searchEvent));
    } catch (e) {
      emit(SearchEventFailureState(e.toString()));
    }
  }
}

class PromotionalEventBloc
    extends Bloc<PromotionalEventListEvent, PromotionalEventState> {
  HomeRepository homeRepository;
  PromotionalEventBloc(this.homeRepository)
      : super(PromotionalEventInitialState()) {
    on<GetPromotionalEventList>(_onGetPromotionalEventList);
  }

  void _onGetPromotionalEventList(
      GetPromotionalEventList event, Emitter emit) async {
    emit(PromotionalEventLoadingState());
    try {
      List<Event> event = await homeRepository.getPromotionalEvent();
      emit(PromotionalEventSuccessfulState(event));
    } catch (e) {
      emit(PromotionalEventFailureState(e.toString()));
    }
  }
}

class BuyTicketBloc extends Bloc<BuyTicketEvent, BuyTicketState> {
  HomeRepository homeRepository;
  BuyTicketBloc(this.homeRepository) : super(BuyTicketInitialState()) {
    on<PostBuyTicketEvent>(_onPostBuyTicketEvent);
  }

  void _onPostBuyTicketEvent(PostBuyTicketEvent event, Emitter emit) async {
    emit(BuyTicketLoadingState());
    try {
      Checkout checkout = await homeRepository.buyTicket(event.buyTicket);
      emit(BuyTicketSuccessfulState(checkout));
    } catch (e) {
      print(e.toString());
      emit(BuyTicketFailureState(e.toString()));
    }
  }
}

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  HomeRepository homeRepository;

  TicketBloc(this.homeRepository) : super(GetTicketInitialState()) {
    on<GetTicketEvent>(_onGetTicketEvent);
  }

  void _onGetTicketEvent(GetTicketEvent event, Emitter emit) async {
    emit(GetTicketLoadingState());
    try {
      List<TicketModel> ticket = await homeRepository.getTicket();
      emit(GetTicketSuccessfulState(ticket));
    } catch (e) {
      emit(GetTicketFailureState(e.toString()));
    }
  }
}

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  HomeRepository homeRepository;
  BookmarkBloc(this.homeRepository) : super(BookmarkInitialState()) {
    on<PostBookmarkEvent>(_onPostBookmarkEvent);
    on<GetBookmarkEvent>(_onGetBookmarkEvent);
    on<DeleteBookmarkEvent>(_onDeleteBookmarkEvent);
  }

  void _onPostBookmarkEvent(PostBookmarkEvent event, Emitter emit) async {
    emit(BookmarkLoadingState());
    try {
      Bookmark bookmark = await homeRepository.addBookmark(event.bookmark);
      emit(BookmarkSuccessfulState(bookmark));
    } catch (e) {
      emit(BookmarkFailureState(e.toString()));
    }
  }

  void _onGetBookmarkEvent(GetBookmarkEvent event, Emitter emit) async {
    emit(GetBookmarkLoadingState());
    try {
      List<GetBookmarkModel> bookmarks = await homeRepository.getBookmark();
      emit(GetBookmarkSuccessfulState(bookmarks));
    } catch (e) {
      emit(GetBookmarkFailureState(e.toString()));
    }
  }

  void _onDeleteBookmarkEvent(DeleteBookmarkEvent event, Emitter emit) async {
    emit(DeleteBookmarkLoadingState());
    try {
      await homeRepository.removeBookmark(event.deleteId);
      emit(DeleteBookmarkSuccessfulState());
    } catch (e) {
      emit(DeleteBookmarkFailureState(e.toString()));
    }
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  HomeRepository homeRepository;
  ProfileBloc(this.homeRepository) : super(ProfileInitialState()) {
    on<GetProfileEvent>(_onGetProfile);
  }

  void _onGetProfile(GetProfileEvent event, Emitter emit) async {
    emit(ProfileLoadingState());
    try {
      Profile profile = await homeRepository.getAttendeeProfile();
      emit(ProfileSuccessfulState(profile));
    } catch (e) {
      emit(ProfileFailureState(e.toString()));
    }
  }
}

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  HomeRepository profileRepository;
  UpdateProfileBloc(this.profileRepository)
      : super(UpdateProfileInitialState()) {
    on<PatchUpdateProfileEvent>(_onPatchUpdateProfileEvent);
  }
  void _onPatchUpdateProfileEvent(
      PatchUpdateProfileEvent event, Emitter emit) async {
    emit(UpdateProfileLoadingState());
    try {
      await profileRepository.updateProfile(event.updateProfile);
      emit(UpdateProfileSuccessfulState());
    } catch (e) {
      emit(UpdateProfileFailureState(e.toString()));
    }
  }
}

class RequestReturnBloc extends Bloc<RequestReturnEvent, RequestReturnState> {
  HomeRepository homeRepository;
  RequestReturnBloc(this.homeRepository) : super(RequestReturnInitialState()) {
    on<PostRequestReturnEvent>(_onPostRequestReturnEvent);
  }
  void _onPostRequestReturnEvent(
      PostRequestReturnEvent event, Emitter emit) async {
    emit(RequestReturnLoadingState());
    try {
      print("11111111111111 prints");
      RequestReturn requestReturn =
          await homeRepository.requestReturn(event.requestReturn);
      print("55555555555 doesn't print");
      emit(RequestReturnSuccessfulState(requestReturn));
      print("object");
    } catch (e) {
      emit(RequestReturnFailureState(e.toString()));
    }
  }
}

class ReturnRequestBloc extends Bloc<ReturnTicketEvent, ReturnTicketState> {
  HomeRepository homeRepository;
  ReturnRequestBloc(this.homeRepository) : super(ReturnTicketInitialState()) {
    on<GetReturnTicketEvent>(_onGetReturnTicketEvent);
  }

  void _onGetReturnTicketEvent(GetReturnTicketEvent event, Emitter emit) async {
    emit(ReturnTicketLoadingState());
    try {
      List<ReturnTicket> request = await homeRepository.getReturnRequests();
      emit(ReturnTicketSuccessfulState(request));
    } catch (e) {
      emit(ReturnTicketFailureState(e.toString()));
    }
  }
}

class CancelRequestBloc extends Bloc<CancelRequestEvent, CancelRequestState> {
  HomeRepository homeRepository;
  CancelRequestBloc(this.homeRepository)
      : super((CancelReturnRequestInitialState())) {
    on<CancelReturnRequestEvent>(_onCancelReturnRequestEvent);
  }
  void _onCancelReturnRequestEvent(
      CancelReturnRequestEvent event, Emitter emit) async {
    emit(CancelReturnRequestLoadingState());
    try {
      homeRepository.cancelRefund(event.requestId);
      emit(CancelReturnRequestSuccessfulState());
    } catch (e) {
      emit(CancelReturnRequestFailureState(e.toString()));
    }
  }
}
