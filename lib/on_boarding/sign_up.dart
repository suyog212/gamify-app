import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/user_authentication.dart';
import 'package:kGamify/on_boarding/utils/auth_cubit.dart';
import 'package:kGamify/on_boarding/utils/auth_handler.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  ValueNotifier selected = ValueNotifier<bool>(true);
  ValueNotifier agree = ValueNotifier<bool>(true);
  ValueNotifier tncError = ValueNotifier<bool>(false);
  ValueNotifier isPass = ValueNotifier<bool>(true);

  List<String> qualifications = ["School", "High School", "Diploma", "Graduation", "Post Graduation", "Ph.D"];
  ValueNotifier selectedQualification = ValueNotifier<String>("School");

  @override
  void dispose() {
    selected.dispose();
    agree.dispose();
    tncError.dispose();
    isPass.dispose();
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _confirmPass.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signUpFormKey,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          AppTextField(
            hintText: S.current.name,
            controller: _name,
            keyBoardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name cannot be empty.";
              }
              return null;
            },
          ),
          const Divider(
            color: Colors.transparent,
          ),
          AppTextField(
            hintText: S.current.phoneNumber,
            controller: _phone,
            keyBoardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Phone number cannot be empty.";
              }
              return null;
            },
          ),
          const Divider(
            color: Colors.transparent,
          ),
          // ValueListenableBuilder(
          //   valueListenable: selectedQualification,
          //   builder: (context, value, child) {
          //     return DropdownButtonHideUnderline(
          //       child: DropdownButtonFormField(
          //         decoration: InputDecoration(
          //             fillColor: Theme.of(context)
          //                 .colorScheme
          //                 .inverseSurface
          //                 .withValues(alpha:  0.07),
          //             border: OutlineInputBorder(
          //                 borderSide:
          //                 const BorderSide(color: Colors.transparent),
          //                 borderRadius: BorderRadius.circular(10)),
          //             filled: true,
          //             focusedBorder: OutlineInputBorder(
          //                 borderSide:
          //                 const BorderSide(color: Colors.transparent),
          //                 borderRadius: BorderRadius.circular(10)),
          //             enabledBorder: OutlineInputBorder(
          //                 borderSide:
          //                 const BorderSide(color: Colors.transparent),
          //                 borderRadius: BorderRadius.circular(10))),
          //         isExpanded: true,
          //         value: selectedQualification.value,
          //         items: List.generate(
          //           qualifications.length,
          //               (index) => DropdownMenuItem(
          //             value: qualifications.elementAt(index),
          //             child: Text(qualifications.elementAt(index)),
          //           ),
          //         ),
          //         onChanged: (value) {
          //           selectedQualification.value = value;
          //         },
          //       ),
          //     );
          //   },
          // ),
          // const SizedBox(
          //   height: 4,
          // ),
          // AutoSizeText(
          //   S.current.educationNote,
          //   style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
          // ),
          // const Divider(
          //   color: Colors.transparent,
          // ),
          AppTextField(
            hintText: S.current.email,
            controller: _email,
            keyBoardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email cannot be empty.";
              } else if (!EmailValidator.validate(value)) {
                return "Enter valid email ex.example@abc.com";
              }
              //   if (!UserValidation().emailExp.hasMatch(value)) {
              //   return "Enter valid email ex.example@abc.com";
              // }
              return null;
            },
            // isEnabled: !isEmailVerified.value,
            // suffix: BlocConsumer<EmailVerificationBloc, EmailVerificationStates>(
            //   listener: (context, state) {
            //     if(state is EmailVerified){
            //       isEmailVerified.value = !isEmailVerified.value;
            //     }
            //     if(state is EmailVerificationFailed){
            //       showDialog(context: context, builder: (context) => Dialog(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10.sp)
            //         ),
            //         child: Padding(
            //           padding: EdgeInsets.all(12.sp),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Icon(Icons.warning_amber_rounded,color: Theme.of(context).colorScheme.secondary
            //                 ,size: 64.sp,),
            //               const Divider(color: Colors.transparent,),
            //               AutoSizeText(state.error,style: TextStyle(fontSize: 16.sp),textAlign: TextAlign.center,),
            //               const Divider(color: Colors.transparent,),
            //               FilledButton(onPressed: () => context.pop(), child: const Text("Retry")),
            //             ],
            //           ),
            //         ),
            //       ),);
            //     }
            //   },
            //   builder: (context, state) {
            //     if(state is EmailVerifying){
            //       return Padding(
            //         padding: EdgeInsets.all(12.0.sp),
            //         child: const CircularProgressIndicator.adaptive(),
            //       );
            //     }
            //     if(state is EmailVerified){
            //       return Icon(Icons.check,color: Theme.of(context).colorScheme.secondary,size: 20.sp,);
            //     }
            //     return TextButton(onPressed: () => context.read<EmailVerificationBloc>().verifyEmailAddress(_email.text.trim()), child: const Text("Verify"));
            //   },
            // ),
          ),
          const Divider(
            color: Colors.transparent,
          ),
          ValueListenableBuilder(
            valueListenable: isPass,
            builder: (context, value, child) {
              return AppTextField(
                hintText: S.current.password,
                controller: _password,
                keyBoardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty.";
                  }
                  if (!UserValidation().passExp.hasMatch(value)) {
                    return '''
            Password should contain
              should contain at least one upper case
              should contain at least one lower case
              should contain at least one digit
              should contain at least one Special character
              Must be at least 8 characters in length''';
                  }
                  return null;
                },
                suffix: IconButton(
                    onPressed: () {
                      isPass.value = !isPass.value;
                    },
                    icon: Visibility(visible: !isPass.value, replacement: const Icon(CupertinoIcons.eye_slash), child: const Icon(CupertinoIcons.eye))),
                isPass: isPass.value,
              );
            },
          ),
          const Divider(
            color: Colors.transparent,
          ),
          ValueListenableBuilder(
            valueListenable: isPass,
            builder: (context, value, child) {
              return AppTextField(
                hintText: S.current.confirmPassword,
                controller: _confirmPass,
                keyBoardType: TextInputType.visiblePassword,
                isPass: isPass.value,
                validator: (value) {
                  if (value != null && value.isNotEmpty && _password.text != value) {
                    return "Password doesn't match.";
                  }
                  return null;
                },
              );
            },
          ),
          const Divider(
            color: Colors.transparent,
          ),
          ValueListenableBuilder(
            valueListenable: agree,
            builder: (context, value, child) {
              return Row(
                children: [
                  Checkbox(
                    value: agree.value,
                    onChanged: (value) {
                      agree.value = value;
                    },
                  ),
                  Expanded(
                    child: AutoSizeText.rich(
                      TextSpan(
                          text: "By continuing, you agree to our ",
                          children: [
                            TextSpan(
                                text: "Terms & Conditions & Privacy Policy",
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse("https://kgamify.in/championshipmaker/apis/terms_and_conditions_user.php"),
                                    );
                                  }),
                          ],
                          style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color)),
                    ),
                  )
                ],
              );
            },
          ),
          const Divider(
            color: Colors.transparent,
          ),
          const AutoSizeText.rich(TextSpan(text: "Fields marked with ", children: [TextSpan(text: "*", style: TextStyle(color: Colors.red)), TextSpan(text: " are required.")])),
          const Divider(
            color: Colors.transparent,
          ),
          BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is AuthInProgressState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [CircularProgressIndicator.adaptive()],
                      ),
                    );
                  },
                );
              }
              if (state is AuthErrorState) {
                Navigator.pop(context);
                if (state.error == "Oops! It seems like you already have an account with us. Try logging in!") {
                  trySignInDialog(
                    context,
                    state.error,
                    () {
                      selected.value = !selected.value;
                      context.pop();
                    },
                  );
                  // isEmailVerified.value = false;
                  // context.pop();
                }
                // isEmailVerified.value = false;
                // else {
                //   tryAgainDialog(context, state.error, () => context.pop(),);
                // }
              }
            },
            builder: (context, state) {
              return FilledButton(
                onPressed: () async {
                  List<ConnectivityResult> result = await Connectivity().checkConnectivity();
                  if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
                    if (!context.mounted) return;
                    if (signUpFormKey.currentState!.validate()) {
                      if (agree.value) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return const AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [CircularProgressIndicator.adaptive()],
                              ),
                            );
                          },
                        );
                        if (await AuthHandler().checkUserLogin(_email.text.trim()) == 200) {
                          if (!context.mounted) return;
                          context.pop();
                          trySignInDialog(context, "Oops! It seems like you already have an account with us. Try logging in!", () {
                            selected.value = !selected.value;
                          });
                        } else {
                          if (!context.mounted) return;
                          context.pop();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                insetPadding: const EdgeInsets.all(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone_android_rounded,
                                        size: 48.r,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Confirm Phone Number",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "We’ll send an OTP to this number:",
                                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "+91 ${_phone.text.trim()}",
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                side: BorderSide(color: Colors.grey.shade300),
                                              ),
                                              child: const Text("Edit"),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: FilledButton(
                                              onPressed: () {
                                                context.pop();
                                                context.go(("/authentication/otpVerification"), extra: {
                                                  "phone": _phone.text.trim(),
                                                  "name": _name.text.trim(),
                                                  "email": _email.text.trim(),
                                                  "password": _password.text.trim(),
                                                  "qualification": selectedQualification.value.replaceAll(" ", "_")
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                // backgroundColor: Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Text("Continue"),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        snackBarKey.currentState?.showSnackBar(const SnackBar(content: AutoSizeText("You must agree to our terms and conditions.")));
                      }
                    }
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.surface, content: Text("No internet connection", style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface))));
                  }
                },
                child: Text(S.current.createAnAccount),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.current.alreadyHaveAnAccount),
              TextButton(
                onPressed: () {
                  _name.clear();
                  _email.clear();
                  _password.clear();
                  _confirmPass.clear();
                  selected.value = true;
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(S.current.signIn),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Widget signUp(void Function(bool? value) onChanged) {
//   // ValueNotifier<bool> isEmailVerified = ValueNotifier(false);
//   final signUpFormKey = GlobalKey<FormState>();
//   return Form(
//     key: signUpFormKey,
//     child: ListView(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       children: [
//         AppTextField(
//           hintText: S.current.name,
//           controller: _name,
//           keyBoardType: TextInputType.name,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Name cannot be empty.";
//             }
//             return null;
//           },
//         ),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         AppTextField(
//           hintText: S.current.phoneNumber,
//           controller: _phone,
//           keyBoardType: TextInputType.number,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Phone number cannot be empty.";
//             }
//             return null;
//           },
//         ),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         // ValueListenableBuilder(
//         //   valueListenable: selectedQualification,
//         //   builder: (context, value, child) {
//         //     return DropdownButtonHideUnderline(
//         //       child: DropdownButtonFormField(
//         //         decoration: InputDecoration(
//         //             fillColor: Theme.of(context)
//         //                 .colorScheme
//         //                 .inverseSurface
//         //                 .withValues(alpha:  0.07),
//         //             border: OutlineInputBorder(
//         //                 borderSide:
//         //                 const BorderSide(color: Colors.transparent),
//         //                 borderRadius: BorderRadius.circular(10)),
//         //             filled: true,
//         //             focusedBorder: OutlineInputBorder(
//         //                 borderSide:
//         //                 const BorderSide(color: Colors.transparent),
//         //                 borderRadius: BorderRadius.circular(10)),
//         //             enabledBorder: OutlineInputBorder(
//         //                 borderSide:
//         //                 const BorderSide(color: Colors.transparent),
//         //                 borderRadius: BorderRadius.circular(10))),
//         //         isExpanded: true,
//         //         value: selectedQualification.value,
//         //         items: List.generate(
//         //           qualifications.length,
//         //               (index) => DropdownMenuItem(
//         //             value: qualifications.elementAt(index),
//         //             child: Text(qualifications.elementAt(index)),
//         //           ),
//         //         ),
//         //         onChanged: (value) {
//         //           selectedQualification.value = value;
//         //         },
//         //       ),
//         //     );
//         //   },
//         // ),
//         // const SizedBox(
//         //   height: 4,
//         // ),
//         // AutoSizeText(
//         //   S.current.educationNote,
//         //   style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey),
//         // ),
//         // const Divider(
//         //   color: Colors.transparent,
//         // ),
//         AppTextField(
//           hintText: S.current.email,
//           controller: _email,
//           keyBoardType: TextInputType.emailAddress,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Email cannot be empty.";
//             } else if (!EmailValidator.validate(value)) {
//               return "Enter valid email ex.example@abc.com";
//             }
//             //   if (!UserValidation().emailExp.hasMatch(value)) {
//             //   return "Enter valid email ex.example@abc.com";
//             // }
//             return null;
//           },
//           // isEnabled: !isEmailVerified.value,
//           // suffix: BlocConsumer<EmailVerificationBloc, EmailVerificationStates>(
//           //   listener: (context, state) {
//           //     if(state is EmailVerified){
//           //       isEmailVerified.value = !isEmailVerified.value;
//           //     }
//           //     if(state is EmailVerificationFailed){
//           //       showDialog(context: context, builder: (context) => Dialog(
//           //         shape: RoundedRectangleBorder(
//           //             borderRadius: BorderRadius.circular(10.sp)
//           //         ),
//           //         child: Padding(
//           //           padding: EdgeInsets.all(12.sp),
//           //           child: Column(
//           //             crossAxisAlignment: CrossAxisAlignment.stretch,
//           //             mainAxisSize: MainAxisSize.min,
//           //             children: [
//           //               Icon(Icons.warning_amber_rounded,color: Theme.of(context).colorScheme.secondary
//           //                 ,size: 64.sp,),
//           //               const Divider(color: Colors.transparent,),
//           //               AutoSizeText(state.error,style: TextStyle(fontSize: 16.sp),textAlign: TextAlign.center,),
//           //               const Divider(color: Colors.transparent,),
//           //               FilledButton(onPressed: () => context.pop(), child: const Text("Retry")),
//           //             ],
//           //           ),
//           //         ),
//           //       ),);
//           //     }
//           //   },
//           //   builder: (context, state) {
//           //     if(state is EmailVerifying){
//           //       return Padding(
//           //         padding: EdgeInsets.all(12.0.sp),
//           //         child: const CircularProgressIndicator.adaptive(),
//           //       );
//           //     }
//           //     if(state is EmailVerified){
//           //       return Icon(Icons.check,color: Theme.of(context).colorScheme.secondary,size: 20.sp,);
//           //     }
//           //     return TextButton(onPressed: () => context.read<EmailVerificationBloc>().verifyEmailAddress(_email.text.trim()), child: const Text("Verify"));
//           //   },
//           // ),
//         ),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         ValueListenableBuilder(
//           valueListenable: isPass,
//           builder: (context, value, child) {
//             return AppTextField(
//               hintText: S.current.password,
//               controller: _password,
//               keyBoardType: TextInputType.visiblePassword,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Password cannot be empty.";
//                 }
//                 if (!UserValidation().passExp.hasMatch(value)) {
//                   return '''
//             Password should contain
//               should contain at least one upper case
//               should contain at least one lower case
//               should contain at least one digit
//               should contain at least one Special character
//               Must be at least 8 characters in length''';
//                 }
//                 return null;
//               },
//               suffix: IconButton(
//                   onPressed: () {
//                     isPass.value = !isPass.value;
//                   },
//                   icon: Visibility(visible: !isPass.value, replacement: const Icon(CupertinoIcons.eye_slash), child: const Icon(CupertinoIcons.eye))),
//               isPass: isPass.value,
//             );
//           },
//         ),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         ValueListenableBuilder(
//           valueListenable: isPass,
//           builder: (context, value, child) {
//             return AppTextField(
//               hintText: S.current.confirmPassword,
//               controller: _confirmPass,
//               keyBoardType: TextInputType.visiblePassword,
//               isPass: isPass.value,
//               validator: (value) {
//                 if (value != null && value.isNotEmpty && _password.text != value) {
//                   return "Password doesn't match.";
//                 }
//                 return null;
//               },
//             );
//           },
//         ),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         ValueListenableBuilder(
//           valueListenable: agree,
//           builder: (context, value, child) {
//             return Row(
//               children: [
//                 Checkbox(value: agree.value, onChanged: onChanged),
//                 Expanded(
//                   child: AutoSizeText.rich(
//                     TextSpan(
//                         text: "By continuing, you agree to our ",
//                         children: [
//                           TextSpan(
//                               text: "Terms & Conditions & Privacy Policy",
//                               style: TextStyle(color: Theme.of(context).colorScheme.secondary),
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   launchUrl(
//                                     Uri.parse("https://kgamify.in/championshipmaker/apis/terms_and_conditions_user.php"),
//                                   );
//                                 }),
//                         ],
//                         style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color)),
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         const AutoSizeText.rich(TextSpan(text: "Fields marked with ", children: [TextSpan(text: "*", style: TextStyle(color: Colors.red)), TextSpan(text: " are required.")])),
//         const Divider(
//           color: Colors.transparent,
//         ),
//         BlocConsumer<AuthCubit, AuthStates>(
//           listener: (context, state) {
//             if (state is AuthInProgressState) {
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (context) {
//                   return const AlertDialog(
//                     backgroundColor: Colors.transparent,
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [CircularProgressIndicator.adaptive()],
//                     ),
//                   );
//                 },
//               );
//             }
//             if (state is AuthErrorState) {
//               Navigator.pop(context);
//               if (state.error == "Oops! It seems like you already have an account with us. Try logging in!") {
//                 trySignInDialog(
//                   context,
//                   state.error,
//                       () {
//                     selected.value = !selected.value;
//                     context.pop();
//                   },
//                 );
//                 // isEmailVerified.value = false;
//                 // context.pop();
//               }
//               // isEmailVerified.value = false;
//               // else {
//               //   tryAgainDialog(context, state.error, () => context.pop(),);
//               // }
//             }
//           },
//           builder: (context, state) {
//             return FilledButton(
//               onPressed: () async {
//                 List<ConnectivityResult> result = await Connectivity().checkConnectivity();
//                 if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
//                   if (!context.mounted) return;
//                   if (signUpFormKey.currentState!.validate()) {
//                     if (agree.value) {
//                       context.read<AuthCubit>().authenticate(_name.text.trim(), _email.text.trim(), _password.text.trim(), _phone.text.trim(), selectedQualification.value.replaceAll(" ", "_"));
//                     } else {
//                       snackBarKey.currentState?.showSnackBar(const SnackBar(content: AutoSizeText("You must agree to our terms and conditions.")));
//                     }
//                   }
//                 } else {
//                   if (!context.mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       backgroundColor: Theme.of(context).colorScheme.surface, content: Text("No internet connection", style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface))));
//                 }
//               },
//               child: Text(S.current.createAnAccount),
//             );
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(S.current.alreadyHaveAnAccount),
//             TextButton(
//               onPressed: () {
//                 _name.clear();
//                 _email.clear();
//                 _password.clear();
//                 _confirmPass.clear();
//                 selected.value = true;
//               },
//               style: TextButton.styleFrom(padding: EdgeInsets.zero),
//               child: Text(S.current.signIn),
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }
