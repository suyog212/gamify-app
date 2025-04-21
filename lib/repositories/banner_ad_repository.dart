import 'package:dio/dio.dart';
import 'package:kGamify/api/api.dart';

// https://kgamify.in/championshipmaker/apis/fetch_advertisements.php
// https://kgamify.in/championshipmaker/apis/fetch_champ_advertisements.php?champ_id=22

class BannerAdRepository {
  final API _api = API();

  Future<List> getAdPosters() async {
    Response response = await _api.sendRequests.get("/fetch_advertisements.php");
    return response.data['data'];
  }

  Future<List> getChampionshipBannerAds(int champId) async {
    Response response = await _api.sendRequests.get("/fetch_champ_advertisements.php?champ_id=$champId");
    return response.data['data'];
  }
}
