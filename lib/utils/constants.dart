import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/api/api.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class UserValidation {
  RegExp emailExp = RegExp(
      r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');
  RegExp passExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
}

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

const String userDataDB = "8d7b0afdddea3f570493aabffee1f890-UserData";

const String quizDataDB = "8d7b0afdddea3f570493aabffee1f890-QuizData";

const String qualificationDataDB = "8d7b0afdddea3f570493aabffee1f890-Qualifications";

String errorStrings(DioExceptionType type) {
  Map<DioExceptionType, String> errors = {
    DioExceptionType.connectionError: "Error connecting to server.",
    DioExceptionType.connectionTimeout: "Connection timed out. Check your internet connection and try again",
    DioExceptionType.badResponse: "Something went wrong.",
    DioExceptionType.unknown: "Something went wrong."
  };
  return errors[type] ?? "Something went wrong";
  // switch(type){
  //   case DioExceptionType.connectionError: return "Error connecting to server.";
  //   case DioExceptionType.connectionTimeout: return "Connection timed out. Check your internet connection and try again";
  //   case DioExceptionType.badResponse: return "Something went wrong.";
  //   case DioExceptionType.unknown: return "Something went wrong.";
  //   default: return "Something went wrong";
  // }
}

Mixpanel? mixpanel;

Future<void> initMixpanel() async {
  // Once you've called this method once, you can access `mixpanel` throughout the rest of your application.
  mixpanel = await Mixpanel.init("273d1ebde9cbc7ed233559ed2a078cc0", trackAutomaticEvents: true);
}

GlobalKey<NavigatorState> routerKey = GlobalKey();

String generateOtp() {
  final random = Random();
  return (1000 + random.nextInt(9000)).toString();
}

const String rules = '''
1. All questions are compulsory
2. Navigating through questions is not allowed.
3. Can be played only once. Ensure you have stable internet connection

Note: 
1. Selecting option "E" will report the question as wrong.
2. Opening other apps is strictly prohibited. If detected your result will be submitted and you won't be able to participate again.
''';

Map<String, List<String>> messages = {
  "Perfect performance": ["You just crushed it! 🔥 Keep this energy going, you're unstoppable!", "Perfection unlocked! 💯 You’re on fire—don’t let anyone dim your shine!"],
  "Excellent performance": [
    "Almost there! 🔥 You’re so close to perfect, keep pushing yourself!",
    "You’re almost a legend! Keep hustling, the top is within reach!",
    "Top-tier performance! 💪 You're just one step away from greatness!"
  ],
  "Great performance": [
    "You’re killing it! 🚀 Keep going, greatness is just around the corner!",
    "You're doing awesome! Keep that momentum going—you’re destined for success!",
    "Solid effort, keep grinding, you’re on the way to something epic!"
  ],
  "Good performance": [
    "You’ve got this! 💪 You're doing great, just a little more effort and you’ll be unstoppable!",
    "Good job! You're on the right track—keep going and watch yourself level up!",
    "You’re making progress! 🌟 Stay focused and take it to the next level!"
  ],
  "Decent performance": [
    "Not bad, but you’ve got more in you! Keep pushing, you're closer than you think!",
    "You’ve got this! Keep up the effort and soon you’ll be hitting your goals!",
    "Decent start, but now it’s time to level up. Don’t stop—your potential is huge!"
  ],
  "Average performance": [
    "You're halfway there! Keep pushing—every step counts towards your goal!",
    "Not where you want to be? No worries, time to go all in and crush it next time!",
    "You’ve got the basics, now let’s level up! Keep at it, success is built on persistence!"
  ],
  "Needs Improvement": [
    "Hey, don't stress! 👊 Every failure is just a step closer to success. You've got this!",
    "You’ve got the potential to turn this around! Stay motivated and keep trying!",
    "It’s not about where you are, it’s about where you're headed. Let's bounce back stronger!",
    "This is just a challenge, not the end. Learn, grow, and show 'em what you're made of!"
  ]
};

List getQuote(Map<String, List> messages, double percentage) {
  String category = "";
  if (percentage == 1) {
    category = "Perfect performance";
  } else if (percentage >= 0.9) {
    category = "Excellent performance";
  } else if (percentage >= 0.8) {
    category = "Great performance";
  } else if (percentage >= 0.7) {
    category = "Good performance";
  } else if (percentage >= 0.7) {
    category = "Decent performance";
  } else if (percentage >= 0.5) {
    category = "Average performance";
  } else {
    category = "Needs Improvement";
  }

  return [category, messages[category]?.elementAt(Random().nextInt(messages[category]!.length))];
}

String formatChampionshipTime(String timeStr) {
  // Split the time string into hours, minutes, and seconds
  List<String> parts = timeStr.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  num totalMinutes = hours * 60 + minutes + seconds / 60;
  num totalHours = hours + (minutes / 60) + (seconds / 3600);
  // Format totalHours and totalMinutes to show 1 for 1.0 and 1.5 for 1.5
  String formattedTotalHours = totalHours == totalHours.toInt() ? totalHours.toInt().toString() : totalHours.toStringAsFixed(1);

  String formattedTotalMinutes = totalMinutes == totalMinutes.toInt() ? totalMinutes.toInt().toString() : totalMinutes.toStringAsFixed(1);

  if (hours > 0) {
    return '$formattedTotalHours Hour${hours > 1 ? 's' : ''}';
  } else if (minutes > 0) {
    return '$formattedTotalMinutes Minute${minutes > 1 ? 's' : ''}';
  } else {
    return '$seconds Second${seconds > 1 ? 's' : ''}';
  }
}

Future<int?> checkUserLogin() async {
  try {
    Response response = await API().sendRequests.get("/check_email.php?email=${Hive.box(userDataDB).get("personalInfo", defaultValue: {"email": "exmple@gmail.com"})['email']}");
    return response.statusCode;
  } on DioException catch (e) {
    if (e.response!.statusCode == 409) {
      // if(Hive.box(userDataDB).get("isLoggedIn",defaultValue: null) != null){
      //   await Hive.box(userDataDB).put("isLoggedIn",null);
      //   snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Your account has been disabled. Contact authorities to re-enable.")));
      // }
      return e.response!.statusCode;
    }
    return e.response!.statusCode;
  }
}
