import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import '../../data/api/launch.service.dart';

class LaunchState {
  final List<LaunchModel> launches;
  final bool isLoading;
  final bool hasError;

  LaunchState({
    required this.launches,
    this.isLoading = false,
    this.hasError = false,
  });

  LaunchState copyWith({
    List<LaunchModel>? launches,
    bool? isLoading,
    bool? hasError,
  }) {
    return LaunchState(
      launches: launches ?? this.launches,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'launches': launches.map((launch) => launch.toJson()).toList(),
      'isLoading': isLoading,
      'hasError': hasError,
    };
  }

  factory LaunchState.fromJson(Map<String, dynamic> json) {
    final launchesJson = json['launches'] as List<dynamic>? ?? [];
    final launches = launchesJson
        .map((launchJson) => LaunchModel.fromJson(launchJson as Map<String, dynamic>))
        .toList();
    return LaunchState(
      launches: launches,
      isLoading: json['isLoading'] as bool? ?? false,
      hasError: json['hasError'] as bool? ?? false,
    );
  }
}

class LaunchCubit extends HydratedCubit<LaunchState> {
  final _service = LaunchService.instance;
  LaunchCubit() : super(LaunchState(launches: []));

  Future<void> fetchLaunches() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      final launches = await _service.fetchAllLaunches();

      final syncedLaunches = launches.map((launch) {
        final existingLaunch = state.launches.firstWhere(
          (l) => l.id == launch.id,
          orElse: () => launch,
        );
        launch.favorite = existingLaunch.favorite;
        return launch;
      }).toList();
      emit(state.copyWith(
        launches: syncedLaunches
      ));
    } catch (e) {
      emit(state.copyWith(hasError: true));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void toggleFavorite(LaunchModel launch) {
    final updatedLaunches = state.launches.map((l) {
      if (l.id == launch.id) {
        l.favorite = !l.favorite;
      }
      return l;
    }).toList();
    emit(state.copyWith(launches: updatedLaunches));
  }

  @override
  LaunchState? fromJson(Map<String, dynamic> json) {
    return LaunchState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LaunchState state) {
    return state.toJson();
  }
}