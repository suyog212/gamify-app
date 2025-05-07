import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kGamify/blocs/championship_analytics_cubit.dart';
import 'package:kGamify/repositories/championship_analytics_repository.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:timeago/timeago.dart' as time_ago;

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  Map<String, double> dataMap = {
    "Top 10": 5,
    "11-100": 10,
    "100+": 2,
  };
  Map<String, String> gameModes = {"play_win_gift": "Play and Win", "quick_hit": "Quick Hit"};

  @override
  void didChangeDependencies() {
    context.read<ChampionshipAnalyticsCubit>().getAllAnalytics();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        actions: [
          if (kDebugMode)
            IconButton(
                onPressed: () async {
                  // log(Hive.box(userDataDB).toMap().toString());
                  // debugPrint(kToolbarHeight.toString());
                  // debugPrint("${MediaQuery.sizeOf(context).width - 32}");
                  // await Hive.box(qualificationDataDB).clear();
                },
                icon: const Icon(Icons.terminal))
        ],
      ),
      body: BlocBuilder<ChampionshipAnalyticsCubit, ChampionshipAnalyticsState>(
        builder: (context, state) {
          if (state is ChampionshipAnalyticsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChampionshipAnalyticsCubit>().getAllAnalytics();
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS0s56W7ZTO7tSKBMCPO1Eri6nhoQf8nwY7Q&s"),
                  // SizedBox(
                  //   height: MediaQuery.sizeOf(context).height * 0.35,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 2,
                  //         child: PieChart(
                  //           dataMap: dataMap,
                  //           legendOptions: LegendOptions(
                  //             showLegends: true,
                  //             legendShape: BoxShape.rectangle,
                  //             legendPosition: LegendPosition.bottom,
                  //             showLegendsInRow: true,
                  //             legendTextStyle:
                  //                 Theme.of(context).textTheme.labelMedium!,
                  //           ),
                  //           colorList: [
                  //             Colors.orange.shade800,
                  //             Colors.orange.shade400,
                  //             Colors.orange.shade200
                  //           ],
                  //           chartValuesOptions: ChartValuesOptions(
                  //               showChartValueBackground: false,
                  //               chartValueStyle: Theme.of(context)
                  //                   .textTheme
                  //                   .titleLarge!
                  //                   .copyWith(color: Colors.black)),
                  //           chartLegendSpacing: 10,
                  //           formatChartValues: (value) {
                  //             return value.toInt().toString();
                  //           },
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.stretch,
                  //           children: [
                  //             Expanded(
                  //                 child: Padding(
                  //               padding: const EdgeInsets.all(4.0),
                  //               child: DecoratedBox(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     border: Border.fromBorderSide(BorderSide(
                  //                         color: Theme.of(context)
                  //                             .colorScheme
                  //                             .secondary))),
                  //                 child: Center(
                  //                     child: AutoSizeText.rich(
                  //                   TextSpan(
                  //                       text: "14",
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .displaySmall
                  //                           ?.copyWith(
                  //                               fontWeight: FontWeight.bold),
                  //                       children: [
                  //                         const TextSpan(
                  //                             text: "th",
                  //                             style: TextStyle(fontFeatures: [
                  //                               FontFeature.superscripts()
                  //                             ])),
                  //                         TextSpan(
                  //                             text: "\nInstitute Rank",
                  //                             style: Theme.of(context)
                  //                                 .textTheme
                  //                                 .titleSmall)
                  //                       ]),
                  //                   textAlign: TextAlign.center,
                  //                 )),
                  //               ),
                  //             )),
                  //             Expanded(
                  //                 child: Padding(
                  //               padding: const EdgeInsets.all(4.0),
                  //               child: DecoratedBox(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     border: Border.fromBorderSide(BorderSide(
                  //                         color: Theme.of(context)
                  //                             .colorScheme
                  //                             .secondary))),
                  //                 child: Center(
                  //                   child: AutoSizeText.rich(
                  //                     TextSpan(
                  //                         text: "87",
                  //                         style: Theme.of(context)
                  //                             .textTheme
                  //                             .displaySmall
                  //                             ?.copyWith(
                  //                                 fontWeight: FontWeight.bold),
                  //                         children: [
                  //                           TextSpan(
                  //                               text: "%",
                  //                               style: Theme.of(context)
                  //                                   .textTheme
                  //                                   .titleMedium),
                  //                           TextSpan(
                  //                               text: "\nAverage Score",
                  //                               style: Theme.of(context)
                  //                                   .textTheme
                  //                                   .titleSmall)
                  //                         ]),
                  //                     textAlign: TextAlign.center,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )),
                  //             Expanded(
                  //                 child: Padding(
                  //               padding: const EdgeInsets.all(6.0),
                  //               child: DecoratedBox(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     border: Border.fromBorderSide(BorderSide(
                  //                         color: Theme.of(context)
                  //                             .colorScheme
                  //                             .secondary))),
                  //                 child: Center(
                  //                   child: AutoSizeText.rich(
                  //                     TextSpan(
                  //                         text: state.analytics
                  //                                     .elementAt(0)
                  //                                     .createdAt ==
                  //                                 null
                  //                             ? "0"
                  //                             : state.analytics.length.toString(),
                  //                         style: Theme.of(context)
                  //                             .textTheme
                  //                             .displaySmall
                  //                             ?.copyWith(
                  //                                 fontWeight: FontWeight.bold),
                  //                         children: [
                  //                           TextSpan(
                  //                               text: "\nChampionships Played",
                  //                               style: Theme.of(context)
                  //                                   .textTheme
                  //                                   .titleSmall)
                  //                         ]),
                  //                     textAlign: TextAlign.center,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  GroupedListView(
                    reverse: true,
                    shrinkWrap: true,
                    elements: state.analytics,
                    groupBy: (element) => DateFormat("MMMM d,yyyy").format(DateTime.parse(element.createdAt ?? DateTime.now().toString())),
                    groupSeparatorBuilder: (value) => AutoSizeText(value.toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                    itemBuilder: (context, element) {
                      if (element.createdAt == null) {
                        return SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  "Nothing to show here",
                                  style: Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                AutoSizeText(
                                  "Click here to play your first championship.",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      context.go("/landingPage");
                                    },
                                    child: const AutoSizeText("Play Championship")),
                              ],
                            )));
                      }
                      final start = DateFormat("MMMM d h:mm a").format(DateTime.parse("${element.startDate} ${element.startTime}"));
                      final end = DateFormat("MMMM d h:mm a").format(DateTime.parse("${element.endDate} ${element.endTime}"));
                      final formattedStartDate = DateTime.parse("${element.startDate} ${element.startTime}");
                      final formattedEndDate = DateTime.parse("${element.endDate} ${element.endTime}");
                      return Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Theme.of(context).colorScheme.secondary)), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AutoSizeText(
                                    gameModes[element.gameMode] ?? "",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  element.champName ?? "",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ).animate().slideX(),
                                subtitle: Text(element.categoryName ?? "").animate().slideY(),
                                trailing: LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (DateTime.parse(formattedStartDate.toString()).isAfter(DateTime.now())) {
                                      return Container(
                                        decoration: BoxDecoration(border: const Border.fromBorderSide(BorderSide(color: Colors.grey)), borderRadius: BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(3),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.cancel_outlined,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              " Upcoming",
                                              style: TextStyle(color: Colors.grey, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (DateTime.parse(formattedEndDate.toString()).isBefore(DateTime.now())) {
                                      return Container(
                                        decoration: BoxDecoration(border: const Border.fromBorderSide(BorderSide(color: Colors.redAccent)), borderRadius: BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(3),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.cancel_outlined,
                                              size: 14,
                                              color: Colors.redAccent,
                                            ),
                                            Text(
                                              " Ended",
                                              style: TextStyle(color: Colors.redAccent, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container(
                                      decoration: BoxDecoration(border: const Border.fromBorderSide(BorderSide(color: Colors.green)), borderRadius: BorderRadius.circular(5)),
                                      padding: const EdgeInsets.all(3),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.ellipsis_circle,
                                            size: 14,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            " Ongoing",
                                            style: TextStyle(color: Colors.green, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Divider(
                                color: Theme.of(context).colorScheme.inverseSurface,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: OverflowBar(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [const Text("Started : "), Text("${DateTime.parse(formattedEndDate.toString()).isBefore(DateTime.now()) ? "Ended" : "End"}   : ")],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [Text(start), Text(end)],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Theme.of(context).colorScheme.inverseSurface,
                                thickness: 0.2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  OverflowBar(
                                    children: [
                                      AutoSizeText(
                                        "Score : ${element.totalScore}",
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const VerticalDivider(),
                                      Tooltip(
                                          message: "Penalty : ${element.totalPenalty}\nBonus : ${element.totalBonus}\nWrong Questions : ${element.totalNegativePoints}",
                                          triggerMode: TooltipTriggerMode.tap,
                                          child: Icon(
                                            Icons.info_outline,
                                            size: Theme.of(context).textTheme.titleMedium?.fontSize,
                                          ))
                                    ],
                                  ),
                                  AutoSizeText(time_ago.format(DateTime.parse(element.createdAt ?? DateTime.now().toString()).toUtc().add(const Duration(hours: 5, minutes: 30))))
                                ],
                              ),
                              if (element.gameMode == 'play_win_gift')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (Uri.tryParse(element.giftImage ?? "") != null && Uri.tryParse(element.giftImage ?? "")!.isAbsolute)
                                      AutoSizeText(
                                        "Reward ",
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    SizedBox(
                                      height: 6.r,
                                    ),
                                    if (Uri.tryParse(element.giftImage ?? "") != null && Uri.tryParse(element.giftImage ?? "")!.isAbsolute)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(maxHeight: 150),
                                          child: CachedNetworkImage(
                                            imageUrl: element.giftImage ?? "",
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context, url, progress) {
                                              return CircularProgressIndicator(
                                                value: progress.progress,
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              SizedBox(
                                height: 8.r,
                              ),
                              InkWell(
                                onTap: () async {
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
                                    List<dynamic> data = await ChampionshipAnalyticsRepository().getQuestionAnalytics(int.parse(element.champId!));
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    context.go(
                                      "/landingPage/analytics/quizAnalytics",
                                      extra: {
                                        "data": data,
                                        "category_name": element.categoryName,
                                        "champ_name": element.champName,
                                        "start_time": DateFormat("MMMM E d h:mm a").format(DateTime.parse("${element.startDate} ${element.startTime}")),
                                        'champ_id': int.parse(element.champId!),
                                        'gift_description': element.giftDescription ?? "",
                                        'gift_type': element.giftType ?? "",
                                        'gift_image': element.giftImage ?? "",
                                        'gift_name': element.giftName ?? "",
                                        'mode_name': element.modeName,
                                        'end_time': "${element.endDate} ${element.endTime}"
                                      },
                                    );
                                    mixpanel!.track("VisitedLeaderboard", properties: {
                                      "UserId": Hive.box(userDataDB).get("personalInfo")['user_id'],
                                      "UserKey": Hive.box(userDataDB).get("personalInfo")['user_key'],
                                      "ChampionshipId": int.parse(element.champId!),
                                      "CategoryId": int.parse(element.categoryId!),
                                      "VisitedOn": DateTime.now().toString(),
                                      "GameMode": element.gameMode,
                                      "VisitedFrom": "Analytics"
                                    });
                                  } on DioException catch (e) {
                                    context.pop();
                                    snackBarKey.currentState?.showSnackBar(SnackBar(content: Text(errorStrings(e.type))));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "View Analytics",
                                      style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                  ),
                  const SizedBox(
                    height: kToolbarHeight,
                  )
                ],
              ),
            );
          }
          if (state is ChampionshipAnalyticsError) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  "Click here to play your first championship.",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (state.error == "No data found")
                  OutlinedButton(
                      onPressed: () {
                        context.go("/landingPage");
                        // Scaffold.of(context).closeDrawer();
                      },
                      child: const AutoSizeText("Play Championship")),
                if (state.error != "No data found")
                  TextButton(
                      onPressed: () {
                        context.read<ChampionshipAnalyticsCubit>().getAllAnalytics();
                      },
                      child: const AutoSizeText("Retry"))
              ],
            ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
