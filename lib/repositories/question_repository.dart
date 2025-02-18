import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/models/questions_models.dart';
import 'package:kGamify/utils/constants.dart';

class QuestionsRepository {
  final API _api = API();

  Future<List<QuestionsDetailsModel>?> fetchQuestions(
      int modeId, userId, int champId) async {
    try {
      await _api.sendRequests
          .get("/check_user_played.php?user_id=$userId&champ_id=$champId");
      throw Exception("You can only participate once.");
    } on DioException catch (e) {
      if(e.response!.statusCode != 200){
        Response response =
        await _api.sendRequests.get("/get_question.php?mode_id=$modeId");
        List<dynamic> questionData = response.data['data'];
        return questionData
            .map((e) => QuestionsDetailsModel.fromJson(e))
            .toList();
      } else {
       rethrow;
      }
    }
  }

  Future<int> sendQuestionData(
      int questionId,
      String timeTaken,
      String expectedTime,
      double pointsEarned,
      String correctAns,
      int champId,
      String submittedAns) async {
    try {
      Response response = await _api.sendRequests.get(
          "/post_result.php?question_id=$questionId&champ_id=$champId&user_id=${Hive.box(userDataDB).get("personalInfo")['user_id']}&time_taken=$timeTaken&expected_time=$expectedTime&points_earned=$pointsEarned&correct_ans=$correctAns&submitted_ans=$submittedAns");
      int statusCode = response.data["status"];
      return statusCode;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<int> submitChampData(
      gameMode,
      totalNegative,
      champId,
      totalBonus,
      totalPenalty,
      totalScore,
      timeTaken,
      expectedTime,
       userId,
      totalQuestion,
      correctQuestion) async {
    try {
      Response response = await _api.sendRequests.post(
          "/post_final_result.php?champ_id=$champId&user_id=$userId&time_taken=$timeTaken&expected_time=$expectedTime&game_mode=$gameMode&total_questions=$totalQuestion&correct_questions=$correctQuestion&total_score=$totalScore&total_bonus=$totalBonus&total_penalty=$totalPenalty&total_negative_points=$totalNegative");
      int status = response.data['status'];
      return status;
    } catch (e) {
      rethrow;
    }
  }


  reportWrongQuestion(int questionId, int champId, int teacherId) async {
    try{
      Response response = await _api.sendRequests.post("/post_wrong_questions.php?question_id=$questionId&champ_id=$champId&teacher_id=$teacherId");
      int status = response.data['status'];
      return status;
    }
    catch (e){
      rethrow;
    }
  }
}
