import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingType { home, detail }

class OnboardingState {
  final OnboardingType type;
  final Map<OnboardingType, bool> completed;
  final int currentStep;
  OnboardingState({
    required this.type,
    required this.completed,
    required this.currentStep,
  });

  bool get isCompleted => completed[type] == true;

  OnboardingState copyWith({
    OnboardingType? type,
    Map<OnboardingType, bool>? completed,
    int? currentStep,
  }) {
    return OnboardingState(
      type: type ?? this.type,
      completed: completed ?? this.completed,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit()
      : super(OnboardingState(
          type: OnboardingType.home,
          completed: {
            OnboardingType.home: false,
            OnboardingType.detail: false,
          },
          currentStep: 0,
        ));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final homeDone = prefs.getBool("onboarding_home_done") ?? false;
    final detailDone = prefs.getBool("onboarding_detail_done") ?? false;
    emit(state.copyWith(completed: {
      OnboardingType.home: homeDone,
      OnboardingType.detail: detailDone,
    }));
  }

  void startOnboarding(OnboardingType type) {
    if (state.completed[type] == true) return;
    emit(state.copyWith(type: type, currentStep: 0));
  }

  void nextStep(int totalSteps) async {
    if (state.currentStep + 1 >= totalSteps) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("onboarding_${state.type.name}_done", true);
      emit(state.copyWith(
        completed: {
          ...state.completed,
          state.type: true,
        },
        currentStep: 0,
      ));
    } else {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding_home_done", false);
    await prefs.setBool("onboarding_detail_done", false);
    emit(state.copyWith(completed: {
      OnboardingType.home: false,
      OnboardingType.detail: false,
    }, currentStep: 0));
  }
}