import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kGamify/blocs/user_image_bloc.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/utils/auth_handler.dart';
import 'package:kGamify/utils/constants.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _name = TextEditingController(
      text: Hive.box(userDataDB)
          .get("personalInfo", defaultValue: {"name": ""})["name"]);
  final TextEditingController _age = TextEditingController(
      text: Hive.box(userDataDB)
          .get("personalInfo", defaultValue: {"age": ""})["age"]);
  final TextEditingController _email = TextEditingController(
    text: Hive.box(userDataDB)
        .get("personalInfo", defaultValue: {"email": ""})["email"],
  );
  final TextEditingController _phone = TextEditingController(
    text: Hive.box(userDataDB)
        .get("personalInfo", defaultValue: {"phone_no": ""})["phone_no"],
  );
  final formKey = GlobalKey<FormState>();
  final TextEditingController schoolName = TextEditingController();
  final TextEditingController board = TextEditingController();
  final TextEditingController percentage = TextEditingController();
  final TextEditingController passingYear = TextEditingController();

  ValueNotifier<String?> country = ValueNotifier(Hive.box(userDataDB)
      .get("personalInfo", defaultValue: {"country": null})["country"]);
  ValueNotifier<String?> state = ValueNotifier(Hive.box(userDataDB)
      .get("personalInfo", defaultValue: {"state": null})["state"]);
  ValueNotifier<String?> city = ValueNotifier(Hive.box(userDataDB)
      .get("personalInfo", defaultValue: {"city": null})["city"]);
  bool pursuing = false;

  List<String> interests = [
    "Video games",
    "Traveling",
    "Music",
    "Puzzles",
    "Movies",
    "Books",
    "Writing",
    "Fitness",
    "Art",
    "Programming"
  ];

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

  List<String> qualifications = [
    "School",
    "High School",
    "Diploma",
    "Graduation",
    "Post Graduation",
    "Ph.D"
  ];
  String qualification = "School";

  ValueNotifier locationEditMode = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    locationEditMode.dispose();
    super.dispose();
  }

  void pickProfilePicture(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List rawData = await file.readAsBytes();
      Hive.box(userDataDB).put("UserImage", rawData).whenComplete(
            () => setState(() {}),
          );
    } else {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("No image selected\nFailed to change profile image."),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                // print(AppRouter().router.state!.fullPath);
                context.push("/landingPage/profile/personalInfoEdit");
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            // padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                // color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (Hive.box(userDataDB)
                                    .get("UserImage", defaultValue: null) !=
                                null)
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text("Remove picture"),
                                onTap: () => context.read<UserDataBloc>().removeImage(),
                              ),
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: Hive.box(userDataDB).get("UserImage",
                                          defaultValue: null) !=
                                      null
                                  ? const Text("Change picture")
                                  : const Text("Add profile picture"),
                              onTap: () => context.read<UserDataBloc>().updateImage(),
                            ),
                            const Divider(
                              color: Colors.transparent,
                            )
                          ],
                        );
                      },
                      context: context,
                    ),
                    child: Hero(
                      tag: "UserPfp",
                      child: BlocBuilder<UserDataBloc, UserImageStates>(
                        builder: (context, state) {
                          if (state is UserImageSet) {
                            return CircleAvatar(
                              radius: 48.r,
                              backgroundImage: MemoryImage(state.image),
                            );
                          }
                          return CircleAvatar(
                              radius: 48.r,
                              child: const Icon(CupertinoIcons.camera));
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      _name.text,
                      style: TextStyle(
                          fontSize: 24.r, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    AutoSizeText(
                      "@${Hive.box(userDataDB).get("personalInfo", defaultValue: {
                            "user_key": ""
                          })["user_key"]}",
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.transparent,
          ),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: _personalInfo(context)),
          const Divider(
            color: Colors.transparent,
          ),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity( 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: _educationInfo()),
          const Divider(
            color: Colors.transparent,
          ),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: _interestsInfo())
        ],
      ),
    );
  }

  Widget _personalInfo(BuildContext context) {
    // ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    return SizedBox(
        child: ValueListenableBuilder(
      valueListenable: locationEditMode,
      builder: (context, value, child) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // padding: const EdgeInsets.all(16),
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  S.current.details,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(
              color: Colors.transparent,
            ),
            TextFormField(
              enabled: locationEditMode.value,
              controller: _name,
              decoration: InputDecoration(
                  label: Text(S.current.name),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            TextFormField(
              enabled: locationEditMode.value,
              controller: _age,
              decoration: InputDecoration(
                  label: Text(S.current.age),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            TextFormField(
              controller: _email,
              enabled: locationEditMode.value,
              decoration: InputDecoration(
                  label: Text(S.current.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            TextFormField(
              controller: _phone,
              enabled: locationEditMode.value,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  label: Text(S.current.phoneNumber),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            Visibility(
              visible: value,
              replacement: TextFormField(
                controller: TextEditingController(
                    text: "${city.value}, ${state.value}, ${country.value}"),
                enabled: locationEditMode.value,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    label: Text(S.current.address),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              child: RepaintBoundary(
                child: CSCPicker(
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: const Border.fromBorderSide(
                        BorderSide(color: Colors.black)),
                  ),
                  currentCountry: country.value,
                  currentCity: city.value,
                  currentState: state.value,
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.7)),
                  defaultCountry: CscCountry.India,
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  onCityChanged: (value) {
                    city.value = value ?? "";
                  },
                  onCountryChanged: (value) {
                    country.value = value;
                  },
                  onStateChanged: (value) {
                    state.value = value ?? "";
                  },
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            // Text('$city $state $country'),
            // FilledButton(
            //     onPressed: () {
            //       // print("Done");
            //       Map<dynamic, dynamic> data =
            //           Hive.box(userDataDB).get("personalInfo");
            //       data["name"] = _name.text;
            //       data["email"] = _email.text;
            //       data["country"] = country.value;
            //       data["state"] = state.value;
            //       data["city"] = city.value;
            //       data["phone_number"] = _phone.text;
            //       Hive.box(userDataDB).put("personalInfo", data).whenComplete(
            //         () {
            //           scaffoldMessenger.showSnackBar(const SnackBar(
            //               content: Text(("User data updated successfully"))));
            //         },
            //       );
            //       // print(data);
            //     },
            //     child: const Text("Submit"))
          ],
        );
      },
    ));
  }

  Widget _educationInfo() {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(S.current.qualification,
                  style: TextStyle(
                    fontSize: 18.sp
                  )),
              if (kDebugMode)
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        sheetAnimationStyle:
                            AnimationStyle(curve: Curves.easeInOut),
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
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewPadding
                                                .bottom),
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            SizedBox(
                                              height: AppBar()
                                                      .preferredSize
                                                      .height /
                                                  2,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                            AutoSizeText("Add Education",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: const Border
                                                      .fromBorderSide(
                                                      BorderSide())),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  isExpanded: true,
                                                  value: qualification,
                                                  items: List.generate(
                                                    qualifications.length,
                                                    (index) => DropdownMenuItem(
                                                      value: qualifications
                                                          .elementAt(index),
                                                      child: Text(qualifications
                                                          .elementAt(index)),
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
                                              controller: schoolName,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  label: const Text(
                                                      "School/College Name")),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the name of the institution';
                                                }
                                                return null;
                                              },
                                            ),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                            TextFormField(
                                              controller: board,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  label: const Text(
                                                      "University/Board Name")),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the name of the University/ Board';
                                                }
                                                return null;
                                              },
                                            ),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                            TextFormField(
                                              controller: passingYear,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  label: Text("Passing year")),
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 4,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter valid year';
                                                }
                                                return null;
                                              },
                                            ),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                            TextFormField(
                                              controller: percentage,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  label: const Text(
                                                      "CGPA/Percentage")),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter valid number';
                                                }
                                                return null;
                                              },
                                            ),
                                            Visibility(
                                                visible: pursuing,
                                                child: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [],
                                                )),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                            OverflowBar(
                                              alignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Checkbox(
                                                  value: pursuing,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      pursuing = !pursuing;
                                                    });
                                                  },
                                                ),
                                                const AutoSizeText(
                                                    "Highest Education ?")
                                              ],
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  AuthHandler()
                                                      .saveUserQualification(
                                                          qualification,
                                                          schoolName.text,
                                                          board.text,
                                                          int.parse(
                                                              passingYear.text),
                                                          double.parse(
                                                              percentage.text),
                                                          pursuing ? 1 : 0,
                                                          Hive.box(userDataDB).get(
                                                                  "personalInfo")[
                                                              'user_id']);
                                                  Hive.box(qualificationDataDB)
                                                      .put(qualification, {
                                                    "SchoolName":
                                                        schoolName.text,
                                                    "Board": board.text,
                                                    "percentage":
                                                        percentage.text,
                                                    "PassingYear":
                                                        passingYear.text,
                                                    "HighestEd": pursuing
                                                  }).whenComplete(
                                                    () {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                  );
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
          ValueListenableBuilder(
            valueListenable: Hive.box(qualificationDataDB).listenable(),
            builder: (context, value, child) {
              return Visibility(
                visible: Hive.box(qualificationDataDB).length != 0,
                replacement: const Expanded(
                  child: Center(
                    child: Text("Nothing to show here."),
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
                      endActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            Hive.box(qualificationDataDB).delete(key);
                          },
                          icon: Icons.delete,
                          label: "Remove",
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        SlidableAction(
                          onPressed: (context) {},
                          icon: Icons.edit,
                          label: "Edit",
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText(
                                      curr['SchoolName'],
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold
                                      ),
                                      maxFontSize: 20,
                                    )),
                                    AutoSizeText(
                                      curr["PassingYear"],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                        fontSize: 16.sp
                                      ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      maxFontSize: 20,
                                    ),
                                    const Divider(
                                      height: 4,
                                      color: Colors.transparent,
                                    ),
                                    AutoSizeText(
                                      curr['Board'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Colors.grey.shade600),
                                      maxFontSize: 14,
                                    ),
                                    AutoSizeText(
                                      "Percentage/CGPA : ${curr["percentage"]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Colors.grey.shade600),
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
    );
  }

  Widget _interestsInfo() {
    return SizedBox(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // padding: const EdgeInsets.all(16),
        children: [
          AutoSizeText(
            S.current.interests,
            style: TextStyle(
                fontSize: 18.sp
            ),
          ),
          const Divider(
            color: Colors.transparent,
          ),
          ValueListenableBuilder<Box>(
            valueListenable: Hive.box(userDataDB).listenable(),
            builder: (context, value, child) {
              return AbsorbPointer(
                absorbing: true,
                child: Wrap(
                    runSpacing: 4,
                    spacing: 8,
                    children: List.generate(
                      interests.length,
                      (index) {
                        List<String> curr = Hive.box(userDataDB)
                            .get("interests", defaultValue: <String>[]);
                        return ChoiceChip.elevated(
                          // disabledColor: Colors.grey,
                          // color: WidgetStatePropertyAll(Colors.orange),
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                          avatar:
                              Icon(interestsIcons[interests.elementAt(index)]),
                          label: Text(interests.elementAt(index)),
                          selected: curr.contains(interests.elementAt(index)),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity( 0.3),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary),
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          onSelected: (value) {
                            // if (value) {
                            //   curr.add(interests.elementAt(index));
                            //   curr = curr.toSet().toList();
                            //   Hive.box(userDataDB).put("interests", curr);
                            // } else {
                            //   curr.remove(interests.elementAt(index));
                            //   curr = curr.toSet().toList();
                            //   Hive.box(userDataDB).put("interests", curr);
                            // }
                          },
                        );
                      },
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
