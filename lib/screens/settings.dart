import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/blocs/theme_cubit.dart';
import 'package:kGamify/generated/l10n.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, String> locales = {
    "en": "English",
    "hi": "हिन्दी",
    "da": "Dansk",
    "de": "Deutsch",
    "sv": "Svenska",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // BlocBuilder<LocaleSelectionCubit, String>(
            //   builder: (context, state) {
            //     return ListTile(
            //       title: Text(S.current.chooseLanguage),
            //       trailing: DropdownButtonHideUnderline(
            //           child: DropdownButton(
            //         items: List.generate(
            //           locales.length,
            //           (index) => DropdownMenuItem(
            //             value: locales.keys.elementAt(index),
            //             child: Text(locales.values.elementAt(index)),
            //           ),
            //         ),
            //         value: state,
            //         onChanged: (value) {
            //           if (value != null) {
            //             context.read<LocaleSelectionCubit>().updateLocale(value);
            //           }
            //         },
            //       )),
            //     );
            //   },
            // ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return SwitchListTile(
                  thumbIcon: WidgetStatePropertyAll(state == ThemeMode.dark
                      ? const Icon(
                          CupertinoIcons.moon,
                          color: Colors.white,
                        )
                      : const Icon(CupertinoIcons.sun_min)),
                  title: Text(S.current.darkTheme),
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
            ListTile(
              title: const Text("Liscences"),
              onTap: () {
                showLicensePage(context: context, applicationVersion: "1.0.0");
              },
            )
            // const ListTile(
            //   title: Text("About us"),
            // ),
            // ListTile(
            //   trailing: const Icon(Icons.logout),
            //   title: Text(S.current.logOut),
            //   onTap: () async {
            //     await Hive.box(userDataDB).clear();
            //     await Hive.box(quizDataDB).clear();
            //     await Hive.box(qualificationDataDB).clear().whenComplete(
            //       () {
            //         if (!context.mounted) return;
            //         context.go("/");
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
