import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: CupertinoSegmentedControl(
                children: <int, Widget>{
                  0: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text("Item 1"),
                  ),
                  1: const Text("Item 2")
                },
                onValueChanged: (value) {
                  setState(() {
                    groupValue = value;
                  });
                },
                groupValue: groupValue,
              ),
            ),
            const SignInButton()
          ],
        ),
      ),
    );
  }
}


class SignInButton extends StatefulWidget {
  const SignInButton({super.key});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  Set<String> selected = {"signIn"};
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
        segments: const [
          ButtonSegment(value: "signIn",label: Text("Sign In")),
          ButtonSegment(value: "signUp",label: Text("Sign Up")),
        ],
        showSelectedIcon: false,
        expandedInsets: const EdgeInsets.all(16),
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24)
        ),
        selected: selected,
      onSelectionChanged: (value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
