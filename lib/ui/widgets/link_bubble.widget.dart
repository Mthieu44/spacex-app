import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkBubbleWidget extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;
  final Color color;

  const LinkBubbleWidget({
    super.key,
    required this.label,
    required this.url,
    this.icon = Icons.link,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: color),
      ),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.0, color: color),
              SizedBox(width: 4.0),
              Text(
                label,
                style: TextStyle(
                  color: color,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}