import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/models/launch.model.dart';

import '../../logic/cubit/launch.cubit.dart';
import '../../logic/cubit/onboarding.cubit.dart';
import '../pages/detail.page.dart';

class LaunchCardWidget extends StatelessWidget {
  final LaunchModel launch;
  const LaunchCardWidget({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
          decoration: BoxDecoration(
              color: launch.upcoming ? Colors.indigo.withAlpha(40)
                  : (launch.success ? Colors.green.withAlpha(40)
                  : Colors.red.withAlpha(40) ),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white12, width: 0.5)
          ),
        child: InkWell(
          onTap: () {
            final launchCubit = context.read<LaunchCubit>();
            final onboardingCubit = context.read<OnboardingCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider.value(
                    value: onboardingCubit,
                    child: DetailPage(
                      launch: launch,
                      launchCubit: launchCubit,
                    ),
                  );
                }
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'launch-patch-${launch.id}',
                  child: Image.network(
                    launch.links.patch,
                    width: 92,
                    height: 92,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 92,
                        height: 92,
                        color: Colors.transparent,
                        child: Icon(Icons.image_not_supported),
                      );
                    }
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  launch.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  launch.formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  launch.formattedTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            )
          )
        )
      )
    );
  }
}