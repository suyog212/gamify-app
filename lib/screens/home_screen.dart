import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/blocs/championships_details_bloc.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/models/championship_details_model.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/drawer.dart';
import 'package:kGamify/utils/widgets/ad_banner_carousel.dart';
import 'package:kGamify/utils/widgets/championship_ad_banner.dart';
import 'package:kGamify/utils/widgets/championship_card.dart';
import 'package:kGamify/utils/widgets/championship_card_skeleton.dart';
import 'package:kGamify/utils/widgets/championship_search_bar.dart';
import 'package:kGamify/utils/widgets/filter_chips_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {
  String _selectedSortOption = "Date";
  final List<String> _sortOptions = ["Date", "A-Z", "Status"];
  Map<String, String> modeNames = {"Quick Hit": "quick_hit", "Play and Win": "play_win_gift"};
  bool isSearching = false;
  // final carouselController = CarouselController();
  List<String> champFilters = ["Quick Hit", "Play and Win"];
  ValueNotifier<List<String>> selectedFilters = ValueNotifier([]);
  final tagKey = GlobalKey(debugLabel: "scrollToTag");
  ValueNotifier<int> dotIndex = ValueNotifier(0);
  final TextEditingController _search = TextEditingController();
  ValueNotifier<bool> clearSearch = ValueNotifier(false);

  final FocusNode _searchFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    selectedFilters.dispose();
    dotIndex.dispose();
    clearSearch.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            setState(() {
              context.read<ChampionshipsBloc>().retryFetching();
            });
          },
          child: Scrollbar(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  key: tagKey,
                  pinned: true,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  title: Text(
                    S.current.championships,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    if (kDebugMode)
                      IconButton(
                          onPressed: () {
                            // print(selectedFilters.value);
                          },
                          icon: Icon(Icons.notifications)),
                  ],
                  bottom: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: ChampionshipSearchBar()),
                ),
                SliverToBoxAdapter(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        Divider(
                          color: Colors.transparent,
                        ),
                        AdBannerCarousel(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilterChipsWidget(champFilters: champFilters, selectedFilters: selectedFilters, searchController: _search),
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: const BorderRadius.vertical(top: Radius.circular(15))),
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
                                                                        context.read<ChampionshipsBloc>().sortChampionships(value);
                                                                        mixpanel!.track("FilterSelected",
                                                                            properties: {"UserId": Hive.box(userDataDB).get("personalInfo")['user_id'], "Filter": value, "timeStamp": DateTime.now()});
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                  ),
                                                                  AutoSizeText(_sortOptions.elementAt(index))
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
                        BlocBuilder<ChampionshipsBloc, ChampionshipsStates>(
                          buildWhen: (previous, current) {
                            return previous != current;
                          },
                          builder: (context, championshipState) {
                            if (championshipState is CategoriesLoadingState) {
                              return MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16).r,
                                  children: [
                                    Skeletonizer(
                                      enabled: true,
                                      effect: PulseEffect(from: Colors.grey.shade100, to: Colors.orange.shade100),
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
                                    children: [Text(championshipState.error), TextButton(onPressed: () => context.read<ChampionshipsBloc>().retryFetching(), child: const Text("Retry"))],
                                  ));
                            }
                            if (championshipState is CategoriesLoadedState) {
                              if (championshipState.models.isEmpty) {
                                return SizedBox(
                                  height: 150.r,
                                  child: Center(child: Text("No results found.")),
                                );
                              }
                              return MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(left: 12, right: 12).r,
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: championshipState.models.length,
                                  itemBuilder: (context, index) {
                                    final curr = championshipState.models.elementAt(index);
                                    return ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: championshipState.models.elementAt(index).championshipDetails?.length,
                                      itemBuilder: (context, indexDetails) {
                                        final currDetails = championshipState.models.elementAt(index).championshipDetails?.elementAt(indexDetails);
                                        if (int.parse(currDetails!.categoryStatus ?? "0") == 1 && int.parse(currDetails.champStatus!) == 1) {
                                          return Column(
                                            children: [
                                              ChampionshipInformationCard(
                                                key: ValueKey('${curr.champId}_${curr.categoryId}'),
                                                startDate: curr.startDate ?? "",
                                                endDate: curr.endDate ?? "",
                                                startTime: curr.startTime ?? "",
                                                endTime: curr.endTime ?? "",
                                                champId: curr.champId ?? "",
                                                categoryId: curr.categoryId ?? "",
                                                champName: curr.champName ?? "",
                                                categoryName: curr.categoryName ?? "",
                                                modeName: currDetails.modeName ?? "",
                                                modeId: int.parse(currDetails.modeId ?? "0"),
                                                timeMinutes: stringToSeconds(currDetails.timeMinutes ?? ""),
                                                noOfQuestions: int.parse(currDetails.noOfQuestion ?? ""),
                                                noOfUsers: 50000,
                                                uploadImg: currDetails.uploadImg ?? "",
                                                teacherId: int.parse(currDetails.teacherId ?? ""),
                                                categoryStatus: currDetails.categoryStatus ?? "",
                                                champStatus: currDetails.champStatus ?? "",
                                                teacherDetailsModel: currDetails.teacherDetailsModel ??
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
                                                        createdAt: "createdAt"),
                                                heroIndex: indexDetails,
                                                giftImage: currDetails.giftImage,
                                                gameModeRules: currDetails.gameModeRules,
                                                giftDescription: currDetails.giftDescription,
                                                noOfUserPlayed: currDetails.noOfUsersPlayed,
                                                questionCount: currDetails.questionCount,
                                                userQualification: currDetails.userQualification,
                                                uniqueId: currDetails.uniqueId ?? "",
                                              ),
                                              ChampionshipBannerAds(champId: curr.champId ?? "0")
                                            ],
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                            return const Text("Something went wrong.");
                          },
                        ),
                        const Divider(
                          color: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

final _stringToSecondsMemo = <String, int>{};

int stringToSeconds(String time) {
  return _stringToSecondsMemo[time] ??= () {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return (hours * 3600) + (minutes * 60) + seconds;
  }();
}
