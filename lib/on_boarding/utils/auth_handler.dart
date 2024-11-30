import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gamify_test/api/api.dart';
import 'package:gamify_test/utils/constants.dart';

class AuthHandler{
  final API _api = API();

  registerUser(String name,String email,String password,String phone,String qualification) async {
    try {
      Response response = await _api.sendRequests.post("/post_user_data.php?user_name=$name&email=$email&password=$password&phone_no=$phone&qualification=$qualification");
      return response;
    } on DioException catch (e){
      if (e.response!.statusCode == 409) {
        throw "User already exists";
      } else if(e.response!.statusCode! >= 500){
        throw "Server down.";
      }
      else {
        throw "Something went wrong.";
      }
    }
  }

  Future<Map<String, dynamic>> checkUser(String email,String password) async {
    try{
      Response response = await _api.sendRequests.get("/check_user_data.php?email=$email&password=$password");
      return response.data;
    } on DioException catch(e){
      // print(e.response!.statusCode);
      if(e.response != null && e.response?.statusCode == 469){
        throw Exception("User doesn't exist. Check your email address and try again.");
      } else {
       throw Exception("Server down.");
      }
    }
  }


  saveUserData(int userId, String name, String email, String age, String location, String phoneNo, String interests) async {
    try{
      Response response = await _api.sendRequests.get("/post_personal_data.php?user_id=$userId&name=$name&email=$email&age=$age&location=$location&phone_no=$phoneNo&interests=$interests");
      return response;
    } catch (e){
      throw Exception("Something went wrong");
    }
  }
  
  saveUserQualification(String qualification, String instituteName,String boardName,int passingYear,double percentage,int isHighest,int userId) async {
    try{
      Response response = await _api.sendRequests.get("/post_qualification_details.php?user_id=$userId&qualification=$qualification&education_type=$qualification&institute_name=$instituteName&board_name=$boardName&passing_year=$passingYear&percentage=$percentage&is_highest=$isHighest");
      if(response.statusCode == 201){
        snackBarKey.currentState?.showSnackBar(const SnackBar(content: AutoSizeText("Data saved successfully")));
      }
    }on DioException catch (e){
      throw Exception(errorStrings(e.type));
    }
  }


}