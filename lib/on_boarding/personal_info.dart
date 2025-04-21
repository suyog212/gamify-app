import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/on_boarding/utils/auth_handler.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/router.dart';
import 'package:kGamify/utils/widgets/widgets.dart';

class PersonalInfoInput extends StatefulWidget {
  const PersonalInfoInput({super.key});

  @override
  State<PersonalInfoInput> createState() => _PersonalInfoInputState();
}

class _PersonalInfoInputState extends State<PersonalInfoInput> {
  final TextEditingController _name = TextEditingController(text: Hive.box(userDataDB).get("personalInfo")['name']);
  final TextEditingController _email = TextEditingController(text: Hive.box(userDataDB).get("personalInfo")['email']);
  final TextEditingController _age = TextEditingController(text: Hive.box(userDataDB).get("personalInfo")['age']);
  final TextEditingController _phone = TextEditingController(text: Hive.box(userDataDB).get("personalInfo")['phone_no']);
  final formKey = GlobalKey<FormState>();
  final TextEditingController schoolName = TextEditingController(text: "");
  final TextEditingController board = TextEditingController(text: "");
  final TextEditingController percentage = TextEditingController(text: "");
  final TextEditingController passingYear = TextEditingController(text: "");
  String? country = Hive.box(userDataDB).get("personalInfo", defaultValue: {"country": null})["country"];
  String? state = Hive.box(userDataDB).get("personalInfo", defaultValue: {"state": null})["state"];
  String? city = Hive.box(userDataDB).get("personalInfo", defaultValue: {"city": null})["city"];

  List<String> qualifications = ["School", "High School", "Diploma", "Graduation", "Post Graduation", "Ph.D"];
  String qualification = "School";
  bool pursuing = false;

  List<String> interests = ["Video games", "Traveling", "Music", "Puzzles", "Movies", "Books", "Writing", "Fitness", "Art", "Programming"];

  Map<String, IconData> interestsIcons = {
    "Video games": CupertinoIcons.game_controller,
    "Traveling": Icons.directions_bus,
    "Music": Icons.music_note,
    "Puzzles": Icons.auto_awesome_mosaic_rounded,
    "Movies": Icons.tv,
    "Books": Icons.book,
    "Writing": CupertinoIcons.pen,
    "Fitness": Icons.sports_gymnastics,
    "Art": Icons.brush,
    "Programming": Icons.code
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _age.dispose();
    schoolName.dispose();
    board.dispose();
    percentage.dispose();
    passingYear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppRouter().router?.state!.fullPath == "/landingPage/profile/personalInfoEdit" ? AppBar() : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: AppRouter().router?.state!.fullPath != "/landingPage/profile/personalInfoEdit"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [TextButton(onPressed: () => context.go("/landingPage"), child: const Text("Skip"))],
                    )
                  : null,
            ),
            Text(
              "Personal Info",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            AppTextField(
              hintText: "Name",
              controller: _name,
              keyBoardType: TextInputType.name,
              label: "Name",
              isEnabled: AppRouter().router?.state!.fullPath == "/landingPage/profile/personalInfoEdit",
            ),
            const Divider(
              color: Colors.transparent,
            ),
            AppTextField(
              hintText: "Email",
              controller: _email,
              keyBoardType: TextInputType.emailAddress,
              label: "Email",
              isEnabled: false,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            AppTextField(
              hintText: "Phone Number",
              controller: _phone,
              keyBoardType: TextInputType.number,
              label: "Phone Number",
              isEnabled: false,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            AutoSizeText(
              "Address",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            RepaintBoundary(
              child: CSCPicker(
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: const Border.fromBorderSide(BorderSide(color: Colors.black)),
                ),
                currentCountry: country,
                currentCity: city,
                currentState: state,
                disabledDropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.7)),
                defaultCountry: CscCountry.India,
                flagState: CountryFlag.DISABLE,
                onCityChanged: (value) {
                  setState(() {
                    city = value;
                  });
                },
                onCountryChanged: (value) {
                  setState(() {
                    country = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    state = value;
                  });
                },
              ),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            AutoSizeText(
              "Interests",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box(userDataDB).listenable(),
              builder: (context, value, child) {
                return Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: List.generate(
                      interests.length,
                      (index) {
                        List<String> curr = Hive.box(userDataDB).get("interests", defaultValue: <String>[]);
                        return ChoiceChip.elevated(
                          showCheckmark: false,
                          avatar: Icon(interestsIcons[interests.elementAt(index)]),
                          label: Text(interests.elementAt(index)),
                          selected: curr.contains(interests.elementAt(index)),
                          // backgroundColor: Colors.grey.withOpacity(0.3),
                          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                          onSelected: (value) {
                            if (value) {
                              curr.add(interests.elementAt(index));
                              curr = curr.toSet().toList();
                              Hive.box(userDataDB).put("interests", curr);
                            } else {
                              curr.remove(interests.elementAt(index));
                              curr = curr.toSet().toList();
                              Hive.box(userDataDB).put("interests", curr);
                            }
                          },
                        );
                      },
                    ));
              },
            ),
            const Divider(
              color: Colors.transparent,
            ),
            SizedBox(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText("Qualifications", style: Theme.of(context).textTheme.titleLarge),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: false,
                              sheetAnimationStyle: AnimationStyle(curve: Curves.easeInOut),
                              context: context,
                              enableDrag: false,
                              builder: (context) {
                                return Material(
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Form(
                                            key: formKey,
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
                                              child: Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  SizedBox(
                                                    height: AppBar().preferredSize.height / 2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))],
                                                  ),
                                                  AutoSizeText("Add Qualification", style: Theme.of(context).textTheme.titleLarge),
                                                  const Divider(
                                                    color: Colors.transparent,
                                                  ),
                                                  DecoratedBox(
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: const Border.fromBorderSide(BorderSide())),
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                                        isExpanded: true,
                                                        value: qualification,
                                                        items: List.generate(
                                                          qualifications.length,
                                                          (index) => DropdownMenuItem(
                                                            value: qualifications.elementAt(index),
                                                            child: Text(qualifications.elementAt(index)),
                                                          ),
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            qualification = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                    color: Colors.transparent,
                                                  ),
                                                  TextFormField(
                                                    onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                                                    controller: schoolName,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                      label: RichText(
                                                          text: const TextSpan(text: "School/College Name", children: [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ))
                                                      ])),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter the name of the institution';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const Divider(
                                                    color: Colors.transparent,
                                                  ),
                                                  TextFormField(
                                                    onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                                                    controller: board,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                      label: RichText(
                                                          text: const TextSpan(text: "University/Board Name", children: [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ))
                                                      ])),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter the name of the University/ Board';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const Divider(
                                                    color: Colors.transparent,
                                                  ),
                                                  TextFormField(
                                                    onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                                                    controller: passingYear,
                                                    decoration: InputDecoration(
                                                      border: const OutlineInputBorder(),
                                                      label: RichText(
                                                          text: const TextSpan(text: "Passing Year", children: [
                                                        TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ))
                                                      ])),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLength: 4,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter valid year';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const Divider(
                                                    color: Colors.transparent,
                                                  ),
                                                  TextFormField(
                                                    onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                                                    controller: percentage,
                                                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), label: const Text("CGPA/Percentage")),
                                                    keyboardType: TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Please enter valid number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  Visibility(
                                                      visible: pursuing,
                                                      child: const Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [],
                                                      )),
                                                  const Divider(
                                                    color: Colors.transparent,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        value: pursuing,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            pursuing = !pursuing;
                                                          });
                                                        },
                                                      ),
                                                      const AutoSizeText("Highest Education ?"),
                                                      const Divider(
                                                        color: Colors.transparent,
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 8.r),
                                                    child: const AutoSizeText.rich(
                                                        TextSpan(text: "Fields marked with ", children: [TextSpan(text: "*", style: TextStyle(color: Colors.red)), TextSpan(text: " are required.")])),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () async {
                                                      if (schoolName.text.isNotEmpty && board.text.isNotEmpty && passingYear.text.isNotEmpty) {
                                                        AuthHandler().saveUserQualification(qualification, schoolName.text, board.text, int.parse(passingYear.text), double.parse(percentage.text),
                                                            pursuing ? 1 : 0, Hive.box(userDataDB).get("personalInfo")['user_id']);
                                                        await Hive.box(qualificationDataDB).put(qualification, {
                                                          "SchoolName": schoolName.text,
                                                          "Board": board.text,
                                                          "percentage": percentage.text,
                                                          "PassingYear": passingYear.text,
                                                          "HighestEd": pursuing
                                                        }).whenComplete(
                                                          () {
                                                            schoolName.clear();
                                                            board.clear();
                                                            percentage.clear();
                                                            passingYear.clear();
                                                            pursuing = false;
                                                            if (!context.mounted) {
                                                              return;
                                                            }
                                                            Navigator.pop(context);
                                                            setState(() {});
                                                          },
                                                        );
                                                      } else {
                                                        snackBarKey.currentState!.showSnackBar(const SnackBar(content: Text("Fill all required fields.")));
                                                      }
                                                    },
                                                    child: const AutoSizeText("Save"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
                  // TODO : Show an option to add qualification and display them in tiles first school second highSchool then graduation, post grdauation,etc
                  ValueListenableBuilder(
                    valueListenable: Hive.box(qualificationDataDB).listenable(),
                    builder: (context, value, child) {
                      return Visibility(
                        visible: Hive.box(qualificationDataDB).length != 0,
                        replacement: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                            child: AutoSizeText.rich(
                                TextSpan(text: "Click on ", children: [TextSpan(text: "\"+\"", style: Theme.of(context).textTheme.titleLarge), const TextSpan(text: " to add data.")])),
                          ),
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Hive.box(qualificationDataDB).length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final curr = Hive.box(qualificationDataDB).getAt(index);
                            final key = Hive.box(qualificationDataDB).keyAt(index);
                            return Slidable(
                              endActionPane: ActionPane(motion: const ScrollMotion(), children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Hive.box(qualificationDataDB).delete(key);
                                  },
                                  icon: Icons.delete,
                                  label: "Remove",
                                ),
                                SlidableAction(
                                  onPressed: (context) {},
                                  icon: Icons.edit,
                                  label: "Edit",
                                ),
                              ]),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Theme.of(context).colorScheme.secondary)), borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     AutoSizeText("Highest Qualification")
                                        //   ],
                                        // ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                                child: AutoSizeText(
                                              curr['SchoolName'],
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                              maxFontSize: 20,
                                            )),
                                            AutoSizeText(
                                              curr["PassingYear"],
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                              maxFontSize: 20,
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 4,
                                          color: Colors.transparent,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              "$key",
                                              style: Theme.of(context).textTheme.titleMedium,
                                              maxFontSize: 20,
                                            ),
                                            const Divider(
                                              height: 4,
                                              color: Colors.transparent,
                                            ),
                                            AutoSizeText(
                                              curr['Board'],
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey.shade600),
                                              maxFontSize: 14,
                                            ),
                                            AutoSizeText(
                                              "Percentage/CGPA : ${curr["percentage"]}",
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey.shade600),
                                              maxFontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {
            // print(Hive.box(userDataDB).get("personalInfo"));
            try {
              AuthHandler().saveUserData(
                  Hive.box(userDataDB).get("personalInfo")['user_id'], _name.text, _email.text, _age.text, "$city,$state,$country", _phone.text, Hive.box(userDataDB).get("interests").join(","));
              Map<dynamic, dynamic> data = Hive.box(userDataDB).get("personalInfo");
              // print(data['age']);
              data["name"] = _name.text.trim();
              data["email"] = _email.text.trim();
              data["age"] = _age.text.trim();
              data["country"] = country;
              data["state"] = state;
              data["city"] = city;
              Hive.box(userDataDB).put("personalInfo", data);
            } catch (e) {
              log(e.toString());
              snackBarKey.currentState?.showSnackBar(const SnackBar(content: Text("Something went wrong. Try again later.")));
            }
          },
          style: FilledButton.styleFrom(fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width)),
          child: const Text("Proceed"),
        ),
      ),
    );
  }
}
