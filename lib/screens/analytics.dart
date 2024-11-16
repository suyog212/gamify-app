import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

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

  final Box _quizData = Hive.box(quizDataDB);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                      legendTextStyle: Theme.of(context).textTheme.labelMedium!,
                    ),
                    colorList: [
                      Colors.orange.shade800,
                      Colors.orange.shade400,
                      Colors.orange.shade200
                    ],
                    chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: false,
                      chartValueStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black
                      )
                    ),
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
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
                                  text: _quizData.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                DateFormat("MMMM d,yyyy").format(DateTime.now()),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(4),
            subtitle: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText("Kitchen Art"),
                    AutoSizeText("Points : 53.4536")
                  ],
                ),
                AutoSizeText("Prasad Nathe")
              ],
            ),
            title: Text("Cooking",style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold
            ),),
            children: const [
              ListTile(
                title: AutoSizeText("Q1. What is flutter ? "),
                subtitle: AutoSizeText("Correct Ans : A"),
                trailing: AutoSizeText("Points : 20"),
              ),
              ListTile(
                title: AutoSizeText("Q1. What is flutter ? "),
                subtitle: AutoSizeText("Correct Ans : A"),
                trailing: AutoSizeText("Points : 20"),
              )
            ],
          )
        ],
      ),
    );
  }
}
