import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/models/championship_details_model.dart';
import 'package:kGamify/utils/constants.dart';

// ============================
// TOP-LEVEL ISOLATE FUNCTIONS
// ============================

List<ChampionshipDetails> parseChampDetails(Map<String, dynamic> payload) {
  List<dynamic> details = payload['details'];
  List<TeacherDetailsModel> teachers = payload['teachers'];

  List<ChampionshipDetails> champDetails = [];
  for (int i = 0; i < details.length; i++) {
    final e = details[i];
    champDetails.add(ChampionshipDetails(
      startTime: e["start_time"],
      startDate: e["start_date"],
      endTime: e["end_time"],
      endDate: e["end_date"],
      champName: e["champ_name"],
      champId: e["champ_id"],
      categoryName: e["category_name"],
      categoryId: e["category_id"],
      timeMinutes: e["time_minutes"],
      teacherName: e["teacher_name"],
      teacherId: e["teacher_id"],
      teacherDetailsModel: teachers[i],
      noOfQuestion: e["no_of_question"],
      modeName: e["mode_name"],
      modeId: e["mode_id"],
      champStatus: e["champ_status"],
      categoryStatus: e["category_status"],
      uploadImg: e["upload_img"],
      giftImage: e['gift_image'],
      userQualification: e['user_qualification'],
      gameModeRules: e['game_mode_rules'],
      giftDescription: e['gift_description'],
      noOfUsersPlayed: e['no_of_user_played'],
      questionCount: e['question_count'],
      uniqueId: e['unique_id'],
    ));
  }
  return champDetails;
}

List<ChampionshipsModel> parseChampionshipsModel(Map<String, dynamic> input) {
  List<dynamic> categories = input['categories'];
  List<List<ChampionshipDetails>> champDetails = input['champDetails'];

  List<ChampionshipsModel> champModels = [];

  for (int i = 0; i < categories.length; i++) {
    final item = categories[i];
    champModels.add(ChampionshipsModel(
      categoryId: item["category_id"],
      categoryName: item["category_name"],
      champId: item["champ_id"],
      champName: item["champ_name"],
      endDate: item["end_date"],
      endTime: item["end_time"],
      startDate: item["start_date"],
      startTime: item["start_time"],
      championshipDetails: champDetails[i],
    ));
  }

  return champModels;
}

// ============================
// CHAMPIONSHIP REPOSITORY
// ============================

class ChampionshipRepository {
  final API _api = API();

  Future<List<ChampionshipsModel>> fetchCategory() async {
    try {
      Response response = await _api.sendRequests.get("/get_category.php");
      List<dynamic> categories = response.data["data"];

      List<Future<List<ChampionshipDetails>>> detailFutures = categories.map((e) {
        return fetchChampDetails(int.parse(e["champ_id"]));
      }).toList();

      List<List<ChampionshipDetails>> champDetails = await Future.wait(detailFutures);

      return await compute(parseChampionshipsModel, {
        'categories': categories,
        'champDetails': champDetails,
      });
    } on DioException catch (e) {
      throw errorStrings(e.type);
    }
  }

  Future<TeacherDetailsModel> getTeacherDetails(int teacherId) async {
    try {
      final response = await _api.sendRequests.get('/get_teacher_details.php?teacher_id=$teacherId');
      return TeacherDetailsModel.fromJson(response.data['data']);
    } catch (error) {
      throw Exception('Failed to fetch teacher details');
    }
  }

  Future<List<ChampionshipDetails>> fetchChampDetails(int champId) async {
    try {
      Response response = await _api.sendRequests.get("/fetch_details.php?champ_id=$champId");
      List<dynamic> details = response.data['data'];

      List<Future<TeacherDetailsModel>> teacherFutures = details.map((e) {
        return getTeacherDetails(int.parse(e["teacher_id"]));
      }).toList();

      List<TeacherDetailsModel> teachModels = await Future.wait(teacherFutures);

      return await compute(parseChampDetails, {
        'details': details,
        'teachers': teachModels,
      });
    } catch (e) {
      return [ChampionshipDetails(champStatus: "0", categoryStatus: "0")];
    }
  }
}
