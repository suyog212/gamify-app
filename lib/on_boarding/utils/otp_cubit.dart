// otp_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpState extends Equatable {
  final String? otp;
  final bool isVerified;
  final bool isExpired;

  const OtpState({
    this.otp,
    this.isVerified = false,
    this.isExpired = false,
  });

  OtpState copyWith({
    String? otp,
    bool? isVerified,
    bool? isExpired,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      isVerified: isVerified ?? this.isVerified,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  @override
  List<Object?> get props => [otp, isVerified, isExpired];
}

class OtpCubit extends Cubit<OtpState> {
  Timer? _timer;

  OtpCubit() : super(const OtpState());

  void storeOtp(String otp) {
    // Cancel previous timer if any
    _timer?.cancel();

    emit(OtpState(otp: otp, isVerified: false, isExpired: false));

    // Start 3 minute timer to expire OTP
    _timer = Timer(const Duration(minutes: 5), () {
      // print("OTP Expired");
      emit(state.copyWith(otp: null, isExpired: true));
    });
  }

  void verifyOtp(String enteredOtp) {
    if (state.otp == null || state.isExpired) {
      emit(state.copyWith(isVerified: false, isExpired: true));
      return;
    }

    if (enteredOtp == state.otp) {
      // Cancel timer and clear OTP
      _timer?.cancel();
      emit(state.copyWith(otp: null, isVerified: true));
    } else {
      emit(state.copyWith(isVerified: false));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
