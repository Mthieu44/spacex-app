import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/logic/cubit/launch.cubit.dart';
import 'package:spacex_app/logic/cubit/onboarding.cubit.dart';
import 'package:spacex_app/logic/cubit/view.cubit.dart';
import 'package:spacex_app/ui/skeletons/launch_card.skeleton.dart';
import 'package:spacex_app/ui/skeletons/launch_item.skeleton.dart';
import 'package:spacex_app/ui/widgets/launch_card.widget.dart';
import 'package:spacex_app/ui/widgets/launch_item.widget.dart';
import 'package:spacex_app/ui/widgets/night_sky_background.widget.dart';
import 'package:spacex_app/ui/widgets/onboarding.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _favoritesButtonKey = GlobalKey();
  final GlobalKey _viewToggleButtonKey = GlobalKey();

  int _getItemCount(LaunchState state, List launches) {
    if (state.isLoading && state.launches.isEmpty) {
      return 20;
    } else {
      return launches.length;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().startOnboarding(OnboardingType.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NightSkyBackground(
      scrollController: _scrollController,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('SpaceX Launches'),
              actions: [
                BlocBuilder<ViewCubit, ViewState>(
                  builder: (context, viewState) {
                    return IconButton(
                      icon: Icon(
                        key: _favoritesButtonKey,
                        viewState.favoritesOnly ? Icons.favorite : Icons.favorite_border,
                        color: viewState.favoritesOnly ? Colors.red : null,
                      ),
                      onPressed: () => context.read<ViewCubit>().toggleFavorites(),
                    );
                  }
                ),
                BlocBuilder<ViewCubit, ViewState>(
                  builder: (context, viewState) {
                    return IconButton(
                      icon: Icon(
                        key: _viewToggleButtonKey,
                        viewState.currentView == Views.list ? Icons.grid_view : Icons.view_list
                      ),
                      onPressed: () => context.read<ViewCubit>().toggleView(),
                    );
                  }
                ),
              ],
            ),

            body: BlocBuilder<LaunchCubit, LaunchState>(
              builder: (context, launchState) {
                return BlocBuilder<ViewCubit, ViewState>(
                  builder: (context, viewState) {
                    final launches = viewState.favoritesOnly ?
                      launchState.launches.where((launch) => launch.favorite).toList() :
                      launchState.launches;
                    final itemCount = _getItemCount(launchState, launches);

                    return RefreshIndicator(
                      onRefresh: () async{
                        context.read<LaunchCubit>().fetchLaunches();
                      },
                      child: viewState.currentView == Views.list ?
                        _buildListView(launches, itemCount) :
                        _buildGridView(launches, itemCount),
                    );
                  },
                );
              },
            )
          ),
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, onboardingState) {
              if (onboardingState.type != OnboardingType.home ||
                  onboardingState.completed[OnboardingType.home] == true) {
                return const SizedBox.shrink();
              }
              return OnboardingWidget(
                globalKeys: {
                  'favoritesButtonKey': _favoritesButtonKey,
                  'viewToggleButtonKey': _viewToggleButtonKey,
                },
                type: OnboardingType.home,
                currentStepIndex: onboardingState.currentStep,
                onNextStep: () => context.read<OnboardingCubit>().nextStep(5)
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildListView(List launches, int itemCount) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: itemCount,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index >= launches.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: const LaunchItemSkeleton(),
          );
        }
        final launch = launches[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: LaunchItemWidget(launch: launch)
        );
      },
    );
  }

  Widget _buildGridView(List launches, int itemCount) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: itemCount,
      padding: const EdgeInsets.all(6),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index >= launches.length) {
          return const LaunchCardSkeleton();
        }
        final launch = launches[index];
        return LaunchCardWidget(launch: launch);
      },
    );
  }
}