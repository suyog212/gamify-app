import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:restart_app/restart_app.dart';

class LocaleSelectionCubit extends HydratedCubit<String>{
  LocaleSelectionCubit() : super("en");


  void updateLocale(String locale) {
    emit(locale);
    Restart.restartApp();
  }
  void updateLocaleOnStartup(String locale) {
    mixpanel!.track("ChangedLanguage",properties: {
      "locale": locale,
      "timeStamp": DateTime.now(),
      "userId" : Hive.box(userDataDB).get("personalInfo")['user_id']
    });
    emit(locale);
  }

  @override
  String? fromJson(Map<String, dynamic> json) {
    final locale = json['locale'];
    return locale;
  }

  @override
  Map<String, dynamic>? toJson(String state) {
    return {
      'locale': state.toString(),
    };
  }
}