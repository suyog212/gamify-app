import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/sign_in.dart';
import 'package:kGamify/on_boarding/sign_up.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  ValueNotifier agree = ValueNotifier<bool>(false);
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
            const Divider(
              color: Colors.transparent,
            ),
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
                      key: ValueKey<Widget>(SignUp(
                        agree: agree,
                        confirmPass: _confirmPass,
                        email: _email,
                        isPass: isPass,
                        name: _name,
                        password: _password,
                        signInButton: () {
                          _name.clear();
                          _email.clear();
                          _password.clear();
                          _confirmPass.clear();
                          selected.value = true;
                        },
                        phone: _phone,
                        qualifications: qualifications,
                        selected: selected,
                        selectedQualification: selectedQualification,
                        tncerror: tncError,
                      )),
                      visible: selected.value,
                      replacement: SignUp(
                        agree: agree,
                        confirmPass: _confirmPass,
                        email: _email,
                        isPass: isPass,
                        name: _name,
                        password: _password,
                        signInButton: () {
                          _name.clear();
                          _email.clear();
                          _password.clear();
                          _confirmPass.clear();
                          selected.value = true;
                        },
                        phone: _phone,
                        qualifications: qualifications,
                        selected: selected,
                        selectedQualification: selectedQualification,
                        tncerror: tncError,
                      ),
                      child: SignIn(
                        createAnAccount: () {
                          setState(() {
                            _email.clear();
                            _password.clear();
                            selected.value = false;
                          });
                        },
                        email: _email,
                        isPass: isPass,
                        password: _password,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

trySignInDialog(BuildContext context, String error, void Function() onTap) {
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
                Expanded(child: FilledButton(onPressed: onTap, child: const Text("Sign in"))),
              ],
            )
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.orangeAccent,
                size: 64.r,
              )
            ],
          ),
          content: Text(
            error,
            textAlign: TextAlign.center,
          ));
    },
  );
}

tryAgainDialog(BuildContext context, String error, void Function() onTap) {
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
                Expanded(child: FilledButton(onPressed: onTap, child: const Text("Try again"))),
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
                color: Colors.orangeAccent,
                size: 64.r,
              )
            ],
          ),
          content: Text(
            error,
            textAlign: TextAlign.center,
          ));
    },
  );
}
