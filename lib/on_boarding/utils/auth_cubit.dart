import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/on_boarding/utils/auth_handler.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  void authenticate(String name,String email,String password,String phone,String qualification) async {
    try{
      Response status = await authHandler.registerUser(name, email, password, phone, qualification);
      emit(AuthInProgressState());
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
        await Hive.box(userDataDB).put("isLoggedIn", true);
        emit(AuthSuccessState());
      }
    }on Exception catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(AuthInitialState());
    }
  }

  void signInUser(String email,String password) async {
    try{
      Map<String, dynamic> userData = await authHandler.checkUser(email, password);
      Map<String,dynamic> data = userData['data'];
      if(userData.isNotEmpty){
        // print(data.values.elementAt(0));
        await Hive.box(userDataDB)
            .put("personalInfo", {
          "user_id": data.values.elementAt(0),
          "name": data.values.elementAt(2),
          "email": data.values.elementAt(1),
          "password": data.values.elementAt(3),
          "user_qualification": data.values.elementAt(4),
          "user_key": data.values.elementAt(5),
          "phone_no": data.values.elementAt(6),
          "first_login": data.values.elementAt(7),
          "recent_login": data.values.elementAt(8),
          "city" : data['location']
        });

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
          emit(AuthSuccessState());
      } else {
        debugPrint("Something went wrong");
      }
    } on Exception catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(AuthInitialState());
    }
  }
}