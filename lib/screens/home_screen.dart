import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/blocs/championships_details_bloc.dart';
import 'package:gamify_test/models/championship_details_model.dart';
import 'package:gamify_test/utils/championship_card.dart';
import 'package:gamify_test/utils/championship_card_skeleton.dart';
import 'package:gamify_test/utils/drawer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _selectedSortOption = "Date";
  final List<String> _sortOptions = ["Date", "A-Z", "Status"];
  Map<String, String> modeNames = {
    "Quick Hit": "quick_hit",
    "Play and Win": "play_win_gift"
  };
  bool isSearching = false;
  // final carouselController = CarouselController();
  List<String> champFilters = ["Quick Hit", "Play and Win"];
  List<String> selectedFilters = [];
  final tagKey = GlobalKey(debugLabel: "scrollToTag");
  ValueNotifier<int> dotIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text("Championships",style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold
          ),),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (value) {
                      if(value) Scrollable.ensureVisible(tagKey.currentContext!);
                    },
                    child: SearchBar(
                      elevation: const WidgetStatePropertyAll(0),
                      hintText: "Search",
                      leading: const Icon(CupertinoIcons.search),
                      padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1)),
                      shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onChanged: (value) {
                        context.read<ChampionshipsBloc>().searchChampionship(value.trim());
                      },
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                    ),
                  ),
                ),
              )),
        ),
        body: RefreshIndicator(
          onRefresh: () async => context.read<ChampionshipsBloc>().getCategories(),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            children: [
              // SizedBox(
              //   height: MediaQuery.sizeOf(context).height * 0.25,
              //   width: MediaQuery.sizeOf(context).width,
              //   child: CarouselView(
              //       controller: _carouselController,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)),
              //       itemSnapping: true,
              //       itemExtent: MediaQuery.sizeOf(context).width - 16,
              //       children: List.generate(
              //         4,
              //         (index) {
              //           return Column(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               Container(
              //                 height: MediaQuery.sizeOf(context).height * 0.2,
              //                 color: Colors.orange,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: List.generate(
              //                   4,
              //                   (badgeIndex) {
              //                     return Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Badge(
              //                         backgroundColor: index == badgeIndex
              //                             ? Colors.orange
              //                             : Colors.grey
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               ),
              //             ],
              //           );
              //         },
              //       )),
              // ),
              CarouselSlider(items: List.generate(4, (index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: const AutoSizeText("This is an advertisement"),
                );
              },),
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    dotIndex.value = index;
                  },
                  height: MediaQuery.sizeOf(context).height * 0.25,
                aspectRatio: 16/9,
                scrollPhysics: const BouncingScrollPhysics(),
                enableInfiniteScroll: false,
                viewportFraction: 1
              ),
                disableGesture: false,
              ),
              ValueListenableBuilder(valueListenable: dotIndex, builder: (context, value, child) {
                return DotsIndicator(dotsCount: 4,position: value,decorator: DotsDecorator(activeColor: Theme.of(context).colorScheme.secondary),);
              },),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      key: tagKey,
                      "Show championship",
                      // AppLocalizations.of(context)!.selectChampionship,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                contentPadding: EdgeInsets.zero,
                                content: StatefulBuilder(
                                  builder: (context, setState) {
                                    return SizedBox(
                                      width: MediaQuery.sizeOf(context).width * 0.8,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondary,
                                                borderRadius: const BorderRadius.vertical(
                                                    top: Radius.circular(15))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Sort by",
                                                    style: Theme.of(context).textTheme.titleLarge,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
                                                  _sortOptions.length,
                                                      (index) {
                                                    return OverflowBar(
                                                      alignment: MainAxisAlignment.start,
                                                      spacing: 0,
                                                      children: [
                                                        Radio(
                                                          value: _sortOptions.elementAt(index),
                                                          groupValue: _selectedSortOption,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _selectedSortOption = value!;
                                                              context
                                                                  .read<ChampionshipsBloc>()
                                                                  .sortChampionships(value);
                                                              Navigator.pop(context);
                                                            });
                                                          },
                                                        ),
                                                        AutoSizeText(
                                                            _sortOptions.elementAt(index))
                                                      ],
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.sort_outlined))
                  ],
                ),
              ),
              Wrap(spacing: 8,
                  runSpacing: 8,
                  children: [
                ...champFilters.map(
                  (filter) {
                    return FilterChip(
                      label: Text(filter),
                      selected:
                          selectedFilters.contains(modeNames[filter] ?? ''),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedFilters.add(modeNames[filter]!);
                          } else {
                            selectedFilters.remove(modeNames[filter]);
                          }
                        });
                        context
                            .read<ChampionshipsBloc>()
                            .showFilteredChamps(selectedFilters);
                      },
                    );
                  },
                ),
                FilterChip(
                  label: const Text("Show all"),
                  onSelected: (value) {
                    if (value) {
                      setState(() {
                        selectedFilters.clear();
                      });
                    }
                  },
                  selected: selectedFilters.isEmpty,
                )
              ]),
              //const Divider(color: Colors.transparent,),
              BlocBuilder<ChampionshipsBloc, ChampionshipsStates>(
                builder: (context, championshipState) {
                  if (championshipState is CategoriesLoadingState) {
                    return RefreshIndicator(
                      onRefresh: () async => context.read<ChampionshipsBloc>().getCategories(),
                      child: ListView(
                        shrinkWrap: true,
                        padding:
                            const EdgeInsets.only(bottom: 16),
                        children: [
                          Skeletonizer(
                            enabled: true,
                            effect: PulseEffect(
                                from: Colors.grey.shade100,
                                to: Colors.orange.shade100),
                            child: ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                3,
                                (index) => const ChampionShipInfoSkeleton(),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (championshipState is CategoriesErrorState) {
                    return SizedBox(
                      height: kToolbarHeight * 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(championshipState.error),
                          TextButton(onPressed: () => context.read<ChampionshipsBloc>().retryFetching(), child: const Text("Retry"))
                        ],
                      )
                    );
                  }
                  if (championshipState is CategoriesLoadedState) {
                    return ListView.builder(
                      // padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: championshipState.models.length,
                      itemBuilder: (context, index) {
                        final curr = championshipState.models.elementAt(index);
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: championshipState.models
                              .elementAt(index)
                              .championshipDetails
                              ?.length,
                          itemBuilder: (context, indexDetails) {
                            final currDetails = championshipState.models
                                .elementAt(index)
                                .championshipDetails
                                ?.elementAt(indexDetails);
                            if (int.parse("${currDetails!.categoryStatus}") ==
                                    1 &&
                                int.parse(currDetails.champStatus!) == 1) {
                              return Column(
                                children: [
                                  ChampionshipInformationCard(
                                      startDate: curr.startDate ?? "",
                                      endDate: curr.endDate ?? "",
                                      startTime: curr.startTime ?? "",
                                      endTime: curr.endTime ?? "",
                                      champId: curr.champId ?? "",
                                      categoryId: curr.categoryId ?? "",
                                      champName: curr.champName ?? "",
                                      categoryName: curr.categoryName ?? "",
                                      modeName: currDetails.modeName ?? "",
                                      modeId: int.parse(currDetails.modeId!),
                                      timeMinutes: int.parse(
                                          currDetails.timeMinutes ?? "10"),
                                      noOfQuestions: int.parse(
                                          currDetails.noOfQuestion ?? "10"),
                                      noOfUsers: 50000,
                                      uploadImg: currDetails.uploadImg ??
                                          "https://i.pinimg.com/736x/c0/27/be/c027bec07c2dc08b9df60921dfd539bd.jpg",
                                      teacherId:
                                          int.parse(currDetails.teacherId!),
                                      categoryStatus:
                                          currDetails.categoryStatus ?? "0",
                                      champStatus: currDetails.champStatus ?? "0",
                                      teacherDetailsModel:
                                          currDetails.teacherDetailsModel ??
                                              TeacherDetailsModel(
                                                  teacherId: "teacherId",
                                                  uniqueId: "uniqueId",
                                                  status: "status",
                                                  teacherName: "teacherName",
                                                  username: "username",
                                                  email: "email",
                                                  password: "password",
                                                  phone: "phone",
                                                  institute: "institute",
                                                  department: "department",
                                                  uploadImg: "uploadImg",
                                                  createdAt: "createdAt")),
                                  const SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("This is a ad"),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      },
                    );
                  }
                  return const Text("Something went wrong");
                },
              )
            ],
          ),
        ));
  }
}
