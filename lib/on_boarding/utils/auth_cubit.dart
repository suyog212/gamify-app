import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/on_boarding/utils/auth_handler.dart';
import 'package:kGamify/utils/constants.dart';

abstract class AuthStates{}

class AuthInitialState extends AuthStates{}

class AuthErrorState extends AuthStates{
  final String error;
  AuthErrorState(this.error);
}

class AuthInProgressState extends AuthStates{}

class AuthSuccessState extends AuthStates{}

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(AuthInitialState());

  AuthHandler authHandler = AuthHandler();

  void authenticate(name, email, password, phone, qualification) async {
    try{
      emit(AuthInProgressState());
      Response status = await authHandler.registerUser(name, email, password, phone, qualification);
      if(status.statusCode == 201){
        await Hive.box(userDataDB).put("personalInfo", {
          "user_id": status.data['user_id'],
          "name": name,
          "email": email,
          "password": password,
          "user_qualification": qualification,
          "user_key": status.data['user_key'],
          "phone_no": phone,
          "first_login": DateTime.now().toString(),
          "recent_login": DateTime.now().toString(),
        });
        await mixpanel!.track("SignIn",properties: {
          "UserId" : status.data['user_id'].toString(),
          "UserKey" : status.data['user_key'].toString(),
          "Platform": Platform.operatingSystem.toString(),
          "OSVersion": Platform.operatingSystemVersion.toString(),
          "PhoneModel": Platform.isAndroid ? await DeviceInfoPlugin().androidInfo.then((value) => value.model.toString(),) : await DeviceInfoPlugin().iosInfo.then((value) => value.model.toString(),),
          "Manufacturer": Platform.isAndroid ? await DeviceInfoPlugin().androidInfo.then((value) => value.manufacturer.toString(),) : "Apple Inc.",
          "TimeStamp": DateTime.now().toString(),
        });
        mixpanel!.identify(status.data['user_id'].toString());
        await Hive.box(userDataDB).put("isLoggedIn", true);
        emit(AuthSuccessState());
      }
    } catch (e) {
      // log(e.toString());
      emit(AuthErrorState(e.toString()));
      emit(AuthInitialState());
    }
  }

  void signInUser( email, password) async {
    try{
      emit(AuthInProgressState());
      Map<String, dynamic> userData = await authHandler.checkUser(email, password);
      Map<String,dynamic> data = userData['data'];
      if(userData.isNotEmpty){
        // print(data.values.elementAt(0));
        await Hive.box(userDataDB)
            .put("personalInfo", {
          "user_id": data['user_id'],
          "name": data['user_name'],
          "email": data['email'],
          "age" : data['age'],
          // "user_qualification": data.values.elementAt(4),
          "user_key": data['user_key'],
          "phone_no": data['phone_no'],
          "first_login": data['first_login'],
          "recent_login": data['recent_login'],
          "city" : data['location'].split(",")[0],
          "state" : data['location'].split(",")[1],
          "country" : data['location'].split(",")[2]
        });
        mixpanel!.identify(data['user_id']);
        String interests = data['interests'];
        await Hive.box(userDataDB).put("interests", interests.split(","));
        List<dynamic> qualifications = data['qualifications'];
        qualifications.forEach((e) async => await Hive.box(qualificationDataDB).put(e['user_qualification'], {
          "SchoolName": e['institute_name'],
          "Board": e['board_name'],
          "percentage": e['percentage'],
          "PassingYear": e['passing_year'],
          "HighestEd": e['is_highest'] == 1 ? true : false
        }),);
        // print(Hive.box(userDataDB).get("personalInfo"));
          await Hive.box(userDataDB).put("isLoggedIn", true);
          await mixpanel!.track("SignIn",properties: {
            "UserId" : data['user_id'].toString(),
            "UserKey" : data['user_key'].toString(),
            "Platform": Platform.operatingSystem.toString(),
            "OSVersion": Platform.operatingSystemVersion.toString(),
            "PhoneModel": Platform.isAndroid ? await DeviceInfoPlugin().androidInfo.then((value) => value.model.toString(),) : await DeviceInfoPlugin().iosInfo.then((value) => value.model.toString(),),
            "Manufacturer": Platform.isAndroid ? await DeviceInfoPlugin().androidInfo.then((value) => value.manufacturer.toString(),) : "Apple Inc.",
            "TimeStamp": DateTime.now().toString(),
          });
          emit(AuthSuccessState());
      } else {
        debugPrint("Something went wrong");
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(AuthInitialState());
    }
  }
}