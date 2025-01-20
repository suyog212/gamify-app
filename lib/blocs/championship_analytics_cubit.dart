import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/models/championship_analytics_model.dart';
import 'package:kGamify/repositories/championship_analytics_repository.dart';
import 'package:kGamify/utils/constants.dart';

abstract class ChampionshipAnalyticsState {}

class ChampionshipAnalyticsInitial extends ChampionshipAnalyticsState {}

class ChampionshipAnalyticsLoading extends ChampionshipAnalyticsState {}

class ChampionshipAnalyticsLoaded extends ChampionshipAnalyticsState {
  List<ChampionshipAnalytics> analytics;
  ChampionshipAnalyticsLoaded(this.analytics);
}

class ChampionshipAnalyticsError extends ChampionshipAnalyticsState {
  String error;
  ChampionshipAnalyticsError(this.error);
}

class ChampionshipAnalyticsCubit extends Cubit<ChampionshipAnalyticsState> {
  ChampionshipAnalyticsCubit() : super(ChampionshipAnalyticsInitial()){
    getAllAnalytics();
  }

  ChampionshipAnalyticsRepository analyticsRepository = ChampionshipAnalyticsRepository();

  void getAllAnalytics() async {
   try{
     emit(ChampionshipAnalyticsLoading());
     List<ChampionshipAnalytics> allAnalytics = await analyticsRepository.getChampionshipAnalyticsData();
     emit(ChampionshipAnalyticsLoaded(allAnalytics));
   } on DioException catch (e) {
     if(e.response != null && e.response!.statusCode == 469) {
       emit(ChampionshipAnalyticsError("No data found"));
     } else {
       emit(ChampionshipAnalyticsError(errorStrings(e.type)));
     }
   }
  }

  Future<List<ChampionshipAnalytics>> analyticsNavigator() async {
    try{
      List<ChampionshipAnalytics> allAnalytics = await analyticsRepository.getChampionshipAnalyticsData();
      return allAnalytics;
    } on DioException catch (e) {
      if(e.response != null && e.response!.statusCode == 469) {
        throw ("No data found");
      } else {
        throw (errorStrings(e.type));
      }
    }
  }


  void getQuestionAnalytics() async {}
}
