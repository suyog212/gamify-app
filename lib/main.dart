import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kGamify/blocs/championship_analytics_cubit.dart';
import 'package:kGamify/blocs/championships_details_bloc.dart';
import 'package:kGamify/blocs/email_verification_bloc.dart';
import 'package:kGamify/blocs/internet_cubit.dart';
import 'package:kGamify/blocs/question_analytics_cubit.dart';
import 'package:kGamify/blocs/question_bloc.dart';
import 'package:kGamify/blocs/question_view_cubit.dart';
import 'package:kGamify/blocs/theme_cubit.dart';
import 'package:kGamify/blocs/user_image_bloc.dart';
import 'package:kGamify/generated/l10n.dart';
import 'package:kGamify/on_boarding/utils/OTP_verifcation_bloc.dart';
import 'package:kGamify/on_boarding/utils/auth_cubit.dart';
import 'package:kGamify/on_boarding/utils/forgot_password_cubit.dart';
import 'package:kGamify/on_boarding/utils/language_bloc.dart';
import 'package:kGamify/on_boarding/utils/locale_selection_cubit.dart';
import 'package:kGamify/on_boarding/utils/otp_cubit.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/router.dart';
import 'package:kGamify/utils/themes.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: 'encryptionKey');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'encryptionKey', value: base64UrlEncode(key));
  }

  var encryptionKey = base64Url.decode(await secureStorage.read(key: 'encryptionKey') ?? "");
  await ScreenUtil.ensureScreenSize();
  await Hive.initFlutter();
  await Hive.openBox(userDataDB, encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox(quizDataDB, encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox(qualificationDataDB, encryptionCipher: HiveAesCipher(encryptionKey));
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initMixpanel();
    if (mixpanel != null) {
      if (Hive.box(userDataDB).get("personalInfo", defaultValue: null) == null) {
        mixpanel!.track("NewUserOpenedApp", properties: {"OSType": Platform.operatingSystem, "TimeStamp": DateTime.now().toString()});
      } else {
        mixpanel!.track("AppOpened", properties: {"UserId": Hive.box(userDataDB).get("personalInfo")['user_id'], "TimeStamp": DateTime.now().toString()});
      }
    }
  }

  // This widget is the root of your application.
  AppTheme appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LocaleSelectionCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => InternetCubit(),
        ),
        BlocProvider(
          create: (context) => ChampionshipsBloc(),
        ),
        BlocProvider(
          create: (context) => QuestionsBloc(),
        ),
        BlocProvider(
          create: (context) => QuestionViewCubit(),
        ),
        BlocProvider(
          create: (context) => ChampionshipAnalyticsCubit(),
        ),
        BlocProvider(
          create: (context) => QuestionAnalyticsCubit(),
        ),
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => UserDataBloc(),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordCubit(),
        ),
        BlocProvider(
          create: (context) => EmailVerificationBloc(),
        ),
        BlocProvider(
          create: (context) => OTPVerificationCubit(),
        ),
        BlocProvider(
          create: (context) => OtpCubit(),
        )
      ],
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, state) {
          return MaterialApp.router(
            showSemanticsDebugger: false,
            routerConfig: AppRouter().router,
            title: 'kGamify',
            theme: appTheme.lightTheme,
            darkTheme: appTheme.darkTheme,
            locale: Locale(context.watch<LocaleSelectionCubit>().state),
            themeMode: context.watch<ThemeCubit>().state,
            supportedLocales: const [Locale('en'), Locale('da'), Locale('de'), Locale('hi'), Locale('sv')],
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
              return MediaQuery(data: mediaQueryData.copyWith(textScaler: scale), child: child!);
            },
          );
        },
      ),
    );
  }
}
