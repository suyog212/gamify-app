import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/api/api.dart';

abstract class ForgotPasswordStates {}

class ForgotPasswordInitialState extends ForgotPasswordStates {}

class ForgotPasswordErrorState extends ForgotPasswordStates {
  final String error;
  ForgotPasswordErrorState(this.error);
}

class ForgotPasswordLoadingState extends ForgotPasswordStates {}

class ForgotPasswordMailSentState extends ForgotPasswordStates {}

class ForgotPasswordCubit extends Cubit<ForgotPasswordStates> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  final API _api = API();

  void resetPassword(String email) async {
    try {
      emit(ForgotPasswordLoadingState());
      Response response = await _api.sendRequests.get("/forgot_password.php?email=$email");
      if (response.statusCode == 200) {
        emit(ForgotPasswordMailSentState());
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        emit(ForgotPasswordErrorState("User with this email doesn't exist. Check your mail and try again."));
      } else {
        emit(ForgotPasswordErrorState("Our servers are currently unavailable. We’re working to resolve the issue. Please try again later."));
      }
    }
  }

  void resetState() {
    emit(ForgotPasswordInitialState());
  }
}
