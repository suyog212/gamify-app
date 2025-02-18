import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/models/championship_analytics_model.dart';
import 'package:kGamify/utils/constants.dart';

class ChampionshipAnalyticsRepository {

  final API _api = API();
  final userId = Hive.box(userDataDB).get("personalInfo")['user_id'];

  Future<List<ChampionshipAnalytics>> getChampionshipAnalyticsData () async {
    Response response = await _api.sendRequests.get("/get_analytics.php?user_id=$userId");
    List<dynamic> data = response.data['data'];
    return data.map((e) => ChampionshipAnalytics.fromJson(e)).toList();
  }

  Future<List> getQuestionAnalytics(int champId) async {
    Response response = await _api.sendRequests.get("/get_analytics_per_question.php?user_id=$userId&champ_id=$champId");
    List<dynamic> data = response.data['data'];
    return data;
  }
}