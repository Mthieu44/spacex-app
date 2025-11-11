import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import '../../logic/cubit/launch.cubit.dart';
import '../pages/detail.page.dart';

class LaunchItemWidget extends StatelessWidget {
  final LaunchModel launch;
  const LaunchItemWidget({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: launch.upcoming ? Colors.indigo.withAlpha(54)
              : (launch.success ? Colors.green.withAlpha(54)
              : Colors.red.withAlpha(54) ),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white12, width: 0.5)
        ),
        child: InkWell(
          onTap: () {
            final launchCubit = context.read<LaunchCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  launch: launch,
                  launchCubit: launchCubit,
                )
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'launch-patch-${launch.id}',
                  child: Image.network(
                    launch.links.patch,
                    width: 56,
                    height: 56,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 56,
                        height: 56,
                        color: Colors.transparent,
                        child: Icon(Icons.image_not_supported),
                      );
                    }
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        launch.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${launch.formattedDate}, ${launch.formattedTime}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}