import 'package:dio/dio.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/models/championship_details_model.dart';
import 'package:kGamify/utils/constants.dart';

class ChampionshipRepository {

  final API _api = API();

  Future<List<ChampionshipsModel>> fetchCategory() async {
    try {
      Response response = await _api.sendRequests.get("/get_category.php");
      List<dynamic> categories = response.data["data"];
      List<List<ChampionshipDetails>> champDetails = [];
      List<ChampionshipsModel> champModels = [];
      for (int i = 0; i < categories.length; i++) {
        champDetails.add(await fetchChampDetails(int.parse(categories.elementAt(i)["champ_id"])));
      }
      for (int i = 0; i < categories.length; i++) {
        champModels.add(ChampionshipsModel(
            categoryId: categories.elementAt(i)["category_id"],
            categoryName: categories.elementAt(i)["category_name"],
            champId: categories.elementAt(i)["champ_id"],
            champName: categories.elementAt(i)["champ_name"],
            endDate: categories.elementAt(i)["end_date"],
            endTime: categories.elementAt(i)["end_time"],
            startDate: categories.elementAt(i)["start_date"],
            startTime: categories.elementAt(i)["start_time"],
            championshipDetails: champDetails.elementAt(i)
        ));
      }
      return champModels;
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
      List<TeacherDetailsModel> teachModels = [];
      List<ChampionshipDetails> champDetails = [];
      for (int i = 0; i < details.length; i++) {
        teachModels.add(await getTeacherDetails(int.parse(details.elementAt(i)["teacher_id"])));
      }
      for(int i = 0; i < details.length; i++){
        champDetails.add(ChampionshipDetails(
          startTime: details.elementAt(i)["start_time"],
          startDate: details.elementAt(i)["start_date"],
          endTime: details.elementAt(i)["end_time"],
          endDate: details.elementAt(i)["end_date"],
          champName: details.elementAt(i)["champ_name"],
          champId: details.elementAt(i)["champ_id"],
          categoryName: details.elementAt(i)["category_name"],
          categoryId: details.elementAt(i)["category_id"],
          timeMinutes: details.elementAt(i)["time_minutes"],
          teacherName: details.elementAt(i)["teacher_name"],
          teacherId: details.elementAt(i)["teacher_id"],
          teacherDetailsModel: teachModels.elementAt(i),
          noOfQuestion: details.elementAt(i)["no_of_question"],
          modeName: details.elementAt(i)["mode_name"],
          modeId: details.elementAt(i)["mode_id"],
          champStatus: details.elementAt(i)["champ_status"],
          categoryStatus: details.elementAt(i)["category_status"],
          uploadImg: details.elementAt(i)["upload_img"],
          giftImage: details.elementAt(i)['gift_image'],
          userQualification: details.elementAt(i)['user_qualification'],
          gameModeRules: details.elementAt(i)['game_mode_rules'],
          giftDescription: details.elementAt(i)['gift_description'],
          noOfUsersPlayed: details.elementAt(i)['no_of_user_played'],
          questionCount: details.elementAt(i)['question_count'],
          uniqueId: details.elementAt(i)['unique_id']
        ));
      }
      return champDetails;
    } catch (e) {
      return [ChampionshipDetails(champStatus: "0",categoryStatus: "0")];
    }
  }
}