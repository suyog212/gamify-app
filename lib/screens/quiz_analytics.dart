import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/utils/widgets/analytics_table.dart';

class QuizAnalytics extends StatelessWidget {
  final List<dynamic> analyticsData;
  final String champName;
  final String startTime;
  final String categoryName;
  final String modeName;
  final int champId;
  final String? giftImage;
  final String giftType;
  final String? giftName;
  final String giftDescription;
  final String endTime;
  const QuizAnalytics(
      {super.key,
      required this.analyticsData,
      required this.champName,
      required this.startTime,
      required this.categoryName,
      required this.champId,
      this.giftImage,
      required this.giftType,
      this.giftName,
      required this.giftDescription,
      required this.modeName,
      required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      shrinkWrap: true,
      slivers: [
        const SliverAppBar(
          floating: true,
          snap: true,
          title: AutoSizeText("Leaderboard"),
        ),
        SliverToBoxAdapter(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              AutoSizeText(
                categoryName,
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary, fontSize: 23.sp),
              ),
              AutoSizeText(
                champName,
                style: TextStyle(fontSize: 18.sp),
              ),
              AutoSizeText(
                "Started : $startTime",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(
                color: Colors.transparent,
              ),
              AutoSizeText(
                "Leaderboard",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              FutureBuilder(
                future: API().sendRequests.get("/get_leaderboard.php?champ_id=$champId"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    List data = snapshot.data?.data['data'];
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 6).r,
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${index + 1}",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.values.reversed.elementAtOrNull(index) ?? FontWeight.w100,
                                          color: index <= 3 ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inverseSurface,
                                        ),
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(1, -10),
                                      child: Text(
                                        ordinal(index + 1),
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              fontSize: 10.sp,
                                              color: index <= 3 ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inverseSurface,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: AutoSizeText(
                              data.elementAt(index)['user_name'].split(" ").first,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: AutoSizeText(
                              "Score: ${double.parse(data.elementAt(index)['total_score']).toStringAsFixed(3)}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            trailing: AutoSizeText(
                              convertSecondsToMinutes(stringToSeconds(data.elementAt(index)['time_taken'])),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        },
                      ),
                    );
                    // return Container(
                    //   decoration: BoxDecoration(
                    //       border: Border.fromBorderSide(BorderSide(
                    //         color: Theme.of(context).colorScheme.secondary,
                    //       )),
                    //       borderRadius: BorderRadius.circular(5)),
                    //   child: Column(
                    //     children: [
                    //       // const SizedBox(
                    //       //   height: 8,
                    //       // ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    //         child: DefaultTextStyle(
                    //           style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               const SizedBox(width: 60, child: AutoSizeText("Rank")),
                    //               SizedBox(width: MediaQuery.sizeOf(context).width / 4, child: const AutoSizeText("Name")),
                    //               SizedBox(width: MediaQuery.sizeOf(context).width / 4, child: const AutoSizeText("Points")),
                    //               const AutoSizeText("Time")
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       MediaQuery.removePadding(
                    //         context: context,
                    //         removeTop: true,
                    //         child: ListView.builder(
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           shrinkWrap: true,
                    //           itemCount: data.length,
                    //           itemBuilder: (context, index) {
                    //             double leaderBoardTileWidth = MediaQuery.sizeOf(context).width / 4;
                    //             return Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                 children: [
                    //                   SizedBox(
                    //                     width: 60,
                    //                     child: AutoSizeText(
                    //                       "${index + 1}${ordinal(index + 1)}",
                    //                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    //                           fontWeight: FontWeight.values.reversed.elementAtOrNull(index) ?? FontWeight.w100,
                    //                           color: index <= 3 ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inverseSurface),
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     width: leaderBoardTileWidth,
                    //                     child: AutoSizeText(
                    //                       data.elementAt(index)['user_name'].split(" ").first,
                    //                       style: Theme.of(context).textTheme.titleMedium,
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     width: leaderBoardTileWidth,
                    //                     child: AutoSizeText(
                    //                       double.parse(data.elementAt(index)['total_score']).toStringAsFixed(3),
                    //                       style: Theme.of(context).textTheme.titleMedium,
                    //                     ),
                    //                   ),
                    //                   AutoSizeText(
                    //                     convertSecondsToMinutes(stringToSeconds(data.elementAt(index)['time_taken'])),
                    //                     style: Theme.of(context).textTheme.titleMedium,
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // );
                  }
                  return const SizedBox(
                    child: Center(
                      child: Text("Nobody qualified"),
                    ),
                  );
                },
              ),
              const Divider(
                color: Colors.transparent,
              ),
              AutoSizeText("Report Card", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              const Divider(
                color: Colors.transparent,
              ),
              AnalyticsTable(data: analyticsData),
              const Divider(
                color: Colors.transparent,
              ),
              if (modeName == "play_win_gift")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateTime.parse(endTime).isBefore(DateTime.now())
                        ? AutoSizeText("Reward you can win", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))
                        : AutoSizeText("Reward you can win", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 4.r,
                    ),
                    if (giftName!.isNotEmpty && giftName != null) AutoSizeText(giftName!),
                    if (giftImage != null && giftImage!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: giftImage!,
                          progressIndicatorBuilder: (context, url, progress) {
                            return CircularProgressIndicator(
                              value: progress.progress,
                            );
                          },
                        ),
                      ),
                    // Image(image: NetworkImage(giftImage!)),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    // if(giftType == "Coupon") Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1)
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       AutoSizeText("Redeem Code",style: Theme.of(context).textTheme.titleMedium,),
                    //       IconButton(onPressed: () {
                    //         Clipboard.setData(const ClipboardData(text: "Redeem Code"));
                    //       }, icon: const Icon(Icons.copy)),
                    //     ],
                    //   ),
                    // ),
                    // AutoSizeText("Details",style: Theme.of(context).textTheme.titleMedium,),
                    if (giftDescription.isNotEmpty) HtmlWidget(giftDescription),
                  ],
                ),
              const SizedBox(
                height: kToolbarHeight,
              )
            ],
          ),
        )
      ],
    ));
  }

  String ordinal(int number) {
    if (!(number >= 1 && number <= 100)) {
      //here you change the range
      throw Exception('Invalid number');
    }

    if (number >= 11 && number <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String convertSecondsToMinutes(int seconds) {
    int minutes = seconds ~/ 60; // Integer division to get whole minutes
    int remainingSeconds = seconds % 60; // Remainder for seconds

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
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
}

// class UserDataTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Example data provided
//     final data = {
//       "user_id": 5,
//       "user_name": "Suyog",
//       "email": "suyog.22220300@viit.ac.in",
//       "user_qualification": "Graduation",
//       "phone_no": "7249379181",
//       "first_login": "2024-09-05",
//       "recent_login": "2024-09-05",
//       "time_taken": "00:05:35",
//       "expected_time": "00:00:02",
//       "points": 10,
//       "correct_ans": 1,
//       "submitted_ans": 1,
//       "created_at": "2024-11-30 09:10:13",
//       "champ_id": 22,
//       "champ_name": "Master of Computing Championship",
//       "question_id": 115,
//       "question_text": "What does CPU stand for in computing?",
//       "option1_text": "Central Processing Unit",
//       "option2_text": "Computer Personal Unit",
//       "option3_text": "Central Power Unit",
//       "option4_text": "Computing Processing Unit",
//       "total_coins": 10,
//       "teacher_id": 85,
//       "teacher_name": "Prasad",
//       "label_id": 22,
//       "label_name": "Computing Fundamentals"
//     };
//
//     // Creating rows for the DataTable
//     List<DataRow> rows = data.entries
//         .map((entry) => DataRow(cells: [
//       DataCell(Text(entry.key)),
//       DataCell(Text(entry.value.toString())),
//     ]))
//         .toList();
//
//     return DataTable(
//       columns: const [
//         DataColumn(label: Text('Field', style: TextStyle(fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
//       ],
//       rows: rows,
//     );
//   }
// }

// ListView.builder(
// physics: const NeverScrollableScrollPhysics(),
// shrinkWrap: true,
// itemCount: analyticsData.length,
// itemBuilder: (context, index) {
// final data = analyticsData.elementAt(index);
// List<String?> answers = [data.option1Text,data.option2Text,data.option3Text,data.option4Text];
// return ListTile(
// // contentPadding: EdgeInsets.zero,
// leading: AutoSizeText("Q${index +1}",style: Theme.of(context).textTheme.titleLarge,),
// title: AutoSizeText("Ans : ${data.submittedAns} (${answers[data.submittedAns! - 1]?.trim()})"),
// subtitle: AutoSizeText("Points : ${data.points}"),
// // trailing: time_ago.format(DateTime.parse(data.)),
// trailing: AutoSizeText(stringToSeconds(data.timeTaken!).toString()),
// );
// },)
