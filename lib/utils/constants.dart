import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserValidation {
  RegExp emailExp = RegExp(
      r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');
  RegExp passExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
}

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

const String userDataDB = "8d7b0afdddea3f570493aabffee1f890-UserData";

const String quizDataDB = "8d7b0afdddea3f570493aabffee1f890-QuizData";

const String qualificationDataDB = "8d7b0afdddea3f570493aabffee1f890-Qualifications";


String errorStrings(DioExceptionType type){
  Map<DioExceptionType,String> errors = {
  DioExceptionType.connectionError:  "Error connecting to server.",
  DioExceptionType.connectionTimeout : "Connection timed out. Check your internet connection and try again",
  DioExceptionType.badResponse :  "Something went wrong.",
  DioExceptionType.unknown: "Something went wrong."
  };
  return errors[type] ?? "Something went wrong";
  // switch(type){
  //   case DioExceptionType.connectionError: return "Error connecting to server.";
  //   case DioExceptionType.connectionTimeout: return "Connection timed out. Check your internet connection and try again";
  //   case DioExceptionType.badResponse: return "Something went wrong.";
  //   case DioExceptionType.unknown: return "Something went wrong.";
  //   default: return "Something went wrong";
  // }
}

GlobalKey<NavigatorState> routerKey = GlobalKey();