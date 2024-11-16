import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/blocs/theme_cubit.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text("Change language"),
              trailing: Text("English"),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return SwitchListTile(
                  thumbIcon: WidgetStatePropertyAll(state == ThemeMode.dark ? const Icon(CupertinoIcons.moon,color: Colors.white,) : const Icon(CupertinoIcons.sun_min)),
                  title: const Text("Dark theme"),
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
            const ListTile(
              title: Text("About us"),
            ),
          ],
        ),
      ),
    );
  }
}
