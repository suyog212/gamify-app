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
import 'package:kGamify/on_boarding/utils/auth_cubit.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/widgets/widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({super.key});

  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  ValueNotifier selected = ValueNotifier<bool>(true);
  ValueNotifier agree = ValueNotifier<bool>(true);
  ValueNotifier tncError = ValueNotifier<bool>(false);
  ValueNotifier isPass = ValueNotifier<bool>(true);

  List<String> qualifications = [
    "School",
    "High School",
    "Diploma",
    "Graduation",
    "Post Graduation",
    "Ph.D"
  ];
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
    return Scaffold(
      body: SafeArea(child: ListView(
        physics: const BouncingScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Image.asset(
                  "assets/images/KLOGO.png",
                  height: MediaQuery.sizeOf(context).width * 0.2,
                ),
              )
            ],
          ),
          const SizedBox(
            height: kToolbarHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    // border: Border.fromBorderSide(BorderSide(color: Colors.black)),
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ValueListenableBuilder(
                    valueListenable: selected,
                    builder: (context, value, child) {
                      return ToggleSwitch(
                        centerText: true,
                        initialLabelIndex: selected.value ? 0 : 1,
                        totalSwitches: 2,
                        minWidth: MediaQuery.sizeOf(context).width * 0.35,
                        labels: [S.current.signIn, S.current.signUp],
                        onToggle: (index) {
                          // print(Hive.box("UserData").get("isLoggedIn"));
                          _name.clear();
                          _email.clear();
                          _password.clear();
                          _confirmPass.clear();
                          _phone.clear();
                          agree.value = false;
                          selected.value = !selected.value;
                        },
                        activeBgColor: const [
                          Colors.orange,
                        ],
                        borderColor: const [Colors.black],
                        borderWidth: 0.2,
                        inactiveBgColor: Theme.of(context).colorScheme.surface,
                        activeFgColor: Colors.black,
                        // inactiveBgColor: Colors.grey.shade200,
                        curve: Curves.easeInOut,
                        cornerRadius: 10,
                        radiusStyle: true,
                        animate: true,
                        animationDuration: 300,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.transparent,),
          ValueListenableBuilder(
            valueListenable: selected,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  reverseDuration: const Duration(seconds: 300),
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      // opacity: animation,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Visibility(
                      key: ValueKey<Widget>(signUp(
                            (value) {},
                      )),
                      visible: selected.value,
                      replacement: signUp(
                            (value) {
                          agree.value = value!;
                          // print(value);
                        },
                      ),
                      child: signIn(),
                    ),
                  ));
            },
          )
        ],
      )),
    );
  }
  Widget signIn() {
    final signInFormKey = GlobalKey<FormState>();
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
                    visible: isPass.value,
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
                  }, child: Text(S.current.forgotPassword)),
            ],
          ),
          BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              // print(state);
              if(state is AuthInProgressState){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                  return const AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator.adaptive()
                      ],
                    ),
                  );
                },);
              }
              if (state is AuthErrorState) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        contentPadding: const EdgeInsets.all(16),
                        actionsPadding: const EdgeInsets.all(16),
                        titlePadding: const EdgeInsets.only(top: 16,left: 16,right: 16),
                        actions: [
                          Row(
                            children: [
                              Expanded(child: FilledButton(onPressed: () => context.pop(), child: const Text("Try again"))),
                            ],
                          )
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber_rounded,color: Colors.redAccent,size: 64.r,)
                          ],
                        ),
                        content: Text(state.error,textAlign: TextAlign.center,style: TextStyle(
                          fontSize: 16.sp
                        ),));
                  },
                );
              }
            },
            builder: (context, state) {
              return FilledButton(
                  onPressed: () async {
                    List<ConnectivityResult> result =
                    await Connectivity().checkConnectivity();
                    if (result.contains(ConnectivityResult.mobile) ||
                        result.contains(ConnectivityResult.wifi)) {
                      if (signInFormKey.currentState!.validate()) {
                        if(!context.mounted) return;
                        context
                            .read<AuthCubit>()
                            .signInUser(_email.text.trim(), _password.text.trim());
                      }
                    } else {
                      if(!context.mounted) return;
                      snackBarKey.currentState?.showSnackBar( SnackBar(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          content: Text("No internet connection",style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface
                          ),)));
                    }
                  },
                  child: Text(S.current.signIn));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.current.dontHaveAnAccount),
              const SizedBox(width: 8,),
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

  Widget signUp(void Function(bool? value) onChanged) {
    final signUpFormKey = GlobalKey<FormState>();
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
          ValueListenableBuilder(
            valueListenable: selectedQualification,
            builder: (context, value, child) {
              return DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      fillColor: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity( 0.07),
                      border: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10))),
                  isExpanded: true,
                  value: selectedQualification.value,
                  items: List.generate(
                    qualifications.length,
                        (index) => DropdownMenuItem(
                      value: qualifications.elementAt(index),
                      child: Text(qualifications.elementAt(index)),
                    ),
                  ),
                  onChanged: (value) {
                    selectedQualification.value = value;
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 4,),
          AutoSizeText(S.current.educationNote,style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Colors.grey
          ),),
          const Divider(
            color: Colors.transparent,
          ),
          AppTextField(
            hintText: S.current.email,
            controller: _email,
            keyBoardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email cannot be empty.";
              } else if(!EmailValidator.validate(value)){
                return "Enter valid email ex.example@abc.com";
              }
              //   if (!UserValidation().emailExp.hasMatch(value)) {
              //   return "Enter valid email ex.example@abc.com";
              // }
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
                    icon: Visibility(
                        visible: isPass.value,
                        replacement: const Icon(CupertinoIcons.eye_slash),
                        child: const Icon(CupertinoIcons.eye))),
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
                  if (value != null &&
                      value.isNotEmpty &&
                      _password.text != value) {
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
          ValueListenableBuilder(valueListenable: agree, builder: (context, value, child) {
            return Row(
              children: [
                Checkbox(value: agree.value, onChanged: onChanged),
                Expanded(
                  child: AutoSizeText.rich(
                    TextSpan(
                        text: "By continuing, you agree to our ",
                        children: [
                          TextSpan(
                              text: "Terms & Conditions & Privacy Policy",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                      Uri.parse("https://kgamify.in/teacheradminpanel/apis/terms_and_conditions_user.php"),
                                  );
                                }
                          ),
                        ],
                        style: TextStyle(
                            color:
                            Theme.of(context).textTheme.titleLarge!.color)),
                  ),
                )
              ],
            );
          },),
          const Divider(
            color: Colors.transparent,
          ),
          BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if(state is AuthInProgressState){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator.adaptive()
                        ],
                      ),
                    );
                  },);
              }
              if (state is AuthErrorState) {
                Navigator.pop(context);
                if(state.error == "Oops! It seems like you already have an account with us. Try logging in!"){
                  trySignInDialog(context, state.error, () {
                    selected.value = !selected.value;
                  },);
                  context.pop();
                }
                // else {
                //   tryAgainDialog(context, state.error, () => context.pop(),);
                // }
              }
            },
            builder: (context, state) {
              return FilledButton(
                onPressed: () async {
                  List<ConnectivityResult> result =
                  await Connectivity().checkConnectivity();
                  if (result.contains(ConnectivityResult.mobile) ||
                      result.contains(ConnectivityResult.wifi)) {
                    if (!context.mounted) return;
                    if (signUpFormKey.currentState!.validate()) {
                      if (agree.value) {
                        context.read<AuthCubit>().authenticate(
                            _name.text.trim(),
                            _email.text.trim(),
                            _password.text.trim(),
                            _phone.text.trim(),
                            selectedQualification.value.replaceAll(" ", "_"));
                      } else {
                        snackBarKey.currentState?.showSnackBar(const SnackBar(content: AutoSizeText("You must agree to our terms and conditions.")));
                      }
                    }
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                        content: Text("No internet connection",style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface
                        ))));
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
                child: Text(S.current.signUp),
              ),
            ],
          )
        ],
      ),
    );
  }
}

trySignInDialog(BuildContext context,String error,void Function() onTap){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          actionsPadding: const EdgeInsets.all(16),
          titlePadding: const EdgeInsets.only(top: 16,left: 16,right: 16),
          actions: [
            Row(
              children: [
                Expanded(child: FilledButton(onPressed:onTap, child: const Text("Sign in"))),
              ],
            )
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline_rounded,color: Colors.orangeAccent,size: 64.r,)
            ],
          ),
          content: Text(error,textAlign: TextAlign.center,));
    },
  );
}

tryAgainDialog(BuildContext context,String error,void Function() onTap){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          actionsPadding: const EdgeInsets.all(16),
          titlePadding: const EdgeInsets.only(top: 16,left: 16,right: 16),
          actions: [
            Row(
              children: [
                Expanded(child: FilledButton(onPressed:onTap, child: const Text("Try again"))),
              ],
            )
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded,color: Colors.orangeAccent,size: 64.r,)
            ],
          ),
          content: Text(error,textAlign: TextAlign.center,));
    },
  );
}

