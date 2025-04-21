import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kGamify/blocs/championship_analytics_cubit.dart';
import 'package:kGamify/models/championship_analytics_model.dart';
import 'package:kGamify/repositories/championship_analytics_repository.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/router.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final bool isPass;
  final String? label;
  final TextInputType? keyBoardType;
  final bool? isEnabled;
  final bool? isRequired;
  const AppTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.validator,
      this.prefix,
      this.suffix,
      this.isPass = false,
      required this.keyBoardType,
      this.label,
      this.isEnabled,
      this.isRequired});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      enabled: isEnabled,
      obscureText: isPass,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.07),
          border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          prefix: prefix,
          suffixIcon: suffix,
          label: RichText(
              text: TextSpan(text: hintText, style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface), children: [
            TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                ))
          ])),
          filled: true,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.4)),
          disabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(10))),
    );
  }
}

navigateToChampAnalytics(BuildContext context, String champId, String modeId) {
  return FilledButton(
      onPressed: () async {
        try {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      "Loading...",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            },
          );
          List<ChampionshipAnalytics> analytics = await ChampionshipAnalyticsCubit().analyticsNavigator();
          List<dynamic> data = await ChampionshipAnalyticsRepository().getQuestionAnalytics(int.parse(champId));
          List<ChampionshipAnalytics> curr = analytics
              .where(
                (element) => element.modeId == modeId,
              )
              .toList();
          if (!context.mounted) return;
          Navigator.pop(context);
          context.go("/landingPage/quizAnalytics", extra: {
            "data": data,
            "category_name": curr.first.categoryName,
            "champ_name": curr.first.champName,
            "start_time": DateFormat("MMMM E d h:mm a").format(DateTime.parse("${curr.first.startDate} ${curr.first.startTime}")),
            'champ_id': int.parse(curr.first.champId!),
            'gift_description': curr.first.giftDescription ?? "",
            'gift_type': curr.first.giftType ?? "",
            'gift_image': curr.first.giftImage ?? "",
            'gift_name': curr.first.giftName ?? "",
            'mode_name': curr.first.modeName,
            'end_time': "${curr.first.endDate} ${curr.first.endTime}"
          });
          mixpanel!.track("VisitedLeaderboard", properties: {
            "UserId": Hive.box(userDataDB).get("personalInfo")['user_id'],
            "UserKey": Hive.box(userDataDB).get("personalInfo")['user_key'],
            "ChampionshipId": int.parse(curr.first.champId!),
            "CategoryId": curr.first.categoryId,
            "VisitedOn": DateTime.now().toString(),
            "GameMode": curr.first.modeName,
            "VisitedFrom": AppRouter().router?.state!.name
          });
        } on DioException catch (e) {
          context.pop();
          snackBarKey.currentState?.showSnackBar(SnackBar(content: Text(errorStrings(e.type))));
        }
      },
      child: const Text("View Analytics"));
}
