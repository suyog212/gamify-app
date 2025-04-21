import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kGamify/models/championship_details_model.dart';
import 'package:kGamify/repositories/championship_repository.dart';

abstract class ChampionshipsStates {}

class CategoriesLoadingState extends ChampionshipsStates {}

class CategoriesLoadedState extends ChampionshipsStates {
  final List<ChampionshipsModel> models;
  CategoriesLoadedState(this.models);
}

class CategoriesErrorState extends ChampionshipsStates {
  final String error;
  CategoriesErrorState(this.error);
}

class ChampionshipsBloc extends Cubit<ChampionshipsStates> {
  ChampionshipsBloc() : super(CategoriesLoadingState()) {
    getCategories();
  }

  final ChampionshipRepository _categoriesRepository = ChampionshipRepository();
  late List<ChampionshipsModel> models;

  void getCategories() async {
    try {
      models = await _categoriesRepository.fetchCategory();
      if (models.isEmpty) {
        emit(CategoriesErrorState("No championships found"));
      } else {
        sortChampionships("Date");
      }
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void retryFetching() async {
    try {
      emit(CategoriesLoadingState());
      models = await _categoriesRepository.fetchCategory();
      emit(CategoriesLoadedState(models));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void refreshCategories() async {
    try {
      emit(CategoriesLoadingState());
      models = await _categoriesRepository.fetchCategory();
      emit(CategoriesLoadedState(models));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void searchChampionship(String query) {
    emit(CategoriesLoadedState(models
        .where(
          (element) =>
              element.champName!.toLowerCase().contains(query) ||
              element.categoryName!.toLowerCase().contains(query) ||
              element.championshipDetails!.any(
                (details) => details.uniqueId?.contains(query) ?? false,
              ),
        )
        .toList()));
  }

  void showFilteredChamps(List<String> filters) {
    emit(CategoriesLoadedState(filterChampionshipsByModeName(models, filters)));
  }

  List<ChampionshipsModel> filterChampionshipsByModeName(List<ChampionshipsModel> championships, List<String> selectedModeNames) {
    if (selectedModeNames.isNotEmpty) {
      return championships
          .where((championship) => selectedModeNames.any((modeName) => championship.championshipDetails?.any((details) => details.modeName?.toLowerCase() == modeName.toLowerCase()) ?? false))
          .toList();
    } else {
      return models;
    }
  }

  void sortChampionships(String sortBy) {
    switch (sortBy) {
      case "A-Z":
        {
          models.sort(
            (a, b) {
              return a.champName!.compareTo(b.champName!);
            },
          );
          emit(CategoriesLoadedState(models));
        }
      case "Date":
        {
          models.sort(
            (a, b) {
              return DateTime.parse("${a.startDate} ${a.startTime}").compareTo(DateTime.parse("${b.startDate} ${b.startTime}"));
            },
          );
          emit(CategoriesLoadedState(models));
        }
      case "Status":
        {
          models.sort(
            (a, b) {
              final aFormattedStartDate = DateTime.parse("${a.startDate} ${a.startTime}");
              final bFormattedStartDate = DateTime.parse("${b.startDate} ${b.startTime}");
              return aFormattedStartDate.compareTo(bFormattedStartDate);
            },
          );
          emit(CategoriesLoadedState(models.reversed.toList()));
        }
    }
  }
}
