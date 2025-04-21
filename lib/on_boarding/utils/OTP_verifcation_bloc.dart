import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/on_boarding/utils/otp_cubit.dart';

abstract class OTPVerificationStates {}

class OTPVerificationInitial extends OTPVerificationStates {}

class OTPSentSuccessfully extends OTPVerificationStates {}

class FailedToSendOTP extends OTPVerificationStates {}

class OTPVerificationCubit extends Cubit<OTPVerificationStates> {
  OTPVerificationCubit() : super(OTPVerificationInitial());

  Future<void> sendOtpWithTemplate({required String phoneNumber, required String otp, required BuildContext context}) async {
    // final url = Uri.parse('https://msg.mtalkz.com/V2/http-api-post-sms'); // Check if yours is different

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "apikey": "DpVG4QrDYOsA5Otr", // Replace with your mTalkz API key
      "senderid": "YANTRI", // 6-char approved sender ID
      "number": phoneNumber, // 10-digit mobile number (with or without 91)
      "message":
          "Your OTP- One Time Password is $otp to authenticate your login on kGamify app. This OTP is valid for 3 mins. -Team kGamify", // This should exactly match your DLT template content with OTP filled in
      "format": "json",
      "template_id": "1107174350946322136" // Your approved template ID
    });

    final response = await Dio().post('https://msgn.mtalkz.com/api', options: Options(headers: headers), data: body);

    if (response.statusCode == 200) {
      if (!context.mounted) return;
      context.read<OtpCubit>().storeOtp(otp);
      emit(OTPSentSuccessfully());
      // print('OTP sent successfully');
    } else {
      emit(FailedToSendOTP());
      // print('Failed to send OTP: ${response.data}');
    }
  }
}
