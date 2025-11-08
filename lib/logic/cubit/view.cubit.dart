import 'package:flutter_bloc/flutter_bloc.dart';

enum Views {list, grid}

class ViewState {
  final Views currentView;
  final bool favoritesOnly;

  const ViewState({
    this.currentView = Views.list,
    this.favoritesOnly = false,
  });

  ViewState copyWith({
    Views? currentView,
    bool? favoritesOnly,
  }) {
    return ViewState(
      currentView: currentView ?? this.currentView,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

class ViewCubit extends Cubit<ViewState> {
  ViewCubit() : super(const ViewState());

  void toggleView() {
    final newView = state.currentView == Views.list ? Views.grid : Views.list;
    emit(state.copyWith(currentView: newView));
  }

  void toggleFavorites() {
    emit(state.copyWith(favoritesOnly: !state.favoritesOnly));
  }
}