import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamify_test/blocs/theme_cubit.dart';
import 'package:gamify_test/on_boarding/utils/locale_selection_cubit.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vector_graphics/vector_graphics.dart';

class LocaleSelection extends StatelessWidget {
  const LocaleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String,String> locales = {
      "en" : "English",
      "hi" : "Hindi",
      "da" : "Danish",
      "de" : "German",
      "sv" : "Swedish",
    };

    final localeCubit = LocaleSelectionCubit();
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: kToolbarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, state) {
                          return Switch.adaptive(
                            dragStartBehavior: DragStartBehavior.start,
                            trackOutlineWidth: const WidgetStatePropertyAll(1),
                            thumbIcon: WidgetStatePropertyAll(state == ThemeMode.dark ? const Icon(CupertinoIcons.moon,color: Colors.white,) : const Icon(CupertinoIcons.sun_min)),
                            value: state == ThemeMode.dark,
                            onChanged: (value) {
                              if (value) {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                              } else {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Text("Choose Language",textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleLarge,),
                const SizedBox(height: kToolbarHeight,),
                Expanded(
                  child: GridView.builder(
                    itemCount: locales.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Hive.box(userDataDB).put("isLocaleSet",true).whenComplete(() {
                          localeCubit.updateLocale(locales.keys.elementAt(index));
                        },);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture(AssetBytesLoader('assets/flags/${locales.keys.elementAt(index)}.svg.vec'),height: 64,width: 64,),
                          Text(locales.values.elementAt(index))
                        ],
                      ),
                    );
                  },
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
