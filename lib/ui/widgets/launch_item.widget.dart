import 'package:flutter/material.dart';
import 'package:spacex_app/data/models/launch.model.dart';

class LaunchItemWidget extends StatelessWidget {
  final LaunchModel launch;
  const LaunchItemWidget({super.key, required this.launch});

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
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  launch.patchUrl,
                  width: 56,
                  height: 56,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey,
                      child: Icon(Icons.image_not_supported),
                    );
                  }
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