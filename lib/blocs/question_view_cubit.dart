import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/repositories/question_repository.dart';
import 'package:gamify_test/utils/constants.dart';

abstract class QuestionViewStates{}

class QuestionViewInitialState extends QuestionViewStates {}

class QuestionViewErrorState extends QuestionViewStates {}

class QuestionViewLoadingState extends QuestionViewStates{}

class QuestionViewAnsweredState extends QuestionViewStates{}

class ResultSubmittedState extends QuestionViewStates{}

class QuestionViewCubit  extends Cubit<QuestionViewStates>{
  QuestionViewCubit() : super(QuestionViewInitialState());

  QuestionsRepository questionsRepository = QuestionsRepository();

  void submitQuestion(int questionId,String timeTaken,String expectedTime,double pointsEarned,String correctAns,String submittedAns,int champId) async {
    emit(QuestionViewLoadingState());
    try{
      int statusCode = await questionsRepository.sendQuestionData(questionId, timeTaken, expectedTime, pointsEarned, correctAns,champId,submittedAns);
      if(statusCode == 201){
        emit(QuestionViewAnsweredState());
        emit(QuestionViewInitialState());
      }
    } catch (e) {
      snackBarKey.currentState?.showSnackBar(SnackBar(content: AutoSizeText("Error: $e"),duration: const Duration(seconds: 2),showCloseIcon: true,));
      emit(QuestionViewInitialState());
      // Get.showSnackbar( GetSnackBar(title: "Error",message: e.toString(),));
    }
  }

  void submitChampionshipResult(String gameMode, double totalNegative, int champId,double totalBonus, double totalPenalty, double totalScore, String timeTaken, String expectedTime, dynamic userId,int totalQuestion, int correctQuestion) async {
    try {
      await questionsRepository.submitChampData(gameMode, totalNegative, champId, totalBonus, totalPenalty, totalScore, timeTaken, expectedTime, userId, totalQuestion, correctQuestion);
      emit(ResultSubmittedState());
      emit(QuestionViewInitialState());
    } catch (e){
      snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Something went wrong.")));
      emit(QuestionViewInitialState());
    }
  }

  void reportWrongQuestion(BuildContext context,PageController pageController) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Are you sure this question is wrong?"),
        actions: [
          TextButton(onPressed: () {
            pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
          }, child: const Text("Yes")),
          TextButton(onPressed: () {
            Navigator.pop(context);
          } , child: const Text("No"))
        ],
      );
    },);
  }
}