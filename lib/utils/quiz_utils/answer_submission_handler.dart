// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kgamify/blocs/question_view_cubit.dart';
// import 'package:kgamify/utils/constants.dart';
// import 'package:kgamify/utils/quiz_utils/championship_score_engine.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hive_flutter/adapters.dart';
//
// class AnswerSubmissionHandler {
//
//   final ChampionshipScoreEngine _championshipScoreEngine = ChampionshipScoreEngine();
//   int totalNegativePoints = 0;
//   int totalBonus = 0;
//   int totalPenalty = 0;
//   int totalScore = 0;
//   int userId = Hive.box(userDataDB).get("personalInfo")['user_id'];
//   int correctAnsweredQuestions = 0;
//   int questionsMarkedWrong = 0;
//
//
//   void onChampSubmit(
//       {required BuildContext context,
//         required String gameMode,
//         required int totalNegative,
//         required int champId,
//         required double totalBonus,
//         required double totalPenalty,
//         required double totalScore,
//         required String timeTaken,
//         required String expectedTime,
//         required String userId,
//         required int totalQuestion,
//         required int correctQuestion}) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Submit Championship ?"),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   context.read<QuestionViewCubit>().submitChampionshipResult(
//                       gameMode,
//                       totalNegative,
//                       champId,
//                       totalBonus,
//                       totalPenalty,
//                       totalScore,
//                       timeTaken,
//                       expectedTime,
//                       userId,
//                       totalQuestion,
//                       correctQuestion);
//                   context.go("/quizResult",extra: {
//                     "score" : totalScore,
//                     "total_questions" : totalQuestion,
//                     "solved_questions" : correctQuestion,
//                     "wrong_questions" : questionsMarkedWrong
//                   });
//                 },
//                 child: const Text("Yes")),
//             TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("No"))
//           ],
//         );
//       },
//     );
//   }
//
// }
