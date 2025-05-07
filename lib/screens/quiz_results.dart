import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kGamify/blocs/championship_analytics_cubit.dart';
import 'package:kGamify/models/championship_analytics_model.dart';
import 'package:kGamify/repositories/banner_ad_repository.dart';
import 'package:kGamify/repositories/championship_analytics_repository.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuizResult extends StatefulWidget {
  final double score;
  final int champId;
  final int totalQuestions;
  final int solvedQuestions;
  final int wrongQuestions;
  final int modeId;
  const QuizResult({super.key, required this.score, required this.totalQuestions, required this.solvedQuestions, required this.wrongQuestions, required this.champId, required this.modeId});

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {
  bool isAdLoaded = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 16.r, left: 16.r, bottom: 16.r),
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
                        options: CarouselOptions(autoPlay: true, height: kToolbarHeight.r, viewportFraction: 1.0));
                  }
                  return const SizedBox(
                    child: Text("Ad"),
                  );
                },
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  // height: 400.r,
                  child: Image.asset("assets/images/celebration-removebg-preview.png"),
                ),
              ),
              // Spacer(),
              AutoSizeText(
                "Your Score",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.r),
                textAlign: TextAlign.center,
              ),
              AutoSizeText(
                "${widget.solvedQuestions}/${widget.totalQuestions}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32.r, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w900),
              ),
              Visibility(
                  visible: widget.wrongQuestions != 0,
                  child: AutoSizeText(
                    "${widget.wrongQuestions} questions marked as wrong",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.r),
                  )),
              AutoSizeText(
                getQuote(messages, widget.solvedQuestions / widget.totalQuestions).first,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.r, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
              ),
              AutoSizeText(
                getQuote(messages, widget.solvedQuestions / widget.totalQuestions).last,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.r),
              ),
              const Divider(
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.4)),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            size: 14.r,
                          ),
                          const VerticalDivider(
                            width: 4,
                          ),
                          Text(
                            "${widget.score.toStringAsFixed(3)} Coins",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.r),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.transparent,
              ),
              // const Spacer(),
              _navigateToChampAnalytics(context, widget.champId.toString(), widget.modeId.toString()),
              // const Divider(color: Colors.transparent,),
              FilledButton(
                  onPressed: () {
                    context.go("/landingPage");
                  },
                  child: const Text("Explore championships"))
            ],
          ),
        ),
      ),
    );
  }

  _navigateToChampAnalytics(BuildContext context, String champId, String modeId) {
    return OutlinedButton(
        onPressed: () async {
          try {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      Text(
                        "Loading...",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              },
            );
            List<ChampionshipAnalytics> analytics = await ChampionshipAnalyticsCubit().analyticsNavigator();
            List<dynamic> data = await ChampionshipAnalyticsRepository().getQuestionAnalytics(int.parse(champId));
            List<ChampionshipAnalytics> curr = analytics
                .where(
                  (element) => element.modeId == modeId,
                )
                .toList();
            if (!context.mounted) return;
            Navigator.pop(context);
            context.go("/landingPage/quizAnalytics", extra: {
              "data": data,
              "category_name": curr.first.categoryName,
              "champ_name": curr.first.champName,
              "start_time": DateFormat("MMMM E d h:mm a").format(DateTime.parse("${curr.first.startDate} ${curr.first.startTime}")),
              'champ_id': int.parse(curr.first.champId!),
              'gift_description': curr.first.giftDescription ?? "",
              'gift_type': curr.first.giftType ?? "",
              'gift_image': curr.first.giftImage ?? "",
              'gift_name': curr.first.giftName ?? "",
              'mode_name': curr.first.modeName,
              'end_time': "${curr.first.endDate} ${curr.first.endTime}"
            });
            mixpanel!.track("VisitedLeaderboard", properties: {
              "UserId": Hive.box(userDataDB).get("personalInfo")['user_id'],
              "UserKey": Hive.box(userDataDB).get("personalInfo")['user_key'],
              "ChampionshipId": int.parse(curr.first.champId!),
              "CategoryId": curr.first.categoryId,
              "VisitedOn": DateTime.now().toString(),
              "GameMode": curr.first.modeName,
              "VisitedFrom": "ChampionshipResult"
            });
          } on DioException catch (e) {
            context.pop();
            snackBarKey.currentState?.showSnackBar(SnackBar(content: Text(errorStrings(e.type))));
          }
        },
        child: const Text("View Analytics"));
  }
}
