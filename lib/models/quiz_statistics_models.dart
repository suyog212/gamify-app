class QuizAnsStats {
  final String question;
  final String ans;
  final String selectedAns;
  final int points;
  final int bonus;
  final String timeTaken;
  final String expectedTime;

  QuizAnsStats(this.question,this.points,this.selectedAns, this.ans, this.bonus, this.timeTaken, this.expectedTime);
}


class QuizStat {
  final String champName;
  final String categoryName;
  final int noOfQuestion;
  final List<QuizAnsStats> answerStats;
  QuizStat(this.champName, this.categoryName, this.noOfQuestion, this.answerStats);
}