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
        debugPrint("User Created Successfully");
       signInUser(email, password);
      }
      if(status.statusCode == 409){
        emit(AuthErrorState(status.statusMessage.toString()));
      }
    }catch (e) {
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
          "name": data.values.elementAt(1),
          "email": data.values.elementAt(2),
          "password": data.values.elementAt(3),
          "user_qualification": data.values.elementAt(4),
          "user_key": data.values.elementAt(5),
          "phone_no": data.values.elementAt(6),
          "first_login": data.values.elementAt(7),
          "recent_login": data.values.elementAt(8)
        });
          await Hive.box(userDataDB).put("isLoggedIn", true);
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