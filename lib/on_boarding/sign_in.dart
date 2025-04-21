import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/utils/auth_cubit.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  ValueNotifier isPass = ValueNotifier<bool>(true);
  ValueNotifier selected = ValueNotifier<bool>(true);
  final signInFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: signInFormKey,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          // const Divider(
          //   color: Colors.transparent,
          // ),
          AppTextField(
            hintText: S.current.email,
            controller: _email,
            keyBoardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter valid email";
              } else if (!UserValidation().emailExp.hasMatch(value)) {
                return "Enter valid email ex.example@abc.com";
              }
              return null;
            },
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
                suffix: IconButton(
                  onPressed: () {
                    isPass.value = !isPass.value;
                  },
                  icon: Visibility(
                    visible: !isPass.value,
                    replacement: const Icon(CupertinoIcons.eye_slash),
                    child: const Icon(CupertinoIcons.eye),
                  ),
                ),
                isPass: isPass.value,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    context.push("/authentication/forgotPassword");
                  },
                  child: Text(S.current.forgotPassword)),
            ],
          ),
          BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              // print(state);
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        contentPadding: const EdgeInsets.all(16),
                        actionsPadding: const EdgeInsets.all(16),
                        titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                        actions: [
                          Row(
                            children: [
                              Expanded(child: FilledButton(onPressed: () => context.pop(), child: const Text("Try again"))),
                            ],
                          )
                        ],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.redAccent,
                              size: 64.r,
                            )
                          ],
                        ),
                        content: Text(
                          state.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ));
                  },
                );
              }
            },
            builder: (context, state) {
              return FilledButton(
                  onPressed: () async {
                    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
                    if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
                      if (signInFormKey.currentState!.validate()) {
                        if (!context.mounted) return;
                        context.read<AuthCubit>().signInUser(_email.text.trim(), _password.text.trim());
                      }
                    } else {
                      if (!context.mounted) return;
                      snackBarKey.currentState?.showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          content: Text(
                            "No internet connection",
                            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                          )));
                    }
                  },
                  child: Text(S.current.signIn));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.current.dontHaveAnAccount),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _email.clear();
                    _password.clear();
                    selected.value = false;
                  });
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(S.current.createAnAccount),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//
// Widget signIn() {
//
//   return Form(
//     key: signInFormKey,
//     child: ListView(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       children: [
//         // const Divider(
//         //   color: Colors.transparent,
//         // ),
//         AppTextField(
//           hintText: S.current.email,
//           controller: _email,
//           keyBoardType: TextInputType.emailAddress,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Enter valid email";
//             } else if (!UserValidation().emailExp.hasMatch(value)) {
//               return "Enter valid email ex.example@abc.com";
//             }
//             return null;
//           },
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
//               suffix: IconButton(
//                 onPressed: () {
//                   isPass.value = !isPass.value;
//                 },
//                 icon: Visibility(
//                   visible: !isPass.value,
//                   replacement: const Icon(CupertinoIcons.eye_slash),
//                   child: const Icon(CupertinoIcons.eye),
//                 ),
//               ),
//               isPass: isPass.value,
//             );
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton(
//                 onPressed: () {
//                   context.push("/authentication/forgotPassword");
//                 },
//                 child: Text(S.current.forgotPassword)),
//           ],
//         ),
//         BlocConsumer<AuthCubit, AuthStates>(
//           listener: (context, state) {
//             // print(state);
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
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                       contentPadding: const EdgeInsets.all(16),
//                       actionsPadding: const EdgeInsets.all(16),
//                       titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//                       actions: [
//                         Row(
//                           children: [
//                             Expanded(child: FilledButton(onPressed: () => context.pop(), child: const Text("Try again"))),
//                           ],
//                         )
//                       ],
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       title: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.warning_amber_rounded,
//                             color: Colors.redAccent,
//                             size: 64.r,
//                           )
//                         ],
//                       ),
//                       content: Text(
//                         state.error,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 16.sp),
//                       ));
//                 },
//               );
//             }
//           },
//           builder: (context, state) {
//             return FilledButton(
//                 onPressed: () async {
//                   List<ConnectivityResult> result = await Connectivity().checkConnectivity();
//                   if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
//                     if (signInFormKey.currentState!.validate()) {
//                       if (!context.mounted) return;
//                       context.read<AuthCubit>().signInUser(_email.text.trim(), _password.text.trim());
//                     }
//                   } else {
//                     if (!context.mounted) return;
//                     snackBarKey.currentState?.showSnackBar(SnackBar(
//                         backgroundColor: Theme.of(context).colorScheme.surface,
//                         content: Text(
//                           "No internet connection",
//                           style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
//                         )));
//                   }
//                 },
//                 child: Text(S.current.signIn));
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(S.current.dontHaveAnAccount),
//             const SizedBox(
//               width: 8,
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _email.clear();
//                   _password.clear();
//                   selected.value = false;
//                 });
//               },
//               style: TextButton.styleFrom(padding: EdgeInsets.zero),
//               child: Text(S.current.createAnAccount),
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }
