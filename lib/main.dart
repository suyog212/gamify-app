import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamify_test/blocs/championships_details_bloc.dart';
import 'package:gamify_test/blocs/internet_cubit.dart';
import 'package:gamify_test/blocs/question_bloc.dart';
import 'package:gamify_test/blocs/question_view_cubit.dart';
import 'package:gamify_test/blocs/theme_cubit.dart';
import 'package:gamify_test/on_boarding/utils/auth_cubit.dart';
import 'package:gamify_test/on_boarding/utils/locale_selection_cubit.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:gamify_test/utils/router.dart';
import 'package:gamify_test/utils/themes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Hive.initFlutter();
  await Hive.openBox(userDataDB);
  await Hive.openBox(quizDataDB);
  await Hive.openBox(qualificationDataDB);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  AppTheme appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit(),),
        BlocProvider(create: (context) => LocaleSelectionCubit(),),
        BlocProvider(create: (context) => AuthCubit(),),
        BlocProvider(create: (context) => InternetCubit(),),
        BlocProvider(create: (context) => ChampionshipsBloc(),),
        BlocProvider(create: (context) => QuestionsBloc(),),
        BlocProvider(create: (context) => QuestionViewCubit(),)
      ],
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, state) {
          return BlocBuilder<LocaleSelectionCubit, String>(
            builder: (context, String locale) {
              return BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return MaterialApp.router(
                    routerConfig: AppRouter().router,
                    title: 'kGamify',
                    theme: appTheme.lightTheme,
                    darkTheme: appTheme.darkTheme,
                    locale: Locale(locale),
                    themeMode: themeMode,
                    scaffoldMessengerKey: snackBarKey,
                    // home: const HomeScreen(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
