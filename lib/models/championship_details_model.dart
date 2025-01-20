class ChampionshipsModel {
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? champId;
  String? categoryId;
  String? categoryName;
  String? champName;
  List<ChampionshipDetails>? championshipDetails;

  ChampionshipsModel(
      {this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.champId,
        this.categoryId,
        this.categoryName,
        this.championshipDetails,
        this.champName});

  ChampionshipsModel.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'] ?? "";
    endDate = json['end_date'] ?? "";
    startTime = json['start_time'] ?? "";
    endTime = json['end_time'] ?? "";
    champId = json['champ_id'] ?? "";
    categoryId = json['category_id'] ?? "";
    categoryName = json['category_name'] ?? "";
    champName = json['champ_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['champ_id'] = champId;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['champ_name'] = champName;
    return data;
  }
}

class ChampionshipDetails {
  String? modeId;
  String? modeName;
  String? timeMinutes;
  String? noOfQuestion;
  String? champId;
  String? champName;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? categoryId;
  String? champStatus;
  String? categoryName;
  String? categoryStatus;
  String? teacherId;
  String? teacherName;
  String? uploadImg;
  String? giftImage;
  String? noOfUsersPlayed;
  String? userQualification;
  String? gameModeRules;
  String? giftDescription;
  String? questionCount;
  String? uniqueId;
  TeacherDetailsModel? teacherDetailsModel;

  ChampionshipDetails(
      {this.modeId,
        this.modeName,
        this.timeMinutes,
        this.noOfQuestion,
        this.champId,
        this.champName,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.categoryId,
        this.champStatus,
        this.categoryName,
        this.categoryStatus,
        this.teacherId,
        this.teacherDetailsModel,
        this.uploadImg,
        this.teacherName,
        this.giftImage,
         this.noOfUsersPlayed,
         this.userQualification,
         this.gameModeRules,
        this.giftDescription,
        this.questionCount,
        this.uniqueId
      });

  ChampionshipDetails.fromJson(Map<String, dynamic> json) {
    modeId = json['mode_id'];
    modeName = json['mode_name'];
    timeMinutes = json['time_minutes'];
    noOfQuestion = json['no_of_question'];
    champId = json['champ_id'];
    champName = json['champ_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    categoryId = json['category_id'];
    champStatus = json['champ_status'];
    categoryName = json['category_name'];
    categoryStatus = json['category_status'];
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
    giftImage = json['gift_image'];
    noOfUsersPlayed = json[''];
    userQualification = json[''];
    gameModeRules = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mode_id'] = modeId;
    data['mode_name'] = modeName;
    data['time_minutes'] = timeMinutes;
    data['no_of_question'] = noOfQuestion;
    data['champ_id'] = champId;
    data['champ_name'] = champName;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['category_id'] = categoryId;
    data['champ_status'] = champStatus;
    data['category_name'] = categoryName;
    data['category_status'] = categoryStatus;
    data['teacher_id'] = teacherId;
    data['teacher_name'] = teacherName;
    data['gift_image'] = giftImage;
    data[''] = noOfUsersPlayed;
    data[''] = userQualification;
    data[''] = gameModeRules;
    return data;
  }
}

class TeacherDetailsModel {
  String? teacherId;
  String? uniqueId;
  String? status;
  String? teacherName;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? institute;
  String? department;
  String? uploadImg;
  Null verifyToken;
  String? createdAt;
  String? champsCreated;

  TeacherDetailsModel(
      {required this.teacherId,
        required this.uniqueId,
        required this.status,
        required this.teacherName,
        required this.username,
        required this.email,
        required this.password,
        required this.phone,
        required this.institute,
        required this.department,
        required this.uploadImg,
        this.verifyToken,
        required this.createdAt,
        this.champsCreated
      });

  TeacherDetailsModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_id'];
    uniqueId = json['unique_id'];
    status = json['status'];
    teacherName = json['teacher_name'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    institute = json['institute'];
    department = json['department'];
    uploadImg = json['upload_img'];
    verifyToken = json['verify_token'];
    createdAt = json['created_at'];
    champsCreated = json['championship_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teacher_id'] = teacherId;
    data['unique_id'] = uniqueId;
    data['status'] = status;
    data['teacher_name'] = teacherName;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['institute'] = institute;
    data['department'] = department;
    data['upload_img'] = uploadImg;
    data['verify_token'] = verifyToken;
    data['created_at'] = createdAt;
    data['championship_count'] = champsCreated;
    return data;
  }
}
