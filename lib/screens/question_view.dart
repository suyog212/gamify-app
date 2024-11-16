import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/blocs/question_view_cubit.dart';
import 'package:gamify_test/models/questions_models.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:gamify_test/utils/quiz_utils/championship_score_engine.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

class QuestionView extends StatefulWidget {
  final List<QuestionsDetailsModel> questionsList;
  final String teacherName;
  final int seconds;
  final String gameMode;
  final String champName;
  final int champId;
  final int expectedTime;
  const QuestionView(
      {super.key,
      required this.questionsList,
      required this.seconds,
      required this.gameMode,
      required this.champName,
      required this.champId,
        required this.teacherName,
      required this.expectedTime});

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final Box userData = Hive.box(userDataDB);

  final PageController _pageController = PageController();
  final double _champScore = 0;
  Timer? _quizTimer;
  final Stopwatch _questionTimer = Stopwatch();
  final ValueNotifier<int> _timer = ValueNotifier(0);
  final List<String> _options = ['A', 'B', 'C', 'D', 'E'];
  final ListNotifier<List<int>> _selectedAns = ListNotifier<List<int>>([]);
  final ValueNotifier<int> _submittedQuestions = ValueNotifier(0);
  final AnswerSubmissionHandler _answerSubmissionHandler =
      AnswerSubmissionHandler();
  final ChampionshipScoreEngine _scoreEngine = ChampionshipScoreEngine();

  //For Analytics
  List<Map<String,dynamic>> quizData = [];

  //ChampResult
  int correctAnswers = 0;
  int totalNegativeMarks = 0;
  double totalBonus = 0;
  double totalPenalty = 0;

