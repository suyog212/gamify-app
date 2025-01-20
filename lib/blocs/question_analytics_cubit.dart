import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/models/question_analytics.dart';
import 'package:kGamify/repositories/championship_analytics_repository.dart';
import 'package:kGamify/utils/constants.dart';


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
      List<dynamic> qAnalytics = await analyticsRepository.getQuestionAnalytics(champId);
      emit(QuestionAnalyticsLoaded(qAnalytics.map((e) => QuestionAnalytics.fromJson(e),).toList()));
    } on DioException catch (e){
      emit(QuestionAnalyticsError(errorStrings(e.type)));
    }
  }
}
