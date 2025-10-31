import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/logic/cubit/home.cubit.dart';
import 'package:spacex_app/ui/skeletons/launch_item.skeleton.dart';
import 'package:spacex_app/ui/widgets/launch_item.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _getItemCount(HomeState state) {
    if (state.isLoading && state.launches.isEmpty) {
      return 20;
    } else if (state.isLoading) {
      return state.launches.length + 1;
    } else {
      return state.launches.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final launches = state.launches;

          return RefreshIndicator(
            onRefresh: () async => context.read<HomeCubit>().refreshLaunches(),
            child: ListView.builder(
              itemCount: _getItemCount(state),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index < launches.length) {
                  final launch = launches[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: LaunchItemWidget(launch: launch),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: LaunchItemSkeleton(),
                  );
                }
              }
            )
          );
        },
      ),
    );
  }
}