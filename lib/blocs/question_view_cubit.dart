import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kGamify/repositories/question_repository.dart';
import 'package:kGamify/utils/constants.dart';

abstract class QuestionViewStates {}

class QuestionViewInitialState extends QuestionViewStates {}

class QuestionViewErrorState extends QuestionViewStates {}

class QuestionViewLoadingState extends QuestionViewStates {}

class QuestionViewAnsweredState extends QuestionViewStates {}

class ResultSubmittedState extends QuestionViewStates {}

class QuestionViewCubit extends Cubit<QuestionViewStates> {
  QuestionViewCubit() : super(QuestionViewInitialState());

  QuestionsRepository questionsRepository = QuestionsRepository();

  void submitQuestion(int questionId, String timeTaken, String expectedTime, double pointsEarned, String correctAns, String submittedAns, int champId) async {
    emit(QuestionViewLoadingState());
    try {
      int statusCode = await questionsRepository.sendQuestionData(questionId, timeTaken, expectedTime, pointsEarned, correctAns, champId, submittedAns);
      if (statusCode == 201 || statusCode == 200) {
        emit(QuestionViewAnsweredState());
        emit(QuestionViewInitialState());
      }
    } catch (e) {
      // ignore: prefer_const_constructors
      snackBarKey.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText("Something went wrong."),
        duration: const Duration(seconds: 2),
        showCloseIcon: true,
      ));
      emit(QuestionViewInitialState());
      // Get.showSnackbar( GetSnackBar(title: "Error",message: e.toString(),));
    }
  }

  void submitChampionshipResult(gameMode, totalNegative, champId, totalBonus, totalPenalty, totalScore, timeTaken, expectedTime, userId, totalQuestion, correctQuestion) async {
    try {
      // print("Clicked");
      emit(QuestionViewLoadingState());
      await questionsRepository.submitChampData(gameMode, totalNegative, champId, totalBonus, totalPenalty, totalScore, timeTaken, expectedTime, userId, totalQuestion, correctQuestion);
      emit(ResultSubmittedState());
      emit(QuestionViewInitialState());
    } catch (e) {
      snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Something went wrong.")));
      emit(QuestionViewInitialState());
    }
  }

  void reportWrongQuestion(BuildContext context, PageController pageController, int questionId, int champId, int teacherId, int questionsMarkedWrong, userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "Is this question wrong?",
            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () async {
                        try {
                          emit(QuestionViewLoadingState());
                          await questionsRepository.reportWrongQuestion(questionId, champId, teacherId, userId);
                          emit(QuestionViewAnsweredState());
                          questionsMarkedWrong += 1;
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          emit(QuestionViewInitialState());
                        } catch (e) {
                          snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Something went wrong")));
                          emit(QuestionViewInitialState());
                        }
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                const VerticalDivider(
                  color: Colors.transparent,
                ),
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        emit(QuestionViewInitialState());
                      },
                      child: Text(
                        "No",
                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                      )),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
