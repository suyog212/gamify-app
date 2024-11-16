class ChampionshipScoreEngine {
  double calculateScoreForCorrectAnswer(int expectedTime, int actualTime,
      double coinPerQuestion, bool isAnsCorrect, int negativeMarks) {
    double result = 0;
    expectedTime *= 60;
    if (isAnsCorrect) {
      if (actualTime < expectedTime) {
        result = coinPerQuestion + (actualTime / expectedTime);
      } else {
        result = coinPerQuestion - (actualTime / expectedTime);
      }
    } else {
      if (actualTime < expectedTime) {
        result = coinPerQuestion + (actualTime / expectedTime) + negativeMarks;
      } else {
        result = coinPerQuestion - (actualTime / expectedTime) + negativeMarks;
      }
    }
    return result;
  }

  double scoreMultiplierCalculator(String correctAns, List<int> selectedAns) {
    final correctAnsSet = correctAns.split(",").map(int.parse).toSet();
    final selectedAnsSet = selectedAns.toSet();

    // Check if all selected answers are in the correct answer set
    if (selectedAnsSet.difference(correctAnsSet).isEmpty) {
      final numCorrect = selectedAns.length;
      return numCorrect / correctAnsSet.length;
    } else {
      return 0; // Return 0 for incorrect options
    }
  }
}
