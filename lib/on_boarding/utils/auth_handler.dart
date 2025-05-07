import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/utils/constants.dart';

class AuthHandler {
  final API _api = API();

  registerUser(name, email, password, phone, qualification) async {
    try {
      var bytes = utf8.encode(password); // data being hashed
      var passHash = md5.convert(bytes);
      Response response = await _api.sendRequests.post("/post_user_data.php?user_name=$name&email=$email&password=$passHash&phone_no=$phone&qualification=$qualification");
      return response;
    } on DioException catch (e) {
      if (e.response!.statusCode == 409) {
        throw ("Oops! It seems like you already have an account with us. Try logging in!");
      } else if (e.response!.statusCode! >= 500) {
        throw ("Our servers are currently unavailable. We’re working to resolve the issue. Please try again later.");
      } else {
        throw ("Something went wrong. We’re working to resolve the issue.");
      }
    }
  }

  Future<Map<String, dynamic>> checkUser(email, password) async {
    try {
      var bytes = utf8.encode(password); // data being hashed
      var passHash = md5.convert(bytes);
      Response response = await _api.sendRequests.get("/check_user_data.php?email=$email&password=$passHash");
      return response.data;
    } on DioException catch (e) {
      // print(e.response!.statusCode);
      if (e.response != null && e.response?.statusCode == 404) {
        throw ("Are you trying to enter a secret level? Because that email doesn’t exist in our system!");
      } else if (e.response?.statusCode == 401) {
        throw ('Password fail! Did you let your cat walk on the keyboard again?');
      } else {
        throw ("Our servers are currently unavailable. We’re working to resolve the issue. Please try again later.");
      }
    }
  }

  saveUserData(userId, name, email, age, location, phoneNo, interests) async {
    try {
      Response response = await _api.sendRequests.get("/post_personal_data.php?user_id=$userId&name=$name&email=$email&age=$age&location=$location&phone_no=$phoneNo&interests=$interests");
      mixpanel!.track("PersonalInfoUpdated", properties: {
        "UserId": userId,
        "timeStamp": DateTime.now(),
        "data": <String, dynamic>{"name": name, "email": email, "age": age, "location": location, "phoneNo": phoneNo, "interests": interests}
      });
      return response;
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  saveUserQualification(qualification, instituteName, boardName, passingYear, percentage, isHighest, userId) async {
    try {
      Response response = await _api.sendRequests.get(
          "/post_qualification_details.php?user_id=$userId&qualification=$qualification&education_type=$qualification&institute_name=$instituteName&board_name=$boardName&passing_year=$passingYear&percentage=$percentage&is_highest=$isHighest");
      if (response.statusCode == 201) {
        snackBarKey.currentState?.showSnackBar(const SnackBar(content: AutoSizeText("Data saved successfully")));
      }
    } on DioException catch (e) {
      throw Exception(errorStrings(e.type));
    }
  }

  checkEmailForPasswordReset(String email) async {
    try {
      Response response = await _api.sendRequests.get('/check_email.php?user_id=46&email=$email');
      return response;
    } catch (e) {
      throw ("Something went wrong.");
    }
  }

  resetPassword(String email) async {
    try {
      Response response = await _api.sendRequests.get('/forgot_password.php?email=$email');
      return response;
    } catch (e) {
      log(e.toString());
      throw ("Something went wrong.");
    }
  }

  Future<int?> checkUserLogin(String email) async {
    try {
      Response response = await API().sendRequests.get("/check_email.php?email=$email");
      return response.statusCode;
    } on DioException catch (e) {
      if (e.response!.statusCode == 409) {
        return e.response!.statusCode;
      }
      return e.response!.statusCode;
    }
  }
}
