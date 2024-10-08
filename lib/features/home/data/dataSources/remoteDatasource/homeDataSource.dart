import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/globals.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/home/data/models/bookmark.dart';
import 'package:ticketing_app/features/home/data/models/category.dart';
import 'package:ticketing_app/features/home/data/models/checkout.dart';
import 'package:ticketing_app/features/home/data/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:ticketing_app/features/home/data/models/getBookmark.dart';
import 'package:ticketing_app/features/home/data/models/profile.dart';
import 'package:ticketing_app/features/home/data/models/buyTicket.dart';
import 'package:ticketing_app/features/home/data/models/returnRequest.dart';
import 'package:ticketing_app/features/home/data/models/returnTicket.dart';
import 'package:ticketing_app/features/home/data/models/ticket.dart';
import 'package:ticketing_app/features/home/data/models/updateProfile.dart';

class HomeRemoteDataSource {
  final pref = PrefService();

  Future<List<Event>> getEvent() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}/api/v1/events/active');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());

    try {
      if (data['status'].toString() == "SUCCESS") {
        final List<dynamic> eventList = data['data']['events'];

        List<Event> event = eventList.map((eventJson) {
          return Event.fromJson(eventJson);
        }).toList();

        return event;
      } else {
        print(response.statusCode);
        print(data['status']);
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Event: " + e.toString());
      throw e;
    }
  }

  Future<List<Event>> getPromotionalEvent() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/promotionalevent/published');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> eventList = data['data']['promotionalEvents'];

        List<Event> event = eventList.map((eventJson) {
          return Event.fromJson(eventJson);
        }).toList();

        return event;
      } else {
        print(response.statusCode);
        print(data['status']);
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Promotional Event: " + e.toString());
      throw e;
    }
  }

  Future<Checkout> buyTicket(BuyTicket ticket) async {
    var token = await pref.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}/api/v1/eventticket');

    var body = json.encode({
      "total_price": ticket.total_price,
      "phone_number": ticket.phone_number,
      "inputs": [
        {
          "phone_number": ticket.inputs.phone_number,
          "ticket_type": ticket.inputs.ticket_type,
          "sit_type": ticket.inputs.sit_type,
        }
      ],
      "event_id": ticket.event_id
    });

    var response = await http.post(url, headers: headersList, body: body);

    var resBody = response.body;

    var data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        print("Paid Successfully!");
        final Checkout checkout = Checkout.fromJson(data);
        return checkout;
      } else {
        print(data['status']);
        print(data['message']);
        throw response.statusCode;
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Buy Ticket: " + e.toString());
      throw e;
    }
  }

  Future<List<EventCategory>> getEventCategory() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}/api/v1/eventcategories/active');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == "SUCCESS") {
        final List<dynamic> category = data['data']['event_categories'];

        List<EventCategory> eventCategories = category.map((catJson) {
          return EventCategory.fromJson(catJson);
        }).toList();
        print(data.toString());

        return eventCategories;
      } else {
        print(data.toString());
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Event Category: " + e.toString());
      throw e;
    }
  }

  Future<List<TicketEventModel>> getRecommendedEvents() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/recommended');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> eventList = data['data']['recommendeds'];

        List<TicketEventModel> event = eventList.map((eventJson) {
          return TicketEventModel.fromJson(eventJson);
        }).toList();

        return event;
      } else {
        print(response.statusCode);
        print(data['status']);
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Recommended Event: " + e.toString());
      throw e;
    }
  }

  Future<List<Event>> getUpcomingEvents() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/events/upcomming');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> eventList = data['data']['events'];

        List<Event> event = eventList.map((eventJson) {
          return Event.fromJson(eventJson);
        }).toList();

        return event;
      } else {
        print(response.statusCode);
        print(data['status']);
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Upcoming Event: " + e.toString());
      throw e;
    }
  }

  Future<List<Event>> searchEvent(String searchText) async {
    var token = await pref.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/events/search?text=${searchText}');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> eventList = data['data']['events'];

        List<Event> event = eventList.map((eventJson) {
          return Event.fromJson(eventJson);
        }).toList();

        return event;
      } else {
        print(response.statusCode);
        print(data['status']);
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Upcoming Event: " + e.toString());
      throw e;
    }
  }

  Future addBookmark(Bookmark bookmark) async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/bookmarks');

    var body = {
      'event_id': bookmark.event_id,
    };

    var response =
        await http.post(url, headers: headersList, body: json.encode(body));

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        print(data['message']);
      } else {
        throw data['message'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Add Bookmark: " + e.toString());
      throw e;
    }
  }

  Future<List<GetBookmarkModel>> getBookmark() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('$baseUrl/api/v1/bookmarks');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    print("");
    print(data.toString());
    print("");

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> bookmarks = data['data']['bookmarks'];
        print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
        List<GetBookmarkModel> bookmarkList = bookmarks.map((bookJson) {
          return GetBookmarkModel.fromJson(bookJson);
        }).toList();
        print("--------------------------------------------------");

        return bookmarkList;
      } else {
        throw data['message'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Get Bookmark: " + e.toString());
      throw e;
    }
  }

  Future removeBookmark(String deleteId) async {
    var token = await pref.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/bookmarks/${deleteId}');

    var response = await http.delete(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        print(data['message']);
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Remove Bookmark: " + e.toString());
      throw e;
    }
  }

  Future<List<TicketModel>> getTicket() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/eventticket');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());
    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> tickets = data['data']['tickets'];
        List<TicketModel> ticketsList = tickets.map((ticketJson) {
          return TicketModel.fromJson(ticketJson);
        }).toList();

        return ticketsList;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Load Tickets: " + e.toString());
      throw e;
    }
  }

  //Profile

  Future<Profile> getProfile() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/attendees/profile');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final Profile profileInfo = Profile.fromJson(data['data']['attendee']);
        return profileInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Load Profile: " + e.toString());
      throw e;
    }
  }

  Future updateProfile(UpdateProfile updateProfile) async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}/api/v1/attendees/profile');

    var body = {
      "first_name": updateProfile.first_name,
      "last_name": updateProfile.last_name,
      "phone_number": updateProfile.phone_number,
      "date_of_birth": updateProfile.date_of_birth
    };

    var response =
        await http.patch(url, headers: headersList, body: json.encode(body));
    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == "SUCCESS") {
        print(data['status']);
      } else {
        print(response.statusCode);
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Update Profile: " + e.toString());
      throw e;
    }
  }

  Future requestReturn(RequestReturn returnRequest) async {
    var token = await pref.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}/api/v1/refundrequest');

    var body = json.encode({
      "event_id": returnRequest.event_id,
      "bank_number": returnRequest.bank_number,
      "cause": returnRequest.cause
    });

    try {
      var response = await http.post(url, headers: headersList, body: body);
      var resBody = response.body;
      print('Response Body: $resBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(resBody);
        print('Response Data: $data');

        if (data['status'].toString().toUpperCase() == 'SUCCESS') {
          print("Return Request successfully sent!");
          // Parse and return data if needed
        } else {
          print('Error Message: ${data['message']}');
          throw Exception(data['message']);
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Failed to Request Return: $e");
      throw e;
    }
  }

  Future<List<ReturnTicket>> getReturnRequests() async {
    var token = await pref.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('${baseUrl}/api/v1/refundrequest');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);
    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        final List<dynamic> returnedTickets = data['data']['refundTickets'];
        List<ReturnTicket> returnedTicketsList =
            returnedTickets.map((returnJson) {
          return ReturnTicket.fromJson(returnJson);
        }).toList();

        return returnedTicketsList;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Load Refund Requests: " + e.toString());
      throw e;
    }
  }

  Future cancelRefund(String requestId) async {
    var token = await pref.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url =
        Uri.parse('${baseUrl}/api/v1/refundrequest/attendee/${requestId}');

    var response = await http.delete(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == 'SUCCESS') {
        print(data['message']);
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print("Failed to Cancel Refund Request: " + e.toString());
      throw e;
    }
  }
}
