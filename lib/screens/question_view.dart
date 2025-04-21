import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kGamify/blocs/question_view_cubit.dart';
import 'package:kGamify/models/questions_models.dart';
import 'package:kGamify/repositories/banner_ad_repository.dart';
import 'package:kGamify/screens/home_screen.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/link_classifier.dart';
import 'package:kGamify/utils/quiz_utils/championship_score_engine.dart';
import 'package:kGamify/utils/widgets/option_tile.dart';
import 'package:kGamify/utils/widgets/question_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuestionView extends StatefulWidget {
  final List<QuestionsDetailsModel> questionsList;
  final String teacherName;
  final int seconds;
  final String gameMode;
  final String champName;
  final int champId;
  final int expectedTime;
  final int modeId;
  final int teacherId;
  final String categoryId;
  const QuestionView(
      {super.key,
      required this.questionsList,
      required this.seconds,
      required this.gameMode,
      required this.champName,
      required this.champId,
      required this.teacherName,
      required this.expectedTime,
      required this.modeId,
      required this.teacherId,
      required this.categoryId});

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final Box userData = Hive.box(userDataDB);

  final PageController _pageController = PageController();
  double _champScore = 0;
  Timer? _quizTimer;
  final Stopwatch _questionTimer = Stopwatch();
  final ValueNotifier<int> _timer = ValueNotifier(0);
  final List<String> _options = ['A', 'B', 'C', 'D', 'E'];
  final ListNotifier<List<int>> _selectedAns = ListNotifier<List<int>>([]);
  final ValueNotifier<int> _submittedQuestions = ValueNotifier(0);
  final AnswerSubmissionHandler _answerSubmissionHandler = AnswerSubmissionHandler();
  final ChampionshipScoreEngine _scoreEngine = ChampionshipScoreEngine();

  //For Analytics
  List<Map<String, dynamic>> quizData = [];

  //ChampResult
  int correctAnswers = 0;
  double totalNegativeMarks = 0;
  double totalBonus = 0;
  double totalPenalty = 0;

  @override
  void initState() {
    _timer.value = widget.seconds;
    _quizTimer = Timer.periodic(
      const Duration(seconds: 1),
      (ticker) {
        // print(_questionTimer.elapsed.inSeconds);
        // print(ticker.tick);
        if (_timer.value - 1 > 0) {
          _timer.value--;
        } else {
          _quizTimer?.cancel();
          if (_submittedQuestions.value != 0) {
            _answerSubmissionHandler.submitChampionShip(
                context: context,
                gameMode: widget.gameMode,
                totalNegative: totalNegativeMarks,
                champId: widget.champId,
                totalBonus: totalBonus,
                totalPenalty: totalPenalty,
                totalScore: _champScore,
                timeTaken: quizSubmissionTime(widget.seconds),
                expectedTime: quizSubmissionTime(widget.seconds),
                userId: userData.get("personalInfo")['user_id'],
                totalQuestion: widget.questionsList.length,
                correctQuestion: correctAnswers);
          } else {
            context.go("/landingPage");
          }
        }
      },
    );
    _questionTimer.start();
    super.initState();
  }

  @override
  void dispose() {
    _questionTimer.stop();
    _quizTimer?.cancel();
    // NoScreenshot.instance.screenshotOn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You can press the 'X' icon on the top right of the screen to exit.")));
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.champName,
              style: TextStyle(fontSize: 16.sp),
            ),
            actions: [
              if (kDebugMode)
                IconButton(
                    onPressed: () async {
                      debugPrint(await getContentType(
                          "https://files.porsche.com/filestore/image/multimedia/none/992-gt3-rs-modelimage-sideshot/model/cfbb8ed3-1a15-11ed-80f5-005056bbdc38/porsche-model.png"));
                      debugPrint(widget.questionsList.toString());
                      log(totalPenalty.toString());
                      debugPrint(totalNegativeMarks.toString());
                      debugPrint(totalBonus.toString());
                      debugPrint(correctAnswers.toString());
                      debugPrint(_champScore.toString());
                      debugPrint(_submittedQuestions.value.toString());
                      debugPrint(widget.seconds.toString());
                    },
                    icon: const Icon(Icons.terminal)),
              if (kDebugMode)
                IconButton(
                    onPressed: () {
                      _questionTimer.stop();
                      _quizTimer?.cancel();
                    },
                    icon: const Icon(Icons.pause)),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: RichText(
                            text: TextSpan(text: "Are you sure you want to exit the quiz?\n", style: TextStyle(fontSize: 24.sp, color: Theme.of(context).colorScheme.inverseSurface), children: [
                              TextSpan(text: "Your progress will not be saved.", style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5)))
                            ]),
                            textAlign: TextAlign.center,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: Icon(
                            Icons.warning_amber_rounded,
                            color: Theme.of(context).colorScheme.error,
                            size: Theme.of(context).textTheme.displayMedium!.fontSize! * 2,
                          ),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                      style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                                      onPressed: () {
                                        context.go("/landingPage");
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                const VerticalDivider(
                                  color: Colors.transparent,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                                      )),
                                )
                              ],
                            )
                          ],
                        );
                      },
                    );
                    // snackBarKey.currentState?.showSnackBar(const SnackBar(content: AutoSizeText("")));
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
                    FutureBuilder(
                      future: BannerAdRepository().getChampionshipBannerAds(widget.champId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Skeletonizer(
                            enabled: true,
                            child: SizedBox(),
                          );
                        }
                        if (snapshot.hasData) {
                          return CarouselSlider.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index, realIndex) {
                                return Image.network(snapshot.data!.elementAt(index)['ad_image']);
                              },
                              options: CarouselOptions(
                                autoPlay: true,
                                height: kToolbarHeight,
                                viewportFraction: 1.0,
                              ));
                        }
                        return const SizedBox(
                          child: Text("Ad"),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DefaultTextStyle(
                      style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium?.fontSize, color: Theme.of(context).colorScheme.inverseSurface, fontWeight: FontWeight.w500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: OverflowBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.stopwatch),
                                const SizedBox(
                                  width: 8,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _timer,
                                  builder: (context, value, child) => AutoSizeText(timerFormatted(timeInSecond: _timer.value)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: OverflowBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.question_answer_outlined),
                                const VerticalDivider(
                                  width: 8,
                                ),
                                AutoSizeText("${index + 1}/${widget.questionsList.length}"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: OverflowBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                  height: 22.r,
                                  width: 22.r,
                                  child: const AutoSizeText(
                                    "k",
                                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 8,
                                ),
                                AutoSizeText(widget.questionsList.elementAt(index).totalCoins!)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: ListView(
                        // padding: const EdgeInsets.symmetric(horizontal: 12),
                        shrinkWrap: true,
                        children: [
                          QuestionTile(
                            questionImg: widget.questionsList.elementAt(index).questionImage,
                            questionNo: "${index + 1}",
                            questionText: widget.questionsList.elementAt(index).questionText,
                          ),
                          const Divider(
                            color: Colors.transparent,
                          ),
                          AutoSizeText(
                            "Options : ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          if (widget.questionsList.elementAt(index).correctAnswer!.length > 1)
                            const AutoSizeText(
                              "Note : Select all correct options.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          const Divider(
                            color: Colors.transparent,
                          ),
                          OptionTile(
                            optionImg: widget.questionsList.elementAt(index).option1Img,
                            optionNo: "A) ",
                            optionText: widget.questionsList.elementAt(index).option1Text,
                          ),
                          OptionTile(
                            optionImg: widget.questionsList.elementAt(index).option2Img,
                            optionNo: "B) ",
                            optionText: widget.questionsList.elementAt(index).option2Text,
                          ),
                          OptionTile(
                            optionImg: widget.questionsList.elementAt(index).option3Img,
                            optionNo: "C) ",
                            optionText: widget.questionsList.elementAt(index).option3Text,
                          ),
                          OptionTile(
                            optionImg: widget.questionsList.elementAt(index).option4Img,
                            optionNo: "D) ",
                            optionText: widget.questionsList.elementAt(index).option4Text,
                          ),
                          AutoSizeText(
                            "E) Report question as wrong",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: kToolbarHeight,
                          )
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _selectedAns,
                      builder: (context, value, child) {
                        return GridView.builder(
                          itemCount: _options.length,
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 12),
                          itemBuilder: (context, buttonIndex) {
                            return InkWell(
                              onTap: () {
                                if (widget.questionsList.elementAt(index).correctAnswer!.length > 1) {
                                  if (value.contains(buttonIndex)) {
                                    _selectedAns.value.remove(buttonIndex);
                                  } else if (buttonIndex == 4) {
                                    value.clear();
                                    value.add(buttonIndex);
                                  } else {
                                    if (_selectedAns.value.contains(4)) {
                                      _selectedAns.value.remove(4);
                                    }
                                    _selectedAns.value.add(buttonIndex);
                                  }
                                } else {
                                  if (value.contains(buttonIndex)) {
                                    _selectedAns.value.remove(buttonIndex);
                                  } else if (buttonIndex == 4) {
                                    value.clear();
                                    value.add(buttonIndex);
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
                                    border: Border.fromBorderSide(
                                        BorderSide(color: _options.elementAt(buttonIndex) == "E" ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary, width: 2)),
                                    color: _options.elementAt(buttonIndex) == "E"
                                        ? value.contains(buttonIndex)
                                            ? Theme.of(context).colorScheme.error
                                            : Theme.of(context).colorScheme.surface
                                        : value.contains(buttonIndex)
                                            ? Theme.of(context).colorScheme.secondary
                                            : Theme.of(context).colorScheme.surface),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      _options.elementAt(buttonIndex),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
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
                              if (_selectedAns.value.isEmpty && (_submittedQuestions.value != widget.questionsList.length)) {
                                snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("No answer selected")));
                              } else if (_submittedQuestions.value == widget.questionsList.length) {
                                _answerSubmissionHandler.onChampSubmit(
                                    context: context,
                                    gameMode: widget.gameMode,
                                    totalNegative: totalNegativeMarks,
                                    champId: widget.champId,
                                    totalBonus: totalBonus,
                                    totalPenalty: totalPenalty,
                                    totalScore: _champScore,
                                    timeTaken: quizSubmissionTime(_quizTimer!.tick),
                                    expectedTime: quizSubmissionTime(widget.expectedTime * 60),
                                    userId: userData.get("personalInfo")['user_id'],
                                    totalQuestion: widget.questionsList.length,
                                    correctQuestion: correctAnswers);
                              } else {
                                if (_selectedAns.value.contains(4)) {
                                  context.read<QuestionViewCubit>().reportWrongQuestion(context, _pageController, int.parse(widget.questionsList.elementAt(index).questionId!), widget.champId,
                                      int.parse(widget.questionsList.elementAt(index).teacherId!), _answerSubmissionHandler.questionsMarkedWrong);
                                } else if (_scoreEngine.scoreMultiplierCalculator(
                                        widget.questionsList.elementAt(index).correctAnswer!,
                                        _selectedAns.value
                                            .map(
                                              (e) => e + 1,
                                            )
                                            .toList()) ==
                                    1) {
                                  _champScore += _scoreEngine.calculateScoreForCorrectAnswer(stringToSeconds(widget.questionsList.elementAt(index).expectedTime!), _questionTimer.elapsed.inSeconds,
                                      int.parse(widget.questionsList.elementAt(index).totalCoins!).toDouble(), true, -int.parse(widget.questionsList.elementAt(index).totalCoins!));
                                  correctAnswers += 1;
                                  final currData = widget.questionsList.elementAt(index);
                                  _answerSubmissionHandler.sendQuestionData(context,
                                      questionId: int.parse(currData.questionId!),
                                      timeTaken: _questionTimer.elapsed.inSeconds,
                                      expectedTime: stringToSeconds(currData.expectedTime!),
                                      perQuestionCoins: _scoreEngine.calculateScoreForCorrectAnswer(
                                        stringToSeconds(currData.expectedTime!),
                                        _questionTimer.elapsed.inSeconds,
                                        int.parse(currData.totalCoins!).toDouble(),
                                        true,
                                        -int.parse(currData.totalCoins!),
                                      ),
                                      correctAns: currData.correctAnswer!,
                                      submittedAns: _selectedAns.value
                                          .map(
                                            (e) => e + 1,
                                          )
                                          .toList()
                                          .join(","),
                                      champId: widget.champId);
                                  totalBonus += _questionTimer.elapsed.inSeconds / stringToSeconds(currData.expectedTime!);
                                  debugPrint("Correct");
                                } else {
                                  totalNegativeMarks += 1;
                                  _champScore += _scoreEngine.calculateScoreForCorrectAnswer(stringToSeconds(widget.questionsList.elementAt(index).expectedTime!), _questionTimer.elapsed.inSeconds,
                                      int.parse(widget.questionsList.elementAt(index).totalCoins!).toDouble(), false, -int.parse(widget.questionsList.elementAt(index).totalCoins!));
                                  final currData = widget.questionsList.elementAt(index);
                                  _answerSubmissionHandler.sendQuestionData(context,
                                      questionId: int.parse(currData.questionId!),
                                      timeTaken: _questionTimer.elapsed.inSeconds,
                                      expectedTime: stringToSeconds(currData.expectedTime!),
                                      perQuestionCoins: _scoreEngine.calculateScoreForCorrectAnswer(stringToSeconds(currData.expectedTime!), _questionTimer.elapsed.inSeconds,
                                          int.parse(currData.totalCoins!).toDouble(), false, -int.parse(currData.totalCoins!)),
                                      correctAns: currData.correctAnswer!,
                                      submittedAns: _selectedAns.value
                                          .map(
                                            (e) => e + 1,
                                          )
                                          .toList()
                                          .join(","),
                                      champId: widget.champId);
                                  totalPenalty += _scoreEngine.calculateScoreForCorrectAnswer(
                                      stringToSeconds(currData.expectedTime!), _questionTimer.elapsed.inSeconds, int.parse(currData.totalCoins!).toDouble(), false, -int.parse(currData.totalCoins!));
                                  debugPrint("Wrong");
                                }
                              }
                            },
                            child: Text((index + 1) == widget.questionsList.length ? "Submit" : "Next Question"));
                      },
                      listener: (context, state) {
                        if (state is QuestionViewAnsweredState) {
                          _submittedQuestions.value += 1;
                          _questionTimer.reset();
                          if (_submittedQuestions.value == widget.questionsList.length) {
                            _answerSubmissionHandler.onChampSubmit(
                                context: context,
                                gameMode: widget.gameMode,
                                totalNegative: totalNegativeMarks,
                                champId: widget.champId,
                                totalBonus: totalBonus,
                                totalPenalty: totalPenalty,
                                totalScore: _champScore,
                                timeTaken: quizSubmissionTime(_quizTimer!.tick),
                                expectedTime: quizSubmissionTime(widget.expectedTime * 60),
                                userId: userData.get("personalInfo")['user_id'],
                                totalQuestion: widget.questionsList.length,
                                correctQuestion: correctAnswers);
                          }
                          _selectedAns.value = [];
                          _pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
                        }
                        if (state is QuestionViewErrorState) {
                          snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Something went wrong")));
                        }
                        if (state is ResultSubmittedState) {
                          mixpanel!.track("ChampionshipPlayed", properties: {
                            "UserId": userData.get("personalInfo")['user_id'],
                            "ChampionshipId": widget.champId,
                            "GameModeId": widget.modeId,
                            "CategoryId": widget.categoryId,
                            "TeacherId": widget.teacherId,
                            "PlayedOn": DateTime.now().toString(),
                            "ChampionshipDuration": widget.expectedTime,
                          });
                          context.go("/quizResult", extra: {
                            "score": _champScore,
                            "total_questions": widget.questionsList.length,
                            "solved_questions": correctAnswers,
                            "wrong_questions": _answerSubmissionHandler.questionsMarkedWrong,
                            "champId": widget.champId,
                            "modeId": widget.modeId
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
}

String timerFormatted({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

String quizSubmissionTime(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int secondsRemaining = seconds % 60;

  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = secondsRemaining.toString().padLeft(2, '0');

  return '$formattedHours:$formattedMinutes:$formattedSeconds';
}

class ListNotifier<T> extends ValueNotifier<T> {
  ListNotifier(super.value);
  void notify() => notifyListeners();
}

class AnswerSubmissionHandler {
  int questionsMarkedWrong = 0;

  void submitChampionShip(
      {required BuildContext context,
      required String gameMode,
      required double totalNegative,
      required int champId,
      required double totalBonus,
      required double totalPenalty,
      required double totalScore,
      required String timeTaken,
      required String expectedTime,
      required String userId,
      required int totalQuestion,
      required int correctQuestion}) {
    context.read<QuestionViewCubit>().submitChampionshipResult(gameMode, totalNegative, champId, totalBonus, totalPenalty, totalScore, timeTaken, expectedTime, userId, totalQuestion, correctQuestion);
  }

  void onChampSubmit(
      {required BuildContext context,
      required String gameMode,
      required double totalNegative,
      required int champId,
      required double totalBonus,
      required double totalPenalty,
      required double totalScore,
      required String timeTaken,
      required String expectedTime,
      required dynamic userId,
      required int totalQuestion,
      required int correctQuestion}) {
    // Future.delayed(const Duration(seconds: 2));
    // NoScreenshot.instance.screenshotOn();
    context.read<QuestionViewCubit>().submitChampionshipResult(gameMode, totalNegative, champId, totalBonus, totalPenalty, totalScore, timeTaken, expectedTime, userId, totalQuestion, correctQuestion);
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //       title: Icon(
    //         Icons.info_outline_rounded,
    //         size: Theme.of(context).textTheme.displayMedium!.fontSize! * 2,
    //         color: Theme.of(context).colorScheme.secondary,
    //       ),
    //       content: Text(
    //         "Submit Championship ?",
    //         textAlign: TextAlign.center,
    //         style: Theme.of(context).textTheme.headlineSmall,
    //       ),
    //       actionsOverflowAlignment: OverflowBarAlignment.center,
    //       actionsAlignment: MainAxisAlignment.spaceBetween,
    //       actions: [
    //         Row(
    //           children: [
    //             Expanded(
    //               child: FilledButton(
    //                   onPressed: () {
    //                   },
    //                   child: const Text(
    //                     "Yes",
    //                     style: TextStyle(color: Colors.black),
    //                   )),
    //             ),
    //             const VerticalDivider(),
    //             Expanded(
    //               child: OutlinedButton(
    //                   style: OutlinedButton.styleFrom(
    //                       fixedSize:
    //                           Size.fromWidth(MediaQuery.sizeOf(context).width)),
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   },
    //                   child: Text(
    //                     "No",
    //                     style: TextStyle(
    //                         color:
    //                             Theme.of(context).colorScheme.inverseSurface),
    //                   )),
    //             )
    //           ],
    //         )
    //       ],
    //     );
    //   },
    // );
  }

  void onSubmittedQuestionWrong(BuildContext context, PageController pageController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "Is this question wrong?",
            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Icon(
            Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.error,
            size: Theme.of(context).textTheme.displayMedium!.fontSize! * 2,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () {
                        questionsMarkedWrong += 1;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                const VerticalDivider(
                  color: Colors.transparent,
                ),
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "No",
                        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                      )),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void sendQuestionData(BuildContext context,
      {required int questionId, required int timeTaken, required int expectedTime, required double perQuestionCoins, required String correctAns, required int champId, required String submittedAns}) {
    context.read<QuestionViewCubit>().submitQuestion(questionId, quizSubmissionTime(timeTaken), quizSubmissionTime(expectedTime), perQuestionCoins, correctAns, submittedAns, champId);
  }
}
