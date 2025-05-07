// Create a new file for filter chips
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kGamify/blocs/championships_details_bloc.dart';
import 'package:kGamify/utils/constants.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> champFilters;
  final ValueNotifier<List<String>> selectedFilters;
  final TextEditingController searchController;

  FilterChipsWidget({
    required this.champFilters,
    required this.selectedFilters,
    required this.searchController,
    super.key,
  });

  final Map<String, String> modeNames = {"Quick Hit": "quick_hit", "Play and Win": "play_win_gift"};

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedFilters,
      builder: (context, value, child) {
        return Wrap(
          spacing: 4.r,
          runSpacing: 4.r,
          children: [
            _buildFilterChip(context, "Quick Hit", value),
            _buildFilterChip(context, "Play and Win", value),
            // ...champFilters.map((filter) => _buildFilterChip(context, filter, value)),
            _buildShowAllChip(context, value),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String filter, List<String> value) {
    return FilterChip(
      label: Text(filter, style: Theme.of(context).textTheme.bodySmall),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1),
      showCheckmark: false,
      selected: value.contains(modeNames[filter] ?? ''),
      onSelected: (selected) => _handleFilterSelection(selected, filter, context),
    );
  }

  void _handleFilterSelection(bool selected, String filter, BuildContext context) {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
    }
    final List<String> updatedFilters = List.from(selectedFilters.value);
    if (selected) {
      mixpanel!.track("FilterSelected", properties: {"UserId": Hive.box(userDataDB).get("personalInfo")['user_id'], "Filter": modeNames[filter], "timeStamp": DateTime.now()});
      updatedFilters.add(modeNames[filter]!);
    } else {
      updatedFilters.remove(modeNames[filter]);
    }
    selectedFilters.value = updatedFilters;
    context.read<ChampionshipsBloc>().showFilteredChamps(updatedFilters);
  }

  Widget _buildShowAllChip(BuildContext context, List<String> value) {
    return FilterChip(
      label: Text("Show all", style: Theme.of(context).textTheme.bodySmall),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1),
      onSelected: (chipValue) {
        // print(chipValue);
        if (chipValue) {
          List<String> updatedFilters = [];
          selectedFilters.value = updatedFilters;
          context.read<ChampionshipsBloc>().showFilteredChamps([]);
        }
      },
      selected: value.isEmpty,
      showCheckmark: false,
    );
  }
}
