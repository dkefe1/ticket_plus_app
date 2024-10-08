import 'package:ticketing_app/features/home/data/dataSources/remoteDatasource/homeDataSource.dart';
import 'package:ticketing_app/features/home/data/models/bookmark.dart';
import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/checkout.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:ticketing_app/features/home/data/models/getBookmark.dart';
import 'package:ticketing_app/features/home/data/models/profile.dart';
import 'package:ticketing_app/features/home/data/models/buyTicket.dart';
import 'package:ticketing_app/features/home/data/models/returnRequest.dart';
import 'package:ticketing_app/features/home/data/models/returnTicket.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/data/models/updateProfile.dart';

class HomeRepository {
  HomeRemoteDataSource homeRemoteDataSource;
  HomeRepository(this.homeRemoteDataSource);

  Future<List<Event>> getEvent() async {
    try {
      final event = await homeRemoteDataSource.getEvent();
      return event;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Event>> getPromotionalEvent() async {
    try {
      final event = await homeRemoteDataSource.getPromotionalEvent();
      return event;
    } catch (e) {
      throw e;
    }
  }

  Future<List<TicketEventModel>> getRecommendedEvent() async {
    try {
      final event = await homeRemoteDataSource.getRecommendedEvents();
      return event;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Event>> getUpcomingEvent() async {
    try {
      final event = await homeRemoteDataSource.getUpcomingEvents();
      return event;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Event>> searchEvent(String searchText) async {
    try {
      final event = await homeRemoteDataSource.searchEvent(searchText);
      return event;
    } catch (e) {
      throw e;
    }
  }

  Future<Checkout> buyTicket(BuyTicket ticket) async {
    try {
      final checkoutURL = await homeRemoteDataSource.buyTicket(ticket);
      return checkoutURL;
    } catch (e) {
      throw e;
    }
  }

  Future<List<TicketModel>> getTicket() async {
    try {
      final ticket = await homeRemoteDataSource.getTicket();
      return ticket;
    } catch (e) {
      throw e;
    }
  }

  Future<List<EventCategory>> getEventCategory() async {
    try {
      final eventCat = await homeRemoteDataSource.getEventCategory();
      return eventCat;
    } catch (e) {
      throw e;
    }
  }

  Future addBookmark(Bookmark bookmark) async {
    try {
      await homeRemoteDataSource.addBookmark(bookmark);
    } catch (e) {
      throw e;
    }
  }

  Future<List<GetBookmarkModel>> getBookmark() async {
    try {
      final bookmarks = await homeRemoteDataSource.getBookmark();
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      return bookmarks;
    } catch (e) {
      throw e;
    }
  }

  Future removeBookmark(String deleteId) async {
    try {
      await homeRemoteDataSource.removeBookmark(deleteId);
    } catch (e) {
      throw e;
    }
  }

  Future<Profile> getAttendeeProfile() async {
    try {
      final profile = await homeRemoteDataSource.getProfile();
      return profile;
    } catch (e) {
      throw e;
    }
  }

  Future updateProfile(UpdateProfile updateProfile) async {
    try {
      await homeRemoteDataSource.updateProfile(updateProfile);
    } catch (e) {
      throw e;
    }
  }

  Future<RequestReturn> requestReturn(RequestReturn returnRequest) async {
    try {
      return await homeRemoteDataSource.requestReturn(returnRequest);
    } catch (e) {
      throw e;
    }
  }

  Future<List<ReturnTicket>> getReturnRequests() async {
    try {
      final requests = await homeRemoteDataSource.getReturnRequests();
      return requests;
    } catch (e) {
      throw e;
    }
  }

  Future cancelRefund(String deleteId) async {
    try {
      await homeRemoteDataSource.cancelRefund(deleteId);
    } catch (e) {
      throw e;
    }
  }
}
