import 'dart:io';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LocaleSelectionCubit extends HydratedCubit<String>{
  LocaleSelectionCubit() : super(Platform.localeName);


  void updateLocale(String locale) {
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