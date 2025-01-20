import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kGamify/utils/constants.dart';
import 'package:kGamify/utils/router.dart';

abstract class UserImageStates {}

class UserImageNotSet extends UserImageStates {}

class UserImageSet extends UserImageStates {
  final Uint8List image;
  UserImageSet(this.image);
}

class UserDataBloc extends Cubit<UserImageStates>{
  UserDataBloc() : super(UserImageNotSet()){
    if(Hive.box(userDataDB).get("UserImage",defaultValue: null) != null){
      emit(UserImageSet(Hive.box(userDataDB).get("UserImage",defaultValue: null)));
    }
  }

  void updateImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      Uint8List rawData = await file.readAsBytes();
      await Hive.box(userDataDB).put("UserImage", rawData);
      emit(UserImageSet(Hive.box(userDataDB).get("UserImage")));
      AppRouter().router?.pop();
    }
  }

  void removeImage() async {
    await Hive.box(userDataDB).put("UserImage", null);
    emit(UserImageNotSet());
    AppRouter().router?.pop();
  }
}