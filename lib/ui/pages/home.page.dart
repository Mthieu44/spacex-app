import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/logic/cubit/launch.cubit.dart';
import 'package:spacex_app/logic/cubit/view.cubit.dart';
import 'package:spacex_app/ui/skeletons/launch_item.skeleton.dart';
import 'package:spacex_app/ui/widgets/launch_card.widget.dart';
import 'package:spacex_app/ui/widgets/launch_item.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _getItemCount(LaunchState state, List launches) {
    if (state.isLoading && state.launches.isEmpty) {
      return 20;
    } else if (state.isLoading) {
      return launches.length + 1;
    } else {
      return launches.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
        actions: [
          BlocBuilder<ViewCubit, ViewState>(
            builder: (context, viewState) {
              return IconButton(
                icon: Icon(
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
                onRefresh: () => context.read<LaunchCubit>().refreshLaunches(),
                child: viewState.currentView == Views.list ?
                  _buildListView(launches, itemCount) :
                  _buildGridView(launches, itemCount),
              );
            },
          );
        },
      )
    );
  }

  Widget _buildListView(List launches, int itemCount) {
    return ListView.builder(
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
          return const LaunchItemSkeleton();
        }
        final launch = launches[index];
        return LaunchCardWidget(launch: launch);
      },
    );
  }
}