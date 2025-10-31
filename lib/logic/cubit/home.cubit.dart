import 'package:spacex_app/data/models/launch.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/launch.service.dart';

class HomeState {
  final List<LaunchModel> launches;
  final bool isLoading;
  final bool hasError;

  HomeState({
    required this.launches,
    this.isLoading = false,
    this.hasError = false,
  });

  HomeState copyWith({
    List<LaunchModel>? launches,
    bool? isLoading,
    bool? hasError,
  }) {
    return HomeState(
      launches: launches ?? this.launches,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  final _service = LaunchService.instance;
  HomeCubit() : super(HomeState(launches: []));

  Future<void> fetchLaunches() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      final launches = await _service.fetchAllLaunches();
      emit(state.copyWith(
        launches: launches,
      ));
    } catch (e) {
      print('error fetching launches: $e');
      emit(state.copyWith(hasError: true));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> refreshLaunches() async {
    emit(HomeState(launches: []));
    await fetchLaunches();
  }
}