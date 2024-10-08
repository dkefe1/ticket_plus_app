import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/globals.dart';
import 'package:ticketing_app/core/services/sharedPreferenceServices.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedback.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedbackTitle.dart';
import 'package:ticketing_app/features/guidelines/data/models/privacyPolicy.dart';
import 'package:ticketing_app/features/guidelines/data/models/termsAndConditions.dart';
import 'package:http/http.dart' as http;

class GuidelineRemoteDataSource {
  final pref = PrefService();

  Future<List<TermsAndConditions>> getTermsAndConditions() async {
    var token = await pref.readToken();
    var headersList = {'Accept': '*/*', 'Authorization': 'Bearer ${token}'};

    var url = Uri.parse('${baseUrl}/api/v1/termsandconditions');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'] == 'SUCCESS') {
        final List<dynamic> termsAndConditions =
            data['data']['termsAndConditions'];
        List<TermsAndConditions> terms = termsAndConditions.map((termsJson) {
          return TermsAndConditions.fromJson(termsJson);
        }).toList();
        return terms;
      } else {
        print(data['status']);
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
      print(e.toString());
      throw e;
    }
  }

  Future<List<PrivacyPolicy>> getPrivacyPolicy() async {
    var token = await pref.readToken();
    var headersList = {'Accept': '*/*', 'Authorization': 'Bearer ${token}'};

    var url = Uri.parse('${baseUrl}/api/v1/privacy');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'] == 'SUCCESS') {
        final List<dynamic> privacyPolicy = data['data']['privacy'];
        List<PrivacyPolicy> privacy = privacyPolicy.map((privacyJson) {
          return PrivacyPolicy.fromJson(privacyJson);
        }).toList();
        return privacy;
      } else {
        print(data['status']);
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
      print(e.toString());
      throw e;
    }
  }

  Future<List<FeedbackTitle>> getFeedbackTitle() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};

    var url = Uri.parse('${baseUrl}/api/v1/feedbacktitle');

    var response = await http.get(url, headers: headersList);

    final resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (data['status'].toString().toUpperCase() == "SUCCESS") {
        List<dynamic> feedbacktitle = data['data']['feedbackTitles'];

        List<FeedbackTitle> titles = feedbacktitle.map((titleJson) {
          return FeedbackTitle.fromJson(titleJson);
        }).toList();
        return titles;
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
      print(e.toString());
      throw e;
    }
  }

  Future submitFeedback(FeedbackModel feedback) async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};

    var url = Uri.parse('${baseUrl}/api/v1/feedbacks');

    var body = {"title_id": feedback.title_id, "content": feedback.content};

    var response =
        await http.post(url, headers: headersList, body: json.encode(body));

    final resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());

    try {
      if (data['status'].toString().toUpperCase() == "SUCCESS") {
        print(data.toString());
        return data['message'];
      } else {
        print(response.statusCode);
        print(data.toString());
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
      print("createFeedback Error: ${e.toString()}");
      throw e;
    }
  }
}
