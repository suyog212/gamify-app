import 'package:auto_size_text/auto_size_text.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kGamify/on_boarding/utils/forgot_password_cubit.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            // shrinkWrap: true,
            // padding: const EdgeInsets.all(16),
            children: [
              MediaQuery.removePadding(
                removeLeft: true,
                context: context,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.arrow_back))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: kToolbarHeight,
                    ),
                    AutoSizeText(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 26.sp),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    const Text("Enter your registered email address."),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "example@gmail.com",
                        label: const Text("Email"),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.07),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        }
                        return null;
                      },
                    ),
                    // AppTextField(
                    //   hintText: "example@gmail.com",
                    //   controller: _email,
                    //   keyBoardType: TextInputType.emailAddress,
                    //   label: "Email",
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "This field cannot be empty";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    BlocConsumer<ForgotPasswordCubit, ForgotPasswordStates>(
                      listener: (context, state) {
                        if (state is ForgotPasswordMailSentState) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "Email sent successfully.",
                                  style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 20.sp),
                                  textAlign: TextAlign.center,
                                ),
                                title: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: Theme.of(context).textTheme.displayMedium!.fontSize! * 2,
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: FilledButton(
                                              onPressed: () {
                                                context.read<ForgotPasswordCubit>().resetState();
                                                context.go("/authentication");
                                              },
                                              child: const Text("Sign in")))
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        }
                        if (state is ForgotPasswordErrorState) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  state.error,
                                  style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 20.sp),
                                  textAlign: TextAlign.center,
                                ),
                                title: Icon(
                                  Icons.warning_amber_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                  size: Theme.of(context).textTheme.displayMedium!.fontSize! * 2,
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: FilledButton(
                                              onPressed: () {
                                                context.go("/authentication");
                                              },
                                              child: const Text("Sign in")))
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ForgotPasswordLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ForgotPasswordMailSentState) {
                          return const FilledButton(onPressed: null, child: Text("Proceed"));
                        }
                        return FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<ForgotPasswordCubit>().resetPassword(_email.text.trim());
                                // AuthHandler().resetPassword(_email.text.trim());
                              }
                            },
                            child: const Text("Proceed"));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