  @override
  void initState() {
    _timer.value = widget.seconds * 60;
    _quizTimer = Timer.periodic(
      const Duration(seconds: 1),
      (ticker) {
        // print(ticker.tick);
        if (_timer.value - 1 > 0) {
          _timer.value--;
        } else {
          _quizTimer?.cancel();
          _answerSubmissionHandler.submitChampionShip(
              context: context,
              gameMode: widget.gameMode,
              totalNegative: _answerSubmissionHandler.questionsMarkedWrong,
              champId: widget.champId,
              totalBonus: totalBonus,
              totalPenalty: totalPenalty,
              totalScore: _champScore,
              timeTaken: _answerSubmissionHandler
                  .quizSubmissionTime(widget.seconds * 60),
              expectedTime: _answerSubmissionHandler
                  .quizSubmissionTime(widget.seconds * 60),
              userId: userData.get("personalInfo")['user_id'],
              totalQuestion: widget.questionsList.length,
              correctQuestion: correctAnswers);
        }
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _questionTimer.stop();
    _quizTimer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("You can press the 'X' icon on the top right of the screen to exit.")));
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.champName),
            actions: [
              IconButton(
                  onPressed: () {
                    context.go("/landingPage");
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          body: PageView.builder(
            itemCount: widget.questionsList.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: kToolbarHeight,
                      child: Center(
                        child: Text("this is an ad"),
                      ),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontWeight: FontWeight.w500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _timer,
                            builder: (context, value, child) => AutoSizeText(
                                "Time : ${timerFormatted(timeInSecond: _timer.value)}"),
                          ),
                          OverflowBar(
                            children: [
                              const Icon(Icons.question_answer_outlined),
                              const VerticalDivider(
                                width: 8,
                              ),
                              AutoSizeText(
                                    "${index + 1}/${widget.questionsList.length}"),
                            ],
                          ),
                          const OverflowBar(
                            children: [
                              Icon(CupertinoIcons.bitcoin_circle_fill),
                              VerticalDivider(
                                width: 8,
                              ),
                              AutoSizeText("20")
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    AutoSizeText(
                      "Q.${index + 1} ${widget.questionsList.elementAt(index).questionText}",
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      "Options : ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    if (widget.questionsList
                            .elementAt(index)
                            .correctAnswer!
                            .length >
                        1)
                      const AutoSizeText(
                        "Note : Select all correct options.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          AutoSizeText(
                            """
      A) ${widget.questionsList.elementAt(index).option1Text}
      B) ${widget.questionsList.elementAt(index).option2Text}
      C) ${widget.questionsList.elementAt(index).option3Text}
      D) ${widget.questionsList.elementAt(index).option4Text}
                  """,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _selectedAns,
                      builder: (context, value, child) {
                        return GridView.builder(
                          itemCount: _options.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5, crossAxisSpacing: 12),
                          itemBuilder: (context, buttonIndex) {
                            return InkWell(
                              onTap: () {
                                if (widget.questionsList
                                        .elementAt(index)
                                        .correctAnswer!
                                        .length >
                                    1) {
                                  if (value.contains(buttonIndex)) {
                                    _selectedAns.value.remove(buttonIndex);
                                  } else {
                                    _selectedAns.value.add(buttonIndex);
                                  }
                                } else {
                                  if (value.contains(buttonIndex)) {
                                    _selectedAns.value.remove(buttonIndex);
                                  } else {
                                    if (_selectedAns.value.isNotEmpty) {
                                      _selectedAns.value.removeLast();
                                    }
                                    _selectedAns.value.add(buttonIndex);
                                  }
                                }
                                _selectedAns.notify();
                                // ignore: invalid_use_of_protected_member
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                    color: value.contains(buttonIndex)
                                        ? Theme.of(context).colorScheme.secondary
                                        : Theme.of(context).colorScheme.surface),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      _options.elementAt(buttonIndex),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocConsumer<QuestionViewCubit, QuestionViewStates>(
                      builder: (context, state) {
                        if (state is QuestionViewLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return FilledButton(
                            onPressed: () {
                              debugPrint(correctAnswers.toString());
                              if (_submittedQuestions.value ==
                                  widget.questionsList.length) {
                                Hive.box(quizDataDB).put(DateTime.now().toString(), {
                                  "gameMode" : widget.gameMode,
                                  "totalNegativePoints" : totalNegativeMarks,
                                  "champId" : widget.champId,
                                  "champName" : widget.champName,
                                  "totalBonus" : totalBonus,
                                  "totalPenalty" : totalPenalty,
                                  "totalScore" : _champScore,
                                  "timeTaken" : _quizTimer!.tick,
                                  "expectedTime" : widget.expectedTime,
                                  "totalQuestions" : widget.questionsList.length,
                                  "teacherName" : widget.teacherName,
                                  "questionData" : quizData
                                });
                                _answerSubmissionHandler.onChampSubmit(
                                    context: context,
                                    gameMode: widget.gameMode,
                                    totalNegative: totalNegativeMarks,
                                    champId: widget.champId,
                                    totalBonus: totalBonus,
                                    totalPenalty: totalPenalty,
                                    totalScore: _champScore,
                                    timeTaken: _answerSubmissionHandler
                                        .quizSubmissionTime(_quizTimer!.tick),
                                    expectedTime: _answerSubmissionHandler
                                        .quizSubmissionTime(
                                            widget.expectedTime * 60),
                                    userId:
                                        userData.get("personalInfo")['user_id'],
                                    totalQuestion: widget.questionsList.length,
                                    correctQuestion: correctAnswers);
                              } else {
                                quizData.add({
                                  "isCorrect" : _scoreEngine.scoreMultiplierCalculator(
                                      widget.questionsList
                                          .elementAt(index)
                                          .correctAnswer!,
                                      _selectedAns.value),
                                  "timeTaken" : _questionTimer.elapsed.inSeconds,
                                  "pointsEarned" : widget.questionsList.elementAt(index).totalCoins,
                                  "submittedAnd" : _selectedAns.value.map((e) => e + 1,).toList().join(","),
                                  "correctAns" : widget.questionsList.elementAt(index).correctAnswer,
                                  "expectedTime" : widget.questionsList.elementAt(index).expectedTime
                                });
                                if (_selectedAns.value.contains(4)) {
                                  _answerSubmissionHandler
                                      .onSubmittedQuestionWrong(
                                          context, _pageController);
                                } else if (_scoreEngine.scoreMultiplierCalculator(
                                        widget.questionsList
                                            .elementAt(index)
                                            .correctAnswer!,
                                        _selectedAns.value) == 1) {
                                  correctAnswers += 1;
                                  final currData = widget.questionsList.elementAt(index);
                                  _answerSubmissionHandler.sendQuestionData(context,
                                      questionId: int.parse(currData.questionId!),
                                      timeTaken: _questionTimer.elapsed.inSeconds,
                                      expectedTime: int.parse(currData.expectedTime!),
                                      perQuestionCoins: _scoreEngine.calculateScoreForCorrectAnswer(
                                          int.parse(currData.expectedTime!),
                                          _questionTimer.elapsed.inSeconds,
                                          int.parse(currData.totalCoins!).toDouble(),
                                          true,
                                          -int.parse(currData.totalCoins!)),
                                      correctAns: currData.correctAnswer!,
                                      submittedAns: _selectedAns.value.map((e) => e + 1,).toList().join(",")
                                  );
                                  debugPrint("Correct");
                                } else {
                                  final currData = widget.questionsList.elementAt(index);
                                  _answerSubmissionHandler.sendQuestionData(context,
                                      questionId: int.parse(currData.questionId!),
                                      timeTaken: _questionTimer.elapsed.inSeconds,
                                      expectedTime: int.parse(currData.expectedTime!),
                                      perQuestionCoins: _scoreEngine.calculateScoreForCorrectAnswer(
                                          int.parse(currData.expectedTime!),
                                          _questionTimer.elapsed.inSeconds,
                                          int.parse(currData.totalCoins!).toDouble(),
                                          false,
                                          -int.parse(currData.totalCoins!)),
                                      correctAns: currData.correctAnswer!,
                                      submittedAns: _selectedAns.value.map((e) => e + 1,).toList().join(",")
                                  );
                                  debugPrint("Wrong");
                                }
                              }
                            },
                            child: Text((index + 1) == widget.questionsList.length
                                ? "Submit"
                                : "Next Question"));
                      },
                      listener: (context, state) {
                        if (state is QuestionViewAnsweredState) {
                          _selectedAns.value = [];
                          _submittedQuestions.value += 1;
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeInOut);
                        }
                        if (state is QuestionViewErrorState) {
                          snackBarKey.currentState?.showSnackBar(const SnackBar(
                              content: Text("Something went wrong")));
                        }
                        if (state is ResultSubmittedState) {
                          context.go("/quizResult", extra: {
                            "score": _champScore,
                            "total_questions": widget.questionsList.length,
                            "solved_questions": correctAnswers,
                            "wrong_questions":
                                _answerSubmissionHandler.questionsMarkedWrong
                          });
                        }
                      },
                    )
                  ],
                ),
              );
            },
          )),
    );
  }

  String timerFormatted({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
}

class ListNotifier<T> extends ValueNotifier<T> {
  ListNotifier(super.value);
  void notify() => notifyListeners();
}

class AnswerSubmissionHandler {
  int questionsMarkedWrong = 0;

  String quizSubmissionTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secondsRemaining = seconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = secondsRemaining.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }

  void submitChampionShip(
      {required BuildContext context,
      required String gameMode,
      required int totalNegative,
      required int champId,
      required double totalBonus,
      required double totalPenalty,
      required double totalScore,
      required String timeTaken,
      required String expectedTime,
      required String userId,
      required int totalQuestion,
      required int correctQuestion}) {
    context.read<QuestionViewCubit>().submitChampionshipResult(
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
        correctQuestion);
  }

  void onChampSubmit(
      {required BuildContext context,
      required String gameMode,
      required int totalNegative,
      required int champId,
      required double totalBonus,
      required double totalPenalty,
      required double totalScore,
      required String timeTaken,
      required String expectedTime,
      required String userId,
      required int totalQuestion,
      required int correctQuestion}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Submit Championship ?"),
          actions: [
            TextButton(
                onPressed: () {
                  context.read<QuestionViewCubit>().submitChampionshipResult(
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
                      correctQuestion);
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"))
          ],
        );
      },
    );
  }

  void onSubmittedQuestionWrong(
      BuildContext context, PageController pageController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Is this question wrong ?"),
          actions: [
            TextButton(
                onPressed: () {
                  questionsMarkedWrong += 1;
                  Navigator.pop(context);
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"))
          ],
        );
      },
    );
  }

  void sendQuestionData(BuildContext context,
      {required int questionId,
      required int timeTaken,
      required int expectedTime,
        required double perQuestionCoins,
      required String correctAns,
      required String submittedAns}) {
    context.read<QuestionViewCubit>().submitQuestion(
        questionId,
        quizSubmissionTime(timeTaken),
        quizSubmissionTime(expectedTime),
        perQuestionCoins,
        correctAns,
        submittedAns
    );
  }
}
