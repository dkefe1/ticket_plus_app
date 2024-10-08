import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/globals.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signin/data/models/login.dart';
import 'package:http/http.dart' as http;

class LoginRemoteDataSource {
  final pref = PrefService();
  Future<void> loginAttendee(Login login) async {
    var headerslist = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${baseUrl}/api/v1/attendees/login');
    var body = {"phone_number": login.phone_number, "password": login.password};

    try {
      var response =
          await http.post(url, headers: headerslist, body: json.encode(body));
      var resBody = response.body;

      final data = json.decode(resBody);
      if (data["status"].toString() == "SUCCESS") {
        await pref.storeToken(data["token"]);
        await pref.storeName(data["data"]["attendee"]["full_name"]);
        await pref.storePhone(data["data"]["attendee"]["phone_number"]);
        print(data["message"]);
      } else {
        print("Error:${data["message"]}");
        throw data["message"];
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
      print(e.toString());
      throw e;
    }
  }
}
