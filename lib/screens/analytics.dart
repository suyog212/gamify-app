import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/blocs/championship_analytics_cubit.dart';
import 'package:gamify_test/blocs/question_analytics_cubit.dart';
import 'package:gamify_test/repositories/championship_analytics_repository.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        actions: [
          if (kDebugMode)
            IconButton(
                onPressed: () async {
                  log(Hive.box(userDataDB).toMap().toString());
                  // await Hive.box(qualificationDataDB).clear();
                },
                icon: const Icon(Icons.terminal))
        ],
      ),
      body: BlocBuilder<ChampionshipAnalyticsCubit, ChampionshipAnalyticsState>(
        builder: (context, state) {
          if (state is ChampionshipAnalyticsLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          dataMap: dataMap,
                          legendOptions: LegendOptions(
                            showLegends: true,
                            legendShape: BoxShape.rectangle,
                            legendPosition: LegendPosition.bottom,
                            showLegendsInRow: true,
                            legendTextStyle:
                                Theme.of(context).textTheme.labelMedium!,
                          ),
                          colorList: [
                            Colors.orange.shade800,
                            Colors.orange.shade400,
                            Colors.orange.shade200
                          ],
                          chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: false,
                              chartValueStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black)),
                          chartLegendSpacing: 10,
                          formatChartValues: (value) {
                            return value.toInt().toString();
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                                child: Center(
                                    child: AutoSizeText.rich(
                                  TextSpan(
                                      text: "14",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      children: [
                                        const TextSpan(
                                            text: "th",
                                            style: TextStyle(fontFeatures: [
                                              FontFeature.superscripts()
                                            ])),
                                        TextSpan(
                                            text: "\nInstitute Rank",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall)
                                      ]),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                                child: Center(
                                  child: AutoSizeText.rich(
                                    TextSpan(
                                        text: "87",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "%",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium),
                                          TextSpan(
                                              text: "\nAverage Score",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall)
                                        ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                                child: Center(
                                  child: AutoSizeText.rich(
                                    TextSpan(
                                        text: state.analytics
                                                    .elementAt(0)
                                                    .createdAt ==
                                                null
                                            ? "0"
                                            : state.analytics.length.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "\nChampionships Played",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall)
                                        ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                GroupedListView(
                  shrinkWrap: true,
                  elements: state.analytics,
                  groupBy: (element) => DateFormat("dd-MM-yyyy").format(
                      DateTime.parse(
                          element.createdAt ?? DateTime.now().toString())),
                  groupSeparatorBuilder: (value) =>
                      AutoSizeText(value.toString()),
                  itemBuilder: (context, element) {
                    if (element.createdAt == null) {
                      return SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          child: const AutoSizeText("Nothing to show here"));
                    }
                    final start = DateFormat("MMM E d h:mm a").format(
                        DateTime.parse(
                            "${element.startDate} ${element.startTime}"));
                    final end = DateFormat("MMM E d h:mm a").format(
                        DateTime.parse(
                            "${element.endDate} ${element.endTime}"));
                    final formattedStartDate = DateTime.parse(
                        "${element.startDate} ${element.startTime}");
                    final formattedEndDate =
                        DateTime.parse("${element.endDate} ${element.endTime}");
                    return Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                element.categoryName ?? "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ).animate().slideX(),
                              subtitle: Text(element.champName ?? "")
                                  .animate()
                                  .slideY(),
                              trailing: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (DateTime.parse(
                                          formattedStartDate.toString())
                                      .isAfter(DateTime.now())) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: const Border.fromBorderSide(
                                              BorderSide(color: Colors.grey)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (DateTime.parse(
                                          formattedEndDate.toString())
                                      .isBefore(DateTime.now())) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: const Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.redAccent)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: const Border.fromBorderSide(
                                            BorderSide(color: Colors.green)),
                                        borderRadius: BorderRadius.circular(5)),
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
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Divider(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            OverflowBar(
                              children: [
                                const Icon(Icons.calendar_month),
                                const VerticalDivider(),
                                OverflowBar(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Started : "),
                                        Text(
                                            "${DateTime.parse(formattedEndDate.toString()).isBefore(DateTime.now()) ? "Ended" : "End"}   : ")
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [Text(start), Text(end)],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              thickness: 0.2,
                            ),
                            FutureBuilder(
                              future: ChampionshipAnalyticsRepository().getQuestionAnalytics(int.parse(element.champId!)),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Skeletonizer(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...List.generate(5, (index) {
                                        return const CircleAvatar(
                                          radius: 16,
                                        );
                                      },),
                                      const Icon(Icons.arrow_forward_ios)
                                    ],
                                  ));
                                }
                                if(snapshot.hasData) {
                                  final curr = snapshot.data;
                                  return SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border:
                                                    Border.fromBorderSide(
                                                        BorderSide(
                                                            color: curr?.elementAt(index).submittedAns == curr?.elementAt(index).correctAns ? Colors.green : Colors.red,
                                                            width: 1.5)),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child: AutoSizeText("${index + 1}"),
                                              );
                                            },
                                            padding: const EdgeInsets.all(4),
                                            shrinkWrap: true,
                                            itemCount: curr?.length,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context.go("/landingPage/analytics/quizAnalytics",extra: {
                                                "data" : snapshot.data
                                              });
                                            },
                                            icon: const Icon(Icons.arrow_forward_ios))
                                      ],
                                    ),
                                  );
                                }
                                if(snapshot.hasError){
                                  return const Center(child: AutoSizeText("Error loading data"),);
                                }
                                return const Center(child: AutoSizeText("Something went wrong."),);
                              }
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OverflowBar(
                                  children: [
                                    AutoSizeText(
                                      "Score : ${element.totalScore}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const VerticalDivider(),
                                    Tooltip(
                                        message:
                                            "Penalty : ${element.totalPenalty}\nBonus : ${element.totalBonus}\nNegative Marks : ${element.totalNegativePoints}",
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: Icon(
                                          Icons.info_outline,
                                          size: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontSize,
                                        ))
                                  ],
                                ),
                                AutoSizeText(time_ago.format(DateTime.parse(
                                    element.createdAt ??
                                        DateTime.now().toString())))
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ],
            );
          }
          if (state is ChampionshipAnalyticsError) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(state.error),
                TextButton(
                    onPressed: () {
                      context
                          .read<ChampionshipAnalyticsCubit>()
                          .getAllAnalytics();
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
