import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kGamify/blocs/championship_analytics_cubit.dart';
import 'package:kGamify/blocs/championships_details_bloc.dart';
import 'package:kGamify/blocs/internet_cubit.dart';
import 'package:kGamify/blocs/question_analytics_cubit.dart';
import 'package:kGamify/blocs/question_bloc.dart';
import 'package:kGamify/blocs/question_view_cubit.dart';
import 'package:kGamify/blocs/theme_cubit.dart';
import 'package:kGamify/blocs/user_image_bloc.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/utils/auth_cubit.dart';
import 'package:kGamify/on_boarding/utils/forgot_password_cubit.dart';
import 'package:kGamify/on_boarding/utils/language_bloc.dart';
import 'package:kGamify/on_boarding/utils/locale_selection_cubit.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/router.dart';
import 'package:kGamify/utils/themes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await ScreenUtil.ensureScreenSize();
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
        BlocProvider(create: (context) => QuestionViewCubit(),),
        BlocProvider(create: (context) => ChampionshipAnalyticsCubit(),),
        BlocProvider(create: (context) => QuestionAnalyticsCubit(),),
        BlocProvider(create: (context) => LanguageBloc(),),
        BlocProvider(create: (context) => UserDataBloc(),),
        BlocProvider(create: (context) => ForgotPasswordCubit(),)
      ],
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, state) {
          return BlocBuilder<LocaleSelectionCubit, String>(
            builder: (context, locale) {
              return BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return MaterialApp.router(
                    showSemanticsDebugger: false,
                    routerConfig: AppRouter().router,
                    title: 'kGamify',
                    theme: appTheme.lightTheme,
                    darkTheme: appTheme.darkTheme,
                    locale: Locale(locale),
                    themeMode: themeMode,
                    supportedLocales: const [
                      Locale('en'),
                      Locale('da'),
                      Locale('de'),
                      Locale('hi'),
                      Locale('sv')
                    ],
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    scaffoldMessengerKey: snackBarKey,
                    builder: (context, child) {
                      ScreenUtil.init(context);
                      final mediaQueryData = MediaQuery.of(context);

                      // Calculate the scaled text factor using the clamp function to ensure it stays within a specified range.
                      final scale = mediaQueryData.textScaler.clamp(
                        minScaleFactor: 0.8, // Minimum scale factor allowed.
                        maxScaleFactor: 1.3, // Maximum scale factor allowed.
                      );
                      return MediaQuery(
                          data: mediaQueryData.copyWith(
                            textScaler: scale
                          ),
                          child: child!);
                    },
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
