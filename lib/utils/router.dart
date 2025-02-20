import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kGamify/models/questions_models.dart';
import 'package:kGamify/on_boarding/forgot_password.dart';
import 'package:kGamify/on_boarding/locale_selection.dart';
import 'package:kGamify/on_boarding/personal_info.dart';
import 'package:kGamify/on_boarding/user_authentication.dart';
import 'package:kGamify/screens/analytics.dart';
import 'package:kGamify/screens/home_screen.dart';
import 'package:kGamify/screens/question_view.dart';
import 'package:kGamify/screens/quiz_analytics.dart';
import 'package:kGamify/screens/quiz_results.dart';
import 'package:kGamify/screens/settings.dart';
import 'package:kGamify/screens/user_profile.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:upgrader/upgrader.dart';

class AppRouter {

  static final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const LocaleSelection(),
      redirect: (context, state) async {
        // if(Hive.box(userDataDB).get("isLocaleSet",defaultValue: false)){
        //   return "/authentication";
        // }
        int? code = await checkUserLogin();
        FlutterNativeSplash.remove();
        if(code == 200){
          return "/landingPage";
        }
        return "/authentication";
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
          questionsList: args['questions_list'] as List<QuestionsDetailsModel>,
          seconds: args['seconds'],
          teacherName: args['teacher_name'],
          modeId: args['modeId'],
        );
      },
    ),
    GoRoute(path: "/quizResult",builder: (context, state) {
      Map<String,dynamic> args = state.extra as Map<String,dynamic>;
      return QuizResult(score: args['score'],
        totalQuestions: args['total_questions'],
        solvedQuestions: args['solved_questions'],
        wrongQuestions: args['wrong_questions'],
        champId: args['champId'],
        modeId: args['modeId'],
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
      routes: [
        GoRoute(
          path: "forgotPassword",
          builder: (context, state) => const ForgotPassword(),
        )
      ],
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
        redirect: (context, state) {
          // final data = Hive.box(userDataDB).get("personalInfo");
          // context.read<AuthCubit>().signInUser(data['email'], data['password']);
          return null;
        },
        routes: [
          GoRoute(path: "settings",builder: (context, state) => const Settings(),),
          GoRoute(
              path: "profile",
              builder: (context, state) => const UserProfile(),
              routes: [
                GoRoute(path: "personalInfoEdit",
                  builder: (context, state) => const PersonalInfoInput(),
                ),
              ]
          ),
          GoRoute(
            path: "analytics",
            builder: (context, state) => const Analytics(),
            routes: [
              GoRoute(
                path: "quizAnalytics",
                builder: (context, state) {
                  Map<String,dynamic> args = state.extra as Map<String,dynamic>;
                  return QuizAnalytics(
                    analyticsData: args['data'],
                    categoryName: args['category_name'],
                    champName: args['champ_name'],
                    startTime: args['start_time'],
                    champId: args['champ_id'],
                    giftDescription: args['gift_description'],
                    giftType: args['gift_type'],
                    giftImage: args['gift_image'],
                    giftName: args['gift_name'],
                    modeName: args['mode_name'],
                    endTime: args['end_time'],
                  );
                },
              )
            ],),
          GoRoute(
            path: "/quizAnalytics",
            builder: (context, state) {
              Map<String,dynamic> args = state.extra as Map<String,dynamic>;
              return QuizAnalytics(
                analyticsData: args['data'],
                categoryName: args['category_name'],
                champName: args['champ_name'],
                startTime: args['start_time'],
                champId: args['champ_id'],
                giftDescription: args['gift_description'],
                giftType: args['gift_type'],
                giftImage: args['gift_image'],
                giftName: args['gift_name'],
                modeName: args['mode_name'],
                endTime: args['end_time'],
              );
            },
          )
        ]),
  ],
      refreshListenable: Hive.box(userDataDB).listenable(keys: ["personalInfo","isLoggedIn","isLocaleSet"]),
      debugLogDiagnostics: true,
      navigatorKey: routerKey
  );

  GoRouter? get router => _router;
}
