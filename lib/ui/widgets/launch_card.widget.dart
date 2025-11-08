import 'package:flutter/material.dart';
import 'package:spacex_app/data/models/launch.model.dart';

class LaunchCardWidget extends StatelessWidget {
  final LaunchModel launch;
  const LaunchCardWidget({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: launch.success ? Colors.green[100] : Colors.red[100],
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  launch.patchUrl,
                  width: 96,
                  height: 96,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 96,
                      height: 96,
                      color: Colors.grey,
                      child: Icon(Icons.image_not_supported),
                    );
                  }
                ),
                const SizedBox(height: 8),
                Text(
                  launch.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  launch.formattedDate,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  launch.formattedTime,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          )
        )
      )
    );
  }
}