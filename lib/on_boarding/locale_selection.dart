import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kGamify/blocs/theme_cubit.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/utils/locale_selection_cubit.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:vector_graphics/vector_graphics.dart';

class LocaleSelection extends StatelessWidget {
  const LocaleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> locales = {
      "en": "English",
      "hi": "हिन्दी",
      "da": "Dansk",
      "de": "Deutsch",
      "sv": "Svenska",
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
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, state) {
                          return Switch.adaptive(
                            dragStartBehavior: DragStartBehavior.start,
                            trackOutlineWidth: const WidgetStatePropertyAll(0.3),
                            thumbIcon: WidgetStatePropertyAll(state == ThemeMode.dark
                                ? const Icon(
                                    CupertinoIcons.moon,
                                    color: Colors.white,
                                  )
                                : const Icon(CupertinoIcons.sun_min)),
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
                Text(
                  S.of(context).chooseLanguage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.sp),
                ),
                const SizedBox(
                  height: kToolbarHeight,
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: locales.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8.r, crossAxisSpacing: 8.r),
                    itemBuilder: (context, index) {
                      return ClipRect(
                        child: InkWell(
                          onTap: () async {
                            // context.read<LocaleSelectionCubit>().updateLocaleOnStartup(locales.keys.elementAt(index));
                            await Hive.box(userDataDB).put("isLocaleSet", true).whenComplete(
                              () {
                                localeCubit.updateLocaleOnStartup(locales.keys.elementAt(index));
                              },
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture(
                                AssetBytesLoader('assets/flags/${locales.keys.elementAt(index)}.svg.vec'), height: 48.r,
                                // ,height: 64,width: 64,
                              ),
                              // const SizedBox(
                              //   height: 4,
                              // ),
                              Text(locales.values.elementAt(index))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
