import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kGamify/utils/quiz_utils/championship_score_engine.dart';

class AnalyticsTable extends StatefulWidget {
  final List<dynamic> data;
  const AnalyticsTable({super.key, required this.data});

  @override
  State<AnalyticsTable> createState() => _AnalyticsTableState();
}

class _AnalyticsTableState extends State<AnalyticsTable> {
  List<String> columns = ['Q.No', 'Total Points', 'Bonus/Penalty', 'Points', 'Actual Time', 'Expected Time'];
  @override
  Widget build(BuildContext context) {
    // int totalScore = widget.data.forEach((element) => element['total_coins'],);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.data.isEmpty) {
          return const Center(
            child: AutoSizeText("No data found."),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Theme.of(context).colorScheme.secondary)), borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      // ignore: prefer_const_constructors
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                  child: Row(
                    children: [
                      ...columns.map(
                        (e) {
                          return SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.19,
                            child: AutoSizeText(
                              e,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                ...List.generate(
                  widget.data.length,
                  (index) {
                    // Color textColor = Theme.of(context).colorScheme.inverseSurface;
                    double score = ChampionshipScoreEngine().calculateScoreForCorrectAnswer(
                        stringToSeconds(widget.data.elementAt(index)['expected_time']),
                        stringToSeconds(widget.data.elementAt(index)['time_taken']),
                        double.parse(widget.data.elementAt(index)['total_coins'].toString()),
                        widget.data.elementAt(index)['correct_ans'] == widget.data.elementAt(index)['submitted_ans'],
                        widget.data.elementAt(index)['total_coins'] * -1);
                    double bonus = score - widget.data.elementAt(index)['total_coins'];
                    double tileWidth = MediaQuery.sizeOf(context).width * 0.19;
                    return DefaultTextStyle(
                      style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: tileWidth,
                              child: AutoSizeText("Q ${index + 1}"),
                            ),
                            SizedBox(
                              width: tileWidth,
                              child: AutoSizeText(double.parse(widget.data.elementAt(index)['points'].toString()).toStringAsFixed(3)),
                            ),
                            SizedBox(
                              width: tileWidth,
                              child: AutoSizeText(bonus.toStringAsFixed(2)),
                            ),
                            SizedBox(
                              width: tileWidth,
                              child: AutoSizeText("${widget.data.elementAt(index)['total_coins']}"),
                            ),
                            SizedBox(
                              width: tileWidth,
                              child: AutoSizeText("${stringToSeconds(widget.data.elementAt(index)['time_taken'])}sec"),
                            ),
                            SizedBox(
                              width: tileWidth,
                              child: AutoSizeText("${stringToSeconds(widget.data.elementAt(index)['expected_time'])}sec"),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium?.fontSize, color: Theme.of(context).colorScheme.inverseSurface, fontWeight: FontWeight.bold),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.19,
                          child: const AutoSizeText("Total"),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.19,
                          child: AutoSizeText(calculateTotal(List<Map<String, dynamic>>.from(widget.data), 'points').toStringAsFixed(3)),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.19,
                          child: AutoSizeText(calculateTotalBonus(List<Map<String, dynamic>>.from(widget.data)).toStringAsFixed(3)),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.19,
                          child: AutoSizeText(calculateTotal(List<Map<String, dynamic>>.from(widget.data), 'total_coins').toStringAsFixed(2)),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.19,
                          child: AutoSizeText("${calculateTotalSeconds(List<Map<String, dynamic>>.from(widget.data), 'time_taken')}sec"),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.19,
                          child: AutoSizeText("${calculateTotalSeconds(List<Map<String, dynamic>>.from(widget.data), 'expected_time')}sec"),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  int stringToSeconds(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Calculate the total seconds.
    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;

    return totalSeconds;
  }

  int stringToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Calculate the total seconds.
    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;

    return totalSeconds ~/ 60;
  }

  double calculateTotal(List<Map<String, dynamic>> data, String key) {
    double res = 0;
    // Iterate through each entry and sum the points
    for (var entry in data) {
      res += double.parse(entry[key].toString());
    }
    return res;
  }

  int calculateTotalSeconds(List<Map<String, dynamic>> data, String key) {
    int res = 0;
    // Iterate through each entry and sum the points
    for (var entry in data) {
      res += stringToSeconds(entry[key]);
    }
    return res;
  }

  double calculateTotalBonus(List<Map<String, dynamic>> data) {
    double res = 0;
    // Iterate through each entry and sum the points
    for (var entry in data) {
      res += ChampionshipScoreEngine().calculateScoreForCorrectAnswer(stringToSeconds(entry['expected_time']), stringToSeconds(entry['time_taken']), double.parse(entry['total_coins'].toString()),
              entry['correct_ans'] == entry['submitted_ans'], entry['total_coins'] * -1) -
          entry['total_coins'];
    }
    return res;
    // double score = ChampionshipScoreEngine()
    //     .calculateScoreForCorrectAnswer(
    //     stringToSeconds(
    //         widget
    //             .data
    //             .elementAt(index)['expected_time']),
    //     stringToSeconds(
    //         widget.data.elementAt(index)['time_taken']),
    //     double.parse(widget.data
    //         .elementAt(index)['total_coins']
    //         .toString()),
    //     widget.data.elementAt(index)['correct_ans'] ==
    //         widget.data.elementAt(index)['submitted_ans'],
    //     widget.data.elementAt(index)['total_coins'] * -1);
    // double bonus =
    //     score - widget.data.elementAt(index)['total_coins'];
  }
}
