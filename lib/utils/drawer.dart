import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/blocs/user_image_bloc.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/models/questions_models.dart';
import 'package:kGamify/on_boarding/auth_screen.dart';
import 'package:kGamify/utils/constants.dart';

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
                child: BlocBuilder<UserDataBloc, UserImageStates>(
                  builder: (context, state) {
                    if (state is UserImageSet) {
                      return CircleAvatar(
                        backgroundImage: MemoryImage(state.image),
                      );
                    }
                    return const CircleAvatar();
                  },
                ),
              ),
              // accountName: const Text("Suyog"), accountEmail: const Text("suyog.22220300@viit.ac.in"),
              accountName:
                  Text(Hive.box(userDataDB).get("personalInfo")["name"] ?? ""),
              accountEmail:
                  Text(Hive.box(userDataDB).get("personalInfo")["email"]),
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
            title: Text(S.current.analytics),
            onTap: () {
              context.go("/landingPage/analytics");
            },
          ),
          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("QuestionView"),
              onTap: () {
                context.go("/questionView", extra: {
                  "champ_name": "Cooking",
                  "champ_id": 24,
                  "expected_time": 23,
                  "game_mode": "play_win_gift",
                  "questions_list": <QuestionsDetailsModel>[
                    QuestionsDetailsModel(
                      correctAnswer: "1",
                      option1Text: "A cross-platform app development framework",
                      option2Text: "A programming language",
                      option3Text: "A mobile operating system",
                      option4Text: "A cloud-based development environment",
                      questionText: "What is Flutter?",
                      questionId: "1",
                      totalCoins: "20",
                      expectedTime: "10",
                      questionImage:
                          "<a>https://www.youtube.com/watch?v=pWr3kgmx-nE</a>",
                      // questionImage: "https://files.porsche.com/filestore/image/multimedia/none/992-gt3-rs-modelimage-sideshot/model/cfbb8ed3-1a15-11ed-80f5-005056bbdc38/porsche-model.png",
                      option1Img:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS0s56W7ZTO7tSKBMCPO1Eri6nhoQf8nwY7Q&s",
                      option2Img:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS0s56W7ZTO7tSKBMCPO1Eri6nhoQf8nwY7Q&s",
                      option3Img:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS0s56W7ZTO7tSKBMCPO1Eri6nhoQf8nwY7Q&s",
                      option4Img:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS0s56W7ZTO7tSKBMCPO1Eri6nhoQf8nwY7Q&s",
                    ),
                  ],
                  "seconds": 900,
                  "teacher_name": "Suyog",
                  "modeId" : 43
                });
              },
            ),
          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text("quizResult"),
              onTap: () {
                context.go("/quizResult", extra: {
                  "score": 10.33,
                  "total_questions": 10,
                  "solved_questions": 7,
                  "wrong_questions": 3,
                  "champId": 23
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
            trailing: const Icon(Icons.logout),
            title: Text(S.current.logOut),
            onTap: () async {
              await Hive.box(userDataDB).clear();
              await Hive.box(quizDataDB).clear();
              await Hive.box(qualificationDataDB).clear().whenComplete(
                    () {
                  if (!context.mounted) return;
                  context.go("/");
                },
              );
            },
          ),
          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("test"),
              onTap: () {
                mixpanel!.track('UserLogOut',properties: {
                  "user_id" : Hive.box(userDataDB).get("personalInfo")['user_id'],
                  "timeStamp" : DateTime.now().toString()
                });
                mixpanel!.reset();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ));
                // context.go("/landingPage/settings");
              },
            ),
        ],
      ),
    );
  }
}
