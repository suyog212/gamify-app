import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/models/question_analytics.dart';
import 'package:gamify_test/repositories/championship_analytics_repository.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:gamify_test/utils/router.dart';
import 'package:go_router/go_router.dart';

abstract class QuestionAnalyticsState{}

class QuestionAnalyticsInitial extends QuestionAnalyticsState {}
class QuestionAnalyticsLoading extends QuestionAnalyticsState {}
class QuestionAnalyticsLoaded extends QuestionAnalyticsState {
  final List<QuestionAnalytics> analytics;
  QuestionAnalyticsLoaded(this.analytics);
}
class QuestionAnalyticsError extends QuestionAnalyticsState {
  final String error;
  QuestionAnalyticsError(this.error);
}

class QuestionAnalyticsCubit extends Cubit<QuestionAnalyticsState> {
  QuestionAnalyticsCubit() : super(QuestionAnalyticsInitial());

  ChampionshipAnalyticsRepository analyticsRepository = ChampionshipAnalyticsRepository();

  void getQuestionAnalytics(int champId) async {
    try{
      List<QuestionAnalytics> qAnalytics = await analyticsRepository.getQuestionAnalytics(champId);
      emit(QuestionAnalyticsLoaded(qAnalytics));
    } on DioException catch (e){
      emit(QuestionAnalyticsError(errorStrings(e.type)));
    }
  }
}
