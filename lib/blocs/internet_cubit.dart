import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/utils/constants.dart';

abstract class InternetStates {}

class NoInternetState extends InternetStates {}

class InternetAvailableState extends InternetStates {}

class InternetInitialState extends InternetStates {}

class InternetCubit extends Cubit<InternetStates> {
  InternetCubit() : super(InternetInitialState()) {
    _streamSubscription = _connectivity.onConnectivityChanged.listen(
      (event) {
        if (event.contains(ConnectivityResult.mobile) || event.contains(ConnectivityResult.wifi)) {
          emit(InternetAvailableState());
        } else {
          emit(NoInternetState());
        }
        checkConnection();
      },
    );
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _streamSubscription;

  void checkConnection() {
    if (snackBarKey.currentState != null) {
      if (state is NoInternetState) {
        snackBarKey.currentState?.showMaterialBanner(MaterialBanner(content: const Text("No Internet Connection."), backgroundColor: Colors.redAccent, actions: [
          TextButton(
              onPressed: () {
                checkConnection();
              },
              child: const Text(""))
        ]));
      } else {
        snackBarKey.currentState?.clearMaterialBanners();
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
