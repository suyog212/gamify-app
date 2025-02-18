class QuestionAnalytics {
  int? userId;
  String? userName;
  String? email;
  String? userQualification;
  String? phoneNo;
  String? firstLogin;
  String? recentLogin;
  int? questionId;
  String? timeTaken;
  String? expectedTime;
  int? points;
  int? correctAns;
  int? submittedAns;
  String? questionText;
  String? option1Text;
  String? option2Text;
  String? option3Text;
  String? option4Text;
  int? totalCoins;
  int? teacherId;
  String? teacherName;
  int? labelId;
  String? labelName;

  QuestionAnalytics(
      {this.userId,
        this.userName,
        this.email,
        this.userQualification,
        this.phoneNo,
        this.firstLogin,
        this.recentLogin,
        this.questionId,
        this.timeTaken,
        this.expectedTime,
        this.points,
        this.correctAns,
        this.submittedAns,
        this.questionText,
        this.option1Text,
        this.option2Text,
        this.option3Text,
        this.option4Text,
        this.totalCoins,
        this.teacherId,
        this.teacherName,
        this.labelId,
        this.labelName});

  QuestionAnalytics.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    email = json['email'];
    userQualification = json['user_qualification'];
    phoneNo = json['phone_no'];
    firstLogin = json['first_login'];
    recentLogin = json['recent_login'];
    questionId = json['question_id'];
    timeTaken = json['time_taken'];
    expectedTime = json['expected_time'];
    points = json['points'];
    correctAns = json['correct_ans'];
    submittedAns = json['submitted_ans'];
    questionText = json['question_text'];
    option1Text = json['option1_text'];
    option2Text = json['option2_text'];
    option3Text = json['option3_text'];
    option4Text = json['option4_text'];
    totalCoins = json['total_coins'];
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
    labelId = json['label_id'];
    labelName = json['label_name'];
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
    data['question_id'] = questionId;
    data['time_taken'] = timeTaken;
    data['expected_time'] = expectedTime;
    data['points'] = points;
    data['correct_ans'] = correctAns;
    data['submitted_ans'] = submittedAns;
    data['question_text'] = questionText;
    data['option1_text'] = option1Text;
    data['option2_text'] = option2Text;
    data['option3_text'] = option3Text;
    data['option4_text'] = option4Text;
    data['total_coins'] = totalCoins;
    data['teacher_id'] = teacherId;
    data['teacher_name'] = teacherName;
    data['label_id'] = labelId;
    data['label_name'] = labelName;
    return data;
  }
}
