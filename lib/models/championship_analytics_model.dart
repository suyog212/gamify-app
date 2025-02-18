class ChampionshipAnalytics {
  String? userId;
  String? userName;
  String? email;
  String? userQualification;
  String? phoneNo;
  String? firstLogin;
  String? recentLogin;
  String? timeTaken;
  String? expectedTime;
  String? gameMode;
  String? totalQuestions;
  String? correctQuestions;
  String? totalScore;
  String? totalBonus;
  String? totalPenalty;
  String? totalNegativePoints;
  String? createdAt;
  String? teacherId;
  String? teacherName;
  String? champId;
  String? champName;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? categoryId;
  String? categoryName;
  String? modeId;
  String? modeName;
  String? giftImage;
  String? giftType;
  String? giftName;
  String? giftDescription;

  ChampionshipAnalytics(
      {this.userId,
        this.userName,
        this.email,
        this.userQualification,
        this.phoneNo,
        this.firstLogin,
        this.recentLogin,
        this.timeTaken,
        this.expectedTime,
        this.gameMode,
        this.totalQuestions,
        this.correctQuestions,
        this.totalScore,
        this.totalBonus,
        this.totalPenalty,
        this.totalNegativePoints,
        this.createdAt,
        this.teacherId,
        this.teacherName,
        this.champId,
        this.champName,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.categoryId,
        this.categoryName,
        this.modeId,
        this.modeName,
        this.giftImage,
        this.giftType,
        this.giftName,
        this.giftDescription});

  ChampionshipAnalytics.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    email = json['email'];
    userQualification = json['user_qualification'];
    phoneNo = json['phone_no'];
    firstLogin = json['first_login'];
    recentLogin = json['recent_login'];
    timeTaken = json['time_taken'];
    expectedTime = json['expected_time'];
    gameMode = json['game_mode'];
    totalQuestions = json['total_questions'];
    correctQuestions = json['correct_questions'];
    totalScore = json['total_score'];
    totalBonus = json['total_bonus'];
    totalPenalty = json['total_penalty'];
    totalNegativePoints = json['total_negative_points'];
    createdAt = json['created_at'];
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
    champId = json['champ_id'];
    champName = json['champ_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    modeId = json['mode_id'];
    modeName = json['mode_name'];
    giftImage = json['gift_image'];
    giftType = json['gift_type'];
    giftName = json['gift_name'];
    giftDescription = json['gift_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['email'] = email;
    data['user_qualification'] = userQualification;
    data['phone_no'] = phoneNo;
    data['first_login'] = firstLogin;
    data['recent_login'] = recentLogin;
    data['time_taken'] = timeTaken;
    data['expected_time'] = expectedTime;
    data['game_mode'] = gameMode;
    data['total_questions'] = totalQuestions;
    data['correct_questions'] = correctQuestions;
    data['total_score'] = totalScore;
    data['total_bonus'] = totalBonus;
    data['total_penalty'] = totalPenalty;
    data['total_negative_points'] = totalNegativePoints;
    data['created_at'] = createdAt;
    data['teacher_id'] = teacherId;
    data['teacher_name'] = teacherName;
    data['champ_id'] = champId;
    data['champ_name'] = champName;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['mode_id'] = modeId;
    data['mode_name'] = modeName;
    data['gift_image'] = giftImage;
    data['gift_type'] = giftType;
    data['gift_name'] = giftName;
    data['gift_description'] = giftDescription;
    return data;
  }
}
