import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kGamify/api/api.dart';
import 'package:kGamify/blocs/question_bloc.dart';
import 'package:kGamify/models/championship_details_model.dart';
import 'package:kGamify/repositories/championship_repository.dart';
import 'package:kGamify/screens/question_view.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/widgets/widgets.dart';
import 'package:validator_regex/validator_regex.dart';

class ChampionshipInformationCard extends StatefulWidget {
  final String startDate;
  final String endDate;
  final int heroIndex;
  final String startTime;
  final String endTime;
  final String champId;
  final String champStatus;
  final String categoryStatus;
  final String categoryId;
  final String champName;
  final String categoryName;
  final String modeName;
  final String uploadImg;
  final int modeId;
  final int timeMinutes;
  final int noOfQuestions;
  final int noOfUsers;
  final int teacherId;
  final String? giftImage;
  final TeacherDetailsModel teacherDetailsModel;
  final String? gameModeRules;
  final String? userQualification;
  final String? giftDescription;
  final String? noOfUserPlayed;
  final String? questionCount;
  final String uniqueId;
  const ChampionshipInformationCard(
      {super.key,
      required this.startDate,
      required this.modeId,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      required this.champId,
      required this.categoryId,
      required this.champName,
      required this.categoryName,
      required this.modeName,
      required this.timeMinutes,
      required this.noOfQuestions,
      required this.noOfUsers,
      required this.teacherId,
      required this.teacherDetailsModel,
      required this.champStatus,
      required this.categoryStatus,
      required this.heroIndex,
      required this.uploadImg,
      this.giftImage,
      this.gameModeRules,
      this.userQualification,
      this.giftDescription,
      this.noOfUserPlayed,
      this.questionCount,
      required this.uniqueId});

  @override
  State<ChampionshipInformationCard> createState() => _ChampionshipInformationCardState();
}

