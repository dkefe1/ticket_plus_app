import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/globals.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/auth/signup/data/models/signUp.dart';
import 'package:http/http.dart' as http;

class SignupRemoteDatasource {
  final pref = PrefService();

  Future<bool> signupAttendee(SignUp signUp) async {
    var headerslist = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${baseUrl}/api/v1/attendees');

    var body = {
      "first_name": signUp.first_name,
      "last_name": signUp.last_name,
      "phone_number": signUp.phone_number,
      "date_of_birth": signUp.date_of_birth,
      "password": signUp.password,
      "password_confirm": signUp.password_confirm
    };

    try {
      var response =
          await http.post(url, headers: headerslist, body: json.encode(body));
      final resBody = response.body;

      final data = json.decode(resBody);

      if (data["status"].toString() == "SUCCESS") {
        bool agreeTerms = data["data"]["attendee"]["aggree_terms"];
        print(agreeTerms.toString());
        return agreeTerms;
      } else {
        print(response.statusCode);
        print(data["message"]);
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
