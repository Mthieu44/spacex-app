import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LaunchCardSkeleton extends StatelessWidget {
  const LaunchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white12, width: 0.5)
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade700,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                )
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(64.0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(64.0),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 80,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(64.0),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}