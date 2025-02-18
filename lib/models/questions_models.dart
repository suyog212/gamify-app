class QuestionsDetailsModel {
  String? questionId;
  String? labelId;
  String? teacherId;
  String? questionText;
  String? option1Text;
  String? option2Text;
  String? option3Text;
  String? option4Text;
  String? questionImage;
  String? option1Img;
  String? option2Img;
  String? option3Img;
  String? option4Img;
  String? expectedTime;
  String? correctAnswer;
  String? totalCoins;

  QuestionsDetailsModel(
      {this.questionId,
        this.labelId,
        this.teacherId,
        this.questionText,
        this.option1Text,
        this.option2Text,
        this.option3Text,
        this.option4Text,
        this.questionImage,
        this.option1Img,
        this.option2Img,
        this.option3Img,
        this.option4Img,
        this.expectedTime,
        this.correctAnswer,
        this.totalCoins});

  QuestionsDetailsModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    labelId = json['label_id'];
    teacherId = json['teacher_id'];
    questionText = json['question_text'];
    option1Text = json['option1_text'];
    option2Text = json['option2_text'];
    option3Text = json['option3_text'];
    option4Text = json['option4_text'];
    questionImage = json['question_image'];
    option1Img = json['option1_img'];
    option2Img = json['option2_img'];
    option3Img = json['option3_img'];
    option4Img = json['option4_img'];
    expectedTime = json['expected_time'];
    correctAnswer = json['correct_answer'];
    totalCoins = json['total_coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['label_id'] = labelId;
    data['teacher_id'] = teacherId;
    data['question_text'] = questionText;
    data['option1_text'] = option1Text;
    data['option2_text'] = option2Text;
    data['option3_text'] = option3Text;
    data['option4_text'] = option4Text;
    data['question_image'] = questionImage;
    data['option1_img'] = option1Img;
    data['option2_img'] = option2Img;
    data['option3_img'] = option3Img;
    data['option4_img'] = option4Img;
    data['expected_time'] = expectedTime;
    data['correct_answer'] = correctAnswer;
    data['total_coins'] = totalCoins;
    return data;
  }
}
