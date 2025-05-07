import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kGamify/blocs/championships_details_bloc.dart';

class ChampionshipSearchBar extends StatefulWidget {
  const ChampionshipSearchBar({super.key});

  @override
  State<ChampionshipSearchBar> createState() => _ChampionshipSearchBarState();
}

class _ChampionshipSearchBarState extends State<ChampionshipSearchBar> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() {}); // Triggers rebuild to show/hide clear icon
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0).r,
      child: SearchBar(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            context.read<ChampionshipsBloc>().searchChampionship(value.trim());
          },
          controller: _search,
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8).r)),
          leading: Icon(Icons.search),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 6).r),
          hintText: "Search",
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.12)),
          trailing: _search.text.isEmpty
              ? null
              : [
                  InkWell(
                    child: Icon(CupertinoIcons.clear_circled),
                    onTap: () {
                      _search.clear();
                      context.read<ChampionshipsBloc>().searchChampionship('');
                    },
                  ),
                ]),
    );
  }
}
