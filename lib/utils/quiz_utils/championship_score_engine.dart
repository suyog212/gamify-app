class ChampionshipScoreEngine {
  double calculateScoreForCorrectAnswer(int expectedTime, int actualTime,
      double coinPerQuestion, bool isAnsCorrect, int negativeMarks) {
    double result = 0;
    // expectedTime *= 60;
    if (isAnsCorrect) {
      if (actualTime < expectedTime) {
        result = coinPerQuestion + ((1 - (actualTime / expectedTime)) * coinPerQuestion);
      } else {
        result = coinPerQuestion - (((actualTime / expectedTime) - 1) * coinPerQuestion);
      }
    } else {
      if (actualTime < expectedTime) {
        result = (coinPerQuestion + ((1 - (actualTime / expectedTime)) * coinPerQuestion) + negativeMarks) * -1;
      } else {
        // result = ((((actualTime / expectedTime) - 1) * coinPerQuestion) + coinPerQuestion) * -1;
        result = (coinPerQuestion * - 1);
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
