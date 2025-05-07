import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kGamify/models/questions_models.dart';
import 'package:kGamify/repositories/question_repository.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:no_screenshot/no_screenshot.dart';

abstract class QuestionsState {}

class QuestionLoadingState extends QuestionsState {}

class QuestionLoadedState extends QuestionsState {
  final List<QuestionsDetailsModel> questionModels;
  QuestionLoadedState(this.questionModels);
}

class QuestionErrorState extends QuestionsState {
  final String error;
  QuestionErrorState(this.error);
}

class QuestionAnsweredState extends QuestionsState {}

class QuestionsBloc extends Cubit<QuestionsState> {
  QuestionsBloc() : super(QuestionLoadingState());

  QuestionsRepository questionsRepository = QuestionsRepository();

  void getQuestions(int modeId, String champName, int timeMinutes, int noOfQuestions, String gameMode, String champId, int expectedTime, userId, BuildContext context, String teacherName, teacherId,
      categoryId) async {
    try {
      List<QuestionsDetailsModel> questionData = await questionsRepository.fetchQuestions(modeId, userId, int.parse(champId)) ?? [];
      questionData.shuffle();
      NoScreenshot.instance.screenshotOff();
      if (!context.mounted) return;
      context.go("/questionView", extra: {
        "champ_name": champName,
        "champ_id": int.parse(champId),
        "expected_time": expectedTime,
        "game_mode": gameMode,
        "questions_list": questionData.sublist(0, noOfQuestions > questionData.length ? questionData.length : noOfQuestions),
        "seconds": timeMinutes,
        "teacher_name": teacherName,
        "modeId": modeId,
        "teacherId": teacherId,
        "categoryId": categoryId
      });
    } on DioException catch (e) {
      emit(QuestionErrorState(errorStrings(e.type)));
    } on Exception {
      emit(QuestionErrorState("You can participate only once."));
    }
  }

  void questionAnswered() {
    emit(QuestionAnsweredState());
  }
}
