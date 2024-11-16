import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gamify_test/on_boarding/locale_selection.dart';
import 'package:gamify_test/on_boarding/personal_info.dart';
import 'package:gamify_test/on_boarding/user_authentication.dart';
import 'package:gamify_test/screens/analytics.dart';
import 'package:gamify_test/screens/home_screen.dart';
import 'package:gamify_test/screens/question_view.dart';
import 'package:gamify_test/screens/quiz_analytics.dart';
import 'package:gamify_test/screens/quiz_results.dart';
import 'package:gamify_test/screens/settings.dart';
import 'package:gamify_test/screens/user_profile.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

Future<bool> checkUserLogin(String email,String password) async {
  Response response = await Dio().post("https://kgamify.in/teacheradminpanel/apis/check_user_data.php?email=$email&password=$password");
  return response.statusCode == 200;
}

class AppRouter {
  static final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const LocaleSelection(),
      redirect: (context, state) {
        if(Hive.box(userDataDB).get("isLocaleSet",defaultValue: false)){
          return "/authentication";
        }
        return null;
      },
    ),
    GoRoute(
      path: "/questionView",
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return QuestionView(
            champName: args['champ_name'],
            champId: args['champ_id'],
          expectedTime: args['expected_time'],
          gameMode: args['game_mode'],
          questionsList: args['questions_list'],
          seconds: args['seconds'],
          teacherName: args['teacher_name'],
        );
      },
    ),
    GoRoute(path: "/quizResult",builder: (context, state) {
      Map<String,dynamic> args = state.extra as Map<String,dynamic>;
      return QuizResult(score: args['score'],
          totalQuestions: args['total_questions'],
          solvedQuestions: args['solved_questions'],
          wrongQuestions: args['wrong_questions']
      );
    },),
    GoRoute(path: "/personalInfo",
      builder: (context, state) => const PersonalInfoInput(),
      redirect: (context, state) {
        if(Hive.box(userDataDB).get("interests") != null && Hive.box(qualificationDataDB).length != 0){
          return "/landingPage";
        }
        return null;
      },
    ),
    GoRoute(
      path: "/authentication",
      builder: (context, state) => const UserAuthentication(),
      redirect: (context, state) {
        if (Hive.box(userDataDB).get("isLoggedIn",defaultValue: null) != null){
          return "/personalInfo";
        }
        return null;
      },
    ),
    GoRoute(
        path: "/landingPage",
        builder: (context, state) => const HomeScreen(),
        redirect: (context, state) async {
          Box box = Hive.box("UserData");
          if(await checkUserLogin(box.get("personalInfo")['email'], box.get("personalInfo")['password'])){
            await Hive.box(userDataDB).clear();
            await Hive.box(quizDataDB).clear();
            await Hive.box(qualificationDataDB).clear();
            snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("User logged out")));
          }
          return null;
        },
        routes: [
          GoRoute(path: "settings",builder: (context, state) => const Settings(),),
          GoRoute(
            path: "profile",
            builder: (context, state) => const UserProfile(),
          ),
          GoRoute(
              path: "analytics",
              builder: (context, state) => const Analytics(),
              routes: [
                GoRoute(
                  path: "quizAnalytics",
                  builder: (context, state) => const QuizAnalytics(),
                )
              ])
        ]),
  ],
    refreshListenable: Hive.box(userDataDB).listenable(keys: ["personalInfo","isLoggedIn","isLocaleSet"]),
    debugLogDiagnostics: true,
    navigatorKey: routerKey
  );

  GoRouter get router => _router;
}
