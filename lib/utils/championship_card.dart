import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/blocs/question_bloc.dart';
import 'package:gamify_test/models/championship_details_model.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ChampionshipInformationCard extends StatefulWidget {
  final String startDate;
  final String endDate;
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
  final TeacherDetailsModel teacherDetailsModel;
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
      required this.uploadImg});

  @override
  State<ChampionshipInformationCard> createState() =>
      _ChampionshipInformationCardState();
}

class _ChampionshipInformationCardState
    extends State<ChampionshipInformationCard> {
  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.compact(locale: "en_US", explicitSign: false);
    final formattedStartDate =
        DateTime.parse("${widget.startDate} ${widget.startTime}");
    final formattedEndDate =
        DateTime.parse("${widget.endDate} ${widget.endTime}");
    final start = DateFormat("MMM E d h:mm a")
        .format(DateTime.parse("${widget.startDate} ${widget.startTime}"));
    final end = DateFormat("MMM E d h:mm a")
        .format(DateTime.parse("${widget.endDate} ${widget.endTime}"));
    Map<String, String> gameModes = {
      "play_win_gift": "Play and Win",
      "quick_hit": "Quick Hit"
    };
    return BlocListener<QuestionsBloc, QuestionsState>(
      listener: (context, state) {
        if (state is QuestionErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.toString())));
        }
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          //TODO : Remove print statements from this function
          // if (int.parse(widget.champStatus) == 1 &&
          //     int.parse(widget.categoryStatus) == 1) {
          //   if (DateTime.parse(formattedStartDate.toString())
          //       .isAfter(DateTime.now())) {
          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //         content: Text("The championship hasn't started yet")));
          //   }
          //   if (DateTime.parse(formattedEndDate.toString())
          //       .isBefore(DateTime.now())) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text("The championship ended on $end")));
          //   } else {
          showDialog(
            context: context,
            builder: (context) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                width: MediaQuery.sizeOf(context).width,
                child: AlertDialog(
                  title: Text(widget.categoryName),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText.rich(
                        TextSpan(
                          text: "Rules\n",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(text: '''
1. All questions are compulsory
2. Navigating through questions is not allowed.
3. Can be played only once. Ensure you have stable internet connection
                            ''', style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      if (widget.modeName == "play_win_gift")
                      // if (false)
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoSizeText("Prizes you can win"),
                            FlutterLogo()
                          ],
                        )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  actionsOverflowAlignment: OverflowBarAlignment.center,
                  actions: [
                    FilledButton(
                        onPressed: () {
                          var userId = Hive.box(userDataDB)
                              .get("personalInfo")['user_id'];
                          context.read<QuestionsBloc>().getQuestions(
                              widget.modeId,
                              widget.categoryName,
                              widget.timeMinutes,
                              widget.noOfQuestions,
                              widget.modeName,
                              widget.champId,
                              widget.timeMinutes * 60,
                              userId,
                              context,
                              widget.teacherDetailsModel.teacherName ?? "");
                        },
                        child: const Text("Play"))
                  ],
                ),
              );
            },
          );
          //   }
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //       content: Text(
          //           "Championship is inactive try contacting the owner.")));
          // }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: const Border.fromBorderSide(
                  BorderSide(color: Colors.orange, width: 1.5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    gameModes[widget.modeName] ?? "",
                    style: const TextStyle(color: Colors.red),
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
                  widget.categoryName,
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().slideX(),
                subtitle: Text(widget.champName).animate().slideY(),
                trailing: LayoutBuilder(
                  builder: (context, constraints) {
                    if (DateTime.parse(formattedStartDate.toString())
                        .isAfter(DateTime.now())) {
                      return Container(
                        decoration: BoxDecoration(
                            border: const Border.fromBorderSide(
                                BorderSide(color: Colors.grey)),
                            borderRadius: BorderRadius.circular(5)),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    } else if (DateTime.parse(formattedEndDate.toString())
                        .isBefore(DateTime.now())) {
                      return Container(
                        decoration: BoxDecoration(
                            border: const Border.fromBorderSide(
                                BorderSide(color: Colors.redAccent)),
                            borderRadius: BorderRadius.circular(5)),
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
                                  color: Colors.redAccent, fontSize: 14),
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
                            style: TextStyle(color: Colors.green, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(
                    "${widget.noOfQuestions} Questions | ${widget.timeMinutes} mins",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize),
                  ),
                  // Icon(Icons.auto_graph),
                  // Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.person),
                      Text(
                        formatter.format(5000),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.normal),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OverflowBar(
                        children: [
                          Icon(Icons.school_outlined),
                          VerticalDivider(),
                          AutoSizeText("B.Tech")
                        ],
                      ),
                      const Divider(
                        height: 2,
                      ),
                      OverflowBar(
                        children: [
                          const Icon(Icons.calendar_month),
                          const VerticalDivider(),
                          OverflowBar(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Starts : "),
                                  Text("Ends   : ")
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text(start), Text(end)],
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            opaque: false,
                            barrierColor: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.4),
                            barrierDismissible: true,
                            fullscreenDialog: true,
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText(
                                                "Teacher Details",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: const Icon(Icons.close))
                                            ],
                                          ),
                                          Hero(
                                            tag:
                                                "teacherPfp${widget.teacherId}",
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                widget.uploadImg == ""
                                                    ? "https://i.pinimg.com/736x/c0/27/be/c027bec07c2dc08b9df60921dfd539bd.jpg"
                                                    : widget.uploadImg,
                                              ),
                                              radius: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.12,
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.transparent,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    widget.teacherDetailsModel
                                                        .teacherName!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  Visibility(
                                                    visible: widget
                                                            .teacherDetailsModel
                                                            .status ==
                                                        "1",
                                                    child: Icon(
                                                      Icons.verified_outlined,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      size: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .fontSize,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const Divider(
                                                color: Colors.transparent,
                                              ),
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AutoSizeText(
                                                                "Department",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ),
                                                              AutoSizeText(
                                                                "${widget.teacherDetailsModel.department}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall,
                                                              )
                                                            ],
                                                          )),
                                                          const VerticalDivider(),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AutoSizeText(
                                                                "Institute",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ),
                                                              AutoSizeText(
                                                                "${widget.teacherDetailsModel.institute}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall,
                                                              )
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AutoSizeText(
                                                                "Championships Created",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ),
                                                              AutoSizeText(
                                                                "12",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headlineSmall,
                                                              )
                                                            ],
                                                          ))
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
                                          FilledButton(
                                              style: FilledButton.styleFrom(
                                                  fixedSize: Size.fromWidth(
                                                      MediaQuery.sizeOf(context)
                                                          .width)),
                                              onPressed: () {
                                                // Navigator.push(context, CupertinoPageRoute(builder: (context) => TeacherProfile(
                                                //   teacherId: widget.teacherDetailsModel.teacherId,
                                                //   createdAt: widget.teacherDetailsModel.createdAt,
                                                //   department: widget.teacherDetailsModel.department,
                                                //   email: widget.teacherDetailsModel.email,
                                                //   institute: widget.teacherDetailsModel.institute,
                                                //   phone: widget.teacherDetailsModel.phone,
                                                //   status: widget.teacherDetailsModel.status,
                                                //   teacherName: widget.teacherDetailsModel.teacherName,
                                                //   username: widget.teacherDetailsModel.username,
                                                //   uploadImg: widget.teacherDetailsModel.uploadImg,
                                                //   verifyToken: null,
                                                // )));
                                              },
                                              child: const Text("View profile"))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ));
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return Dialog(
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      //       insetPadding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.07),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 AutoSizeText(
                      //                   "Teacher Details",
                      //                   style: Theme.of(context).textTheme.titleLarge,
                      //                 ),
                      //                 IconButton(
                      //                     onPressed: () => Navigator.pop(context),
                      //                     icon: const Icon(Icons.close))
                      //               ],
                      //             ),
                      //             CircleAvatar(
                      //               backgroundImage: CachedNetworkImageProvider(
                      //                 widget.uploadImg == ""
                      //                     ? "https://i.pinimg.com/736x/c0/27/be/c027bec07c2dc08b9df60921dfd539bd.jpg"
                      //                     : widget.uploadImg,
                      //               ),
                      //               radius: MediaQuery.sizeOf(context).width * 0.12,
                      //             ),
                      //             const Divider(
                      //               color: Colors.transparent,
                      //             ),
                      //             Column(
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               children: [
                      //                 Row(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: [
                      //                     AutoSizeText(
                      //                       widget.teacherDetailsModel.teacherName!,
                      //                       style: Theme.of(context).textTheme.titleLarge,
                      //                     ),
                      //                     Visibility(
                      //                       visible: widget.teacherDetailsModel.status == "1",
                      //                       child: Icon(
                      //                         Icons.verified_outlined,
                      //                         color: Theme.of(context).colorScheme.secondary,
                      //                         size: Theme.of(context).textTheme.titleLarge!.fontSize,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 const Divider(
                      //                   color: Colors.transparent,
                      //                 ),
                      //                 DecoratedBox(
                      //                   decoration: BoxDecoration(
                      //                       color: Colors.grey.withOpacity(0.1),
                      //                       borderRadius: BorderRadius.circular(10)),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: Column(
                      //                       mainAxisSize: MainAxisSize.min,
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Expanded(
                      //                                 child: Column(
                      //                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                               children: [
                      //                                 AutoSizeText(
                      //                                   "Department",
                      //                                   style: Theme.of(context).textTheme.titleMedium,
                      //                                 ),
                      //                                 AutoSizeText(
                      //                                   "${widget.teacherDetailsModel.department}",
                      //                                   style: Theme.of(context).textTheme.headlineSmall,
                      //                                 )
                      //                               ],
                      //                             )),
                      //                             const VerticalDivider(),
                      //                             Expanded(
                      //                                 child: Column(
                      //                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                               children: [
                      //                                 AutoSizeText(
                      //                                   "Institute",
                      //                                   style: Theme.of(context).textTheme.titleMedium,
                      //                                 ),
                      //                                 AutoSizeText(
                      //                                   "${widget.teacherDetailsModel.institute}",
                      //                                   style: Theme.of(context).textTheme.headlineSmall,
                      //                                 )
                      //                               ],
                      //                             ))
                      //                           ],
                      //                         ),
                      //                         Row(
                      //                           children: [
                      //                             Expanded(
                      //                                 child: Column(
                      //                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                               children: [
                      //                                 AutoSizeText(
                      //                                   "Championships Created",
                      //                                   style: Theme.of(context).textTheme.titleMedium,
                      //                                 ),
                      //                                 AutoSizeText(
                      //                                   "12",
                      //                                   style: Theme.of(context).textTheme.headlineSmall,
                      //                                 )
                      //                               ],
                      //                             ))
                      //                           ],
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const Divider(
                      //               color: Colors.transparent,
                      //             ),
                      //             FilledButton(
                      //                 style: FilledButton.styleFrom(
                      //                     fixedSize:
                      //                         Size.fromWidth(MediaQuery.sizeOf(context).width)),
                      //                 onPressed: () {
                      //                   Navigator.push(context, CupertinoPageRoute(builder: (context) => TeacherProfile(
                      //                     teacherId: widget.teacherDetailsModel.teacherId,
                      //                     createdAt: widget.teacherDetailsModel.createdAt,
                      //                     department: widget.teacherDetailsModel.department,
                      //                     email: widget.teacherDetailsModel.email,
                      //                     institute: widget.teacherDetailsModel.institute,
                      //                     phone: widget.teacherDetailsModel.phone,
                      //                     status: widget.teacherDetailsModel.status,
                      //                     teacherName: widget.teacherDetailsModel.teacherName,
                      //                     username: widget.teacherDetailsModel.username,
                      //                     uploadImg: widget.teacherDetailsModel.uploadImg,
                      //                     verifyToken: null,
                      //                   )));
                      //                 },
                      //                 child: const Text("View profile"))
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                    child: Hero(
                      tag: "teacherPfp${widget.teacherId}",
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          widget.uploadImg == ""
                              ? "https://i.pinimg.com/736x/c0/27/be/c027bec07c2dc08b9df60921dfd539bd.jpg"
                              : widget.uploadImg,
                        ),
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
