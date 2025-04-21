import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/api/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:validator_regex/validator_regex.dart';
class EmailVerificationStates {}

class EmailVerificationInitial extends EmailVerificationStates {}

class EmailVerified extends EmailVerificationStates{}

class EmailVerificationFailed extends EmailVerificationStates{
  final String error;
  EmailVerificationFailed(this.error);
}

class EmailVerifying extends EmailVerificationStates{}

class EmailVerificationBloc extends Cubit<EmailVerificationStates>{
  EmailVerificationBloc() : super(EmailVerificationInitial());
  
  final API _api = API();

  void verifyEmailAddress(String email) async {
    emit(EmailVerifying());

    if(!Validator.email(email) || email.isEmpty){
      emit(EmailVerificationFailed("Enter valid email."));
    } else {
      Response response = await _api.sendRequests.get("https://apilayer.net/api/check?access_key=${dotenv.get("MAILBOXLAYER_API_KEY")}&email=$email");
      Map<String,dynamic> data = response.data;

      if(!data['format_valid'] && !data['catch_all'] && !data['smtp_check']){
        emit(EmailVerificationFailed("Email address is not valid."));
      } else if (data.containsKey("disposable") && data["disposable"] == true) {
        emit(EmailVerificationFailed("Disposable email address detected."));
      } else if (data.containsKey("role") && data["role"] == true) {
        emit(EmailVerificationFailed("Role-based email address detected."));
      } else if (data.containsKey("catch_all") && data["catch_all"] == true) {
        emit(EmailVerificationFailed("Catch-all email address detected."));
      } else if(data['score'] < 0.55){
        emit(EmailVerificationFailed("Email address is not valid."));
      } else {
        emit(EmailVerified());
      }
    }

  }
}