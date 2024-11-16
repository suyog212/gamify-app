import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamify_test/models/questions_models.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: Hero(
                tag: "UserPfp",
                child: CircleAvatar(
                  radius: MediaQuery.sizeOf(context).width * 0.15,
                  backgroundImage:Hive.box(userDataDB).get("UserImage", defaultValue: null) == null ? null:
                  MemoryImage(Hive.box(userDataDB).get("UserImage", defaultValue: null)),
                ),
              ),
              // accountName: const Text("Suyog"), accountEmail: const Text("suyog.22220300@viit.ac.in"),
              accountName: Text(Hive.box(userDataDB).get("personalInfo")["name"]),
              accountEmail: Text(Hive.box(userDataDB).get("personalInfo")["email"])
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.person),
            title: const Text("Profile"),
            onTap: () {
              context.go("/landingPage/profile");
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph),
            title: const Text("Analytics"),
            onTap: () {
              context.go("/landingPage/analytics");
            },
          ),
          if(kDebugMode) ListTile(
            leading: const Icon(Icons.book),
            title: const Text("QuestionView"),
            onTap: () {
              context.go("/questionView",extra: {
                "champ_name" : "Cooking",
                "champ_id": 34,
                "expected_time" : 23,
                "game_mode" : "play_win_gift",
                "questions_list" : <QuestionsDetailsModel>[
                  QuestionsDetailsModel(
                      correctAnswer: "1,2",
                      option1Text: "A cross-platform app development framework",
                      option2Text: "A programming language",
                      option3Text: "A mobile operating system",
                      option4Text: "A cloud-based development environment",
                      questionText: "What is Flutter?",
                      questionId: "1",
                      totalCoins: "20",
                      expectedTime: "10"
                  ),
                ],
                "seconds" : 20,
                "teacher_name" : "Suyog"
              });
            },
          ),
          if(kDebugMode) ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text("quizResult"),
            onTap: () {
              context.go("/quizResult",extra: {
                "score" : 10.33,
                "total_questions" : 10,
                "solved_questions" : 7,
                "wrong_questions" : 3
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              context.go("/landingPage/settings");
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () async {
              await Hive.box(userDataDB).clear();
              await Hive.box(quizDataDB).clear();
              await Hive.box(qualificationDataDB).clear().whenComplete(() {
                if(!context.mounted) return;
                context.go("/");
              },);
            },
          )
        ],
      ),
    );
  }
}
