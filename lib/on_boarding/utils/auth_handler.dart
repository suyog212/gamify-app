import 'package:dio/dio.dart';
import 'package:gamify_test/api/api.dart';

class AuthHandler{
  final API _api = API();

  registerUser(String name,String email,String password,String phone,String qualification) async {
    try {
      Response response = await _api.sendRequests.post("/post_user_data.php?user_name=$name&email=$email&password=$password&phone_no=$phone&qualification=$qualification");
      return response;
    } on DioException catch (e){
      if (e.response!.statusCode == 409) {
        throw "User already exists";
      } else if(e.response!.statusCode! >= 500){
        throw "Server down.";
      }
      else {
        throw "Something went wrong.";
      }
    }
  }

  Future<Map<String, dynamic>> checkUser(String email,String password) async {
    try{
      Response response = await _api.sendRequests.get("/check_user_data.php?email=$email&password=$password");
      return response.data;
    } on DioException catch(e){
      // print(e.response!.statusCode);
      if(e.response!.statusCode == 469){
        throw "User doesn't exist. Check your email address and try again.";
      } else {
       throw "Server down.";
      }
    }
  }


  saveUserData(String userId, String name, String email, String age, String location, String phoneNo, String interests) async {
    try{
      Response response = await _api.sendRequests.get("/post_personal_data.php?user_id=$userId&name=$name&email=$email&age=$age&location=$location&phone_no=$phoneNo&interests=$interests");
      return response;
    } catch (e){
      throw "Something went wrong";
    }
  }
}