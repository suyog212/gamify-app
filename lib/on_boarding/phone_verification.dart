import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kGamify/on_boarding/utils/OTP_verifcation_bloc.dart';
import 'package:kGamify/on_boarding/utils/auth_cubit.dart';
import 'package:kGamify/on_boarding/utils/otp_cubit.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/widgets/otp_timer.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneVerification extends StatefulWidget {
  final String phone;
  final String email;
  final String password;
  final String name;
  final String selectedQualification;
  const PhoneVerification({super.key, required this.phone, required this.email, required this.password, required this.name, required this.selectedQualification});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> with CodeAutoFill {
  @override
  void didChangeDependencies() async {
    context.read<OTPVerificationCubit>().sendOtpWithTemplate(phoneNumber: widget.phone, otp: generateOtp(), context: context, appSignature: await SmsAutoFill().getAppSignature);
    super.didChangeDependencies();
  }

  String? appSignature;
  String? otpCode;

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  final OtpTimerController _otpTimerController = OtpTimerController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            Text(
              "OTP Verification",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "We've sent an OTP to +91 ${widget.phone}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kToolbarHeight,
            ),
            BlocBuilder<OtpCubit, OtpState>(
              builder: (context, state) {
                return Pinput(
                  enabled: !state.isVerified,
                  closeKeyboardWhenCompleted: true,
                  controller: _otpController,
                  onCompleted: (value) {
                    context.read<OtpCubit>().verifyOtp(value);
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  onSubmitted: (value) {
                    // print(state.otp);
                    // context.read<OtpCubit>().verifyOtp(value);
                  },
                  defaultPinTheme: PinTheme(
                    width: 48.r,
                    height: 52.r,
                    textStyle: GoogleFonts.poppins(fontSize: 20, color: Theme.of(context).colorScheme.inverseSurface),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 235, 241, 0.37),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<OtpCubit, OtpState>(
              builder: (context, state) {
                return TextButton(
                    onPressed: state.isExpired
                        ? () {
                            context.read<OTPVerificationCubit>().sendOtpWithTemplate(phoneNumber: widget.phone, otp: generateOtp(), context: context, appSignature: appSignature ?? "").whenComplete(
                              () {
                                _otpTimerController.reset();
                              },
                            );
                          }
                        : null,
                    child: Text(
                      "Resend OTP?",
                      style: TextStyle(color: state.isExpired ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inverseSurface),
                    ));
              },
            ),
            OtpTimerWidget(
              onTimerComplete: () {},
              controller: _otpTimerController,
            ),
            const Spacer(),
            BlocBuilder<OtpCubit, OtpState>(
              builder: (context, state) {
                return FilledButton(
                    onPressed: state.isVerified
                        ? () {
                            context.read<AuthCubit>().authenticate(widget.name, widget.email, widget.password, widget.phone, widget.selectedQualification);
                          }
                        : null,
                    child: const Text("Create account"));
              },
            )
          ],
        ),
      ),
    );
  }
}