class _ChampionshipInformationCardState extends State<ChampionshipInformationCard> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact(locale: Platform.localeName, explicitSign: false);
    final formattedStartDate = DateTime.parse("${widget.startDate} ${widget.startTime}");
    final formattedEndDate = DateTime.parse("${widget.endDate} ${widget.endTime}");
    final start = DateFormat("MMMM d h:mm a").format(DateTime.parse("${widget.startDate} ${widget.startTime}"));
    final end = DateFormat("MMMM d h:mm a").format(DateTime.parse("${widget.endDate} ${widget.endTime}"));
    Map<String, String> gameModes = {"play_win_gift": "Play and Win", "quick_hit": "Quick Hit"};
    return BlocListener<QuestionsBloc, QuestionsState>(
      listener: (context, state) {
        if (state is QuestionErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
        }
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          mixpanel!.track("ChampionshipInitiated", properties: {
            "UserId": Hive.box(userDataDB).get("personalInfo")['user_id'],
            "TimeStamp": DateTime.now().toString(),
            "ChampionshipId": widget.champId,
            "CategoryId": widget.categoryId,
            "ModeId": widget.modeId,
            "TeacherId": widget.teacherId,
            "NoOfQuestions": widget.noOfQuestions,
            "UserQualification": widget.userQualification ?? "",
          });
          // else {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(16).r,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // child: ,
                    // title: Text(widget.categoryName),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      type: MaterialType.card,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                          // heightFactor: 0.6,
                          child: Scrollbar(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rules",
                                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                                    ),
                                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))
                                  ],
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      HtmlWidget(
                                        widget.gameModeRules!,
                                        enableCaching: true,
                                      ),
                                      const Divider(
                                        color: Colors.transparent,
                                      ),
                                      if (widget.modeName == "play_win_gift")
                                        // if (false)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AutoSizeText(
                                              "Reward",
                                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 6.r,
                                            ),
                                            if ((widget.giftImage != null && widget.giftImage!.isNotEmpty) &&
                                                Uri.tryParse(widget.giftImage ?? "") != null &&
                                                Uri.tryParse(widget.giftImage ?? "")!.isAbsolute)
                                              Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget.giftImage!,
                                                      progressIndicatorBuilder: (context, url, progress) {
                                                        return CircularProgressIndicator(
                                                          value: progress.progress,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6.r,
                                                  ),
                                                ],
                                              ),
                                            HtmlWidget(
                                              widget.giftDescription ?? "",
                                              textStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                                            )
                                          ],
                                        ),
                                      const Divider(
                                        color: Colors.transparent,
                                      ),
                                    ],
                                  )),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          // if (DateTime.parse(formattedEndDate.toString()).isBefore(DateTime.now())) {
                                          //   return Row(
                                          //     mainAxisAlignment:MainAxisAlignment.end,
                                          //     children: [
                                          //       Expanded(
                                          //         child: FilledButton(
                                          //             onPressed: () async {
                                          //               showDialog(
                                          //                 barrierDismissible: false,
                                          //                 context: context,
                                          //                 builder: (BuildContext context) {
                                          //                   return AlertDialog(
                                          //                     backgroundColor: Colors.transparent,
                                          //                     shape: RoundedRectangleBorder(
                                          //                         borderRadius:
                                          //                         BorderRadius.circular(10)),
                                          //                     content: Column(
                                          //                       mainAxisSize: MainAxisSize.min,
                                          //                       crossAxisAlignment:
                                          //                       CrossAxisAlignment.center,
                                          //                       children: [
                                          //                         const CircularProgressIndicator(),
                                          //                         const Divider(
                                          //                           color: Colors.transparent,
                                          //                         ),
                                          //                         Text(
                                          //                           "Loading...",
                                          //                           style: Theme.of(context)
                                          //                               .textTheme
                                          //                               .titleMedium,
                                          //                         ),
                                          //                       ],
                                          //                     ),
                                          //                   );
                                          //                 },
                                          //               );
                                          //               try{
                                          //                 List<dynamic> data =
                                          //                 await ChampionshipAnalyticsRepository()
                                          //                     .getQuestionAnalytics(
                                          //                     int.parse(widget.champId));
                                          //                 if (!context.mounted) return;
                                          //                 Navigator.pop(context);
                                          //                 context.push(
                                          //                     "/landingPage/quizAnalytics",
                                          //                     extra: {
                                          //                       "data": data,
                                          //                       "category_name": widget.categoryName,
                                          //                       "champ_name": widget.champName,
                                          //                       "start_time": formattedStartDate.toString(),
                                          //                       'champ_id': int.parse(widget.champId),
                                          //                       'gift_description':
                                          //                       widget.giftDescription ?? "",
                                          //                       'gift_type': "",
                                          //                       'gift_image': widget.giftImage ?? "",
                                          //                       'gift_name': "",
                                          //                       'mode_name' : widget.modeName
                                          //                     });
                                          //               } catch (e){
                                          //                 snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Something went wrong.")));
                                          //                 context.pop();
                                          //               }
                                          //             },
                                          //             child: const AutoSizeText(
                                          //                 "View analytics")),
                                          //       ),
                                          //     ],
                                          //   );
                                          // }
                                          // if (DateTime.parse(formattedEndDate.toString()).isBefore(DateTime.now())) {
                                          //   return const Row(
                                          //     // mainAxisAlignment: MainAxisAlignment.end,
                                          //     children: [
                                          //       Expanded(
                                          //           child: FilledButton(
                                          //               onPressed: null,
                                          //               child: AutoSizeText(
                                          //                   "Yet to start",
                                          //               ),
                                          //           ),
                                          //       ),
                                          //     ],
                                          //   );
                                          // }
                                          return FutureBuilder(
                                            future: ChampionshipRepository().fetchChampDetails(int.parse(widget.champId)),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const Center(
                                                  child: CircularProgressIndicator.adaptive(),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.first.champStatus == "1" && snapshot.data!.first.categoryStatus == "1") {
                                                  return FutureBuilder(
                                                    future: API().sendRequests.get("/check_user_played.php?user_id=${Hive.box(userDataDB).get("personalInfo")['user_id']}&champ_id=${widget.champId}"),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      }
                                                      if (snapshot.hasError &&
                                                          DateTime.parse(formattedStartDate.toString()).isBefore(DateTime.now()) &&
                                                          DateTime.parse(formattedEndDate.toString()).isAfter(DateTime.now())) {
                                                        return FilledButton(
                                                            onPressed: () async {
                                                              var userId = Hive.box(userDataDB).get("personalInfo")['user_id'];
                                                              context.read<QuestionsBloc>().getQuestions(
                                                                  widget.modeId,
                                                                  widget.champName,
                                                                  widget.timeMinutes,
                                                                  widget.noOfQuestions,
                                                                  widget.modeName,
                                                                  widget.champId,
                                                                  widget.timeMinutes,
                                                                  userId,
                                                                  context,
                                                                  widget.teacherDetailsModel.teacherName ?? "",
                                                                  widget.teacherId,
                                                                  widget.categoryId);
                                                            },
                                                            child: const Text("Play"));
                                                      }
                                                      if (snapshot.hasData || DateTime.parse(formattedEndDate.toString()).isAfter(DateTime.now())) {
                                                        return navigateToChampAnalytics(context, widget.champId, widget.modeId.toString());
                                                      }
                                                      return const FilledButton(onPressed: null, child: Text("Ended"));
                                                    },
                                                  );
                                                }
                                                return const Text("Not Available");
                                              }
                                              return const FilledButton(onPressed: null, child: Text("Not available"));
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0).r,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: const Border.fromBorderSide(BorderSide(color: Colors.orange, width: 1.5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    gameModes[widget.modeName] ?? "",
                    style: const TextStyle(color: Colors.red),
                  ),
                  AutoSizeText(
                    "ID: ${widget.uniqueId}",
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return Dialog(
                  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //           insetPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.07),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(12.0),
                  //             child: Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               crossAxisAlignment: CrossAxisAlignment.stretch,
                  //               children: [
                  //                 const Text("About Championship"),
                  //                 const Divider(
                  //                   color: Colors.transparent,
                  //                 ),
                  //                 const AutoSizeText(
                  //                     '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'''),
                  //                 const Divider(
                  //                   color: Colors.transparent,
                  //                 ),
                  //                 FilledButton(
                  //                   onPressed: () {
                  //                     // Navigator.push(
                  //                     //     context,
                  //                     //     CupertinoPageRoute(
                  //                     //       builder: (context) => const Question(questionsList: []),
                  //                     //     ));
                  //                     // Navigator.pop(context)
                  //                   },
                  //                   child: const Text("Ok"),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //     if (kDebugMode) {
                  //       print("Opened Info");
                  //     }
                  //   },
                  //   child: const Icon(Icons.info_outline_rounded),
                  // )
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  widget.champName,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).animate().slideX(),
                subtitle: Text(
                  widget.categoryName,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w200),
                ).animate().slideY(),
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
              // Text("Id: ${widget.uniqueId}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(
                    "${widget.noOfQuestions} Questions | ${formatChampionshipTime(quizSubmissionTime(widget.timeMinutes))}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
                  ),
                  // Icon(Icons.auto_graph),
                  // Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.person),
                      Text(
                        formatter.format(int.parse(widget.noOfUserPlayed ?? "0")),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OverflowBar(
                          children: [
                            const Icon(Icons.school_outlined),
                            const VerticalDivider(),
                            AutoSizeText(
                              widget.userQualification ?? "",
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        Wrap(
                          spacing: 4.r,
                          runSpacing: 4.r,
                          children: [
                            
                          ]
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        OverflowBar(
                          children: [
                            const Icon(Icons.calendar_month),
                            const VerticalDivider(),
                            OverflowBar(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [AutoSizeText("Starts : "), AutoSizeText("Ends   : ")],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [AutoSizeText(start), AutoSizeText(end)],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            // barrierColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.4),
                            barrierDismissible: true,
                            fullscreenDialog: true,
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  "Teacher Details",
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                ),
                                                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                                              ],
                                            ),
                                            Hero(
                                              tag: "${widget.teacherDetailsModel.teacherName}${widget.champId}${widget.modeName}",
                                              child: CircleAvatar(
                                                backgroundImage: CachedNetworkImageProvider(
                                                  widget.uploadImg == "" ? "https://i.pinimg.com/736x/c0/27/be/c027bec07c2dc08b9df60921dfd539bd.jpg" : widget.uploadImg,
                                                ),
                                                radius: MediaQuery.sizeOf(context).width * 0.14,
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    AutoSizeText(
                                                      widget.teacherDetailsModel.teacherName!,
                                                      style: Theme.of(context).textTheme.titleLarge,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Visibility(
                                                      visible: widget.teacherDetailsModel.status == "1",
                                                      child: Icon(
                                                        Icons.verified,
                                                        color: Theme.of(context).colorScheme.secondary,
                                                        size: Theme.of(context).textTheme.titleMedium!.fontSize,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.transparent,
                                                ),
                                                DecoratedBox(
                                                  decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          // mainAxisAlignment : MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                                child: Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                AutoSizeText(
                                                                  "Department",
                                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                                ),
                                                                AutoSizeText(
                                                                  "${widget.teacherDetailsModel.department}",
                                                                  style: Theme.of(context).textTheme.titleMedium,
                                                                  maxLines: 2,
                                                                )
                                                              ],
                                                            )),
                                                            const VerticalDivider(),
                                                            Expanded(
                                                                child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                AutoSizeText(
                                                                  "Institute",
                                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                                ),
                                                                AutoSizeText(
                                                                  "${widget.teacherDetailsModel.institute}",
                                                                  style: Theme.of(context).textTheme.titleMedium,
                                                                )
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                        const Divider(
                                                          color: Colors.transparent,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                AutoSizeText(
                                                                  "Championships Created",
                                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                                ),
                                                                AutoSizeText(
                                                                  widget.teacherDetailsModel.champsCreated ?? "0",
                                                                  style: Theme.of(context).textTheme.titleMedium,
                                                                )
                                                              ],
                                                            )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ));
                    },
                    child: Hero(
                      tag: "${widget.teacherDetailsModel.teacherName}${widget.champId}${widget.modeName}",
                      child: CircleAvatar(
                        backgroundImage: Validator.url(widget.uploadImg)
                            ? CachedNetworkImageProvider(
                                widget.uploadImg,
                              )
                            : null,
                        // NetworkImage(
                        //     widget.uploadImg == "" ?
                        //     "https://i.pinimg.com/736x/c0/27/be/c027bec07c2dc08b9df60921dfd539bd.jpg" : widget.uploadImg),
                        backgroundColor: Colors.orange,
                        radius: 24,
                      ),
                    ),
                  ),
                ],
              ),
              // Text(widget.modeId.toString())
            ],
          ),
        ),
      ),
    );
  }
}
