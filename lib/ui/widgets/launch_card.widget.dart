import 'package:flutter/material.dart';
import 'package:spacex_app/data/models/launch.model.dart';

import '../pages/detail.page.dart';

class LaunchCardWidget extends StatelessWidget {
  final LaunchModel launch;
  const LaunchCardWidget({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: launch.upcoming ? Colors.blue[100] : (launch.success ? Colors.green[100] : Colors.red[100]),
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(launch: launch)
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'launch-patch-${launch.id}',
                  child: Image.network(
                    launch.links.patch,
                    width: 96,
                    height: 96,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 96,
                        height: 96,
                        color: Colors.transparent,
                        child: Icon(Icons.image_not_supported),
                      );
                    }
                  ),
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