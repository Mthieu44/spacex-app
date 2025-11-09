import 'package:flutter/material.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/ui/widgets/link_bubble.widget.dart';

class DetailPage extends StatefulWidget {
  final LaunchModel launch;
  const DetailPage({super.key, required this.launch});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.launch.favorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.launch.favorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            stretch: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: Hero(
                  tag: 'launch-patch-${widget.launch.id}',
                  child: Image.network(
                    widget.launch.links.patch,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.transparent,
                        child: Icon(Icons.image_not_supported),
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.launch.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: 8),
                  Text('Date: ${widget.launch.formattedDate}'),
                  Text('Time: ${widget.launch.formattedTime}'),
                  SizedBox(height: 8),
                  Text('Details: ${widget.launch.details}'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Launch Status: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Icon(
                        widget.launch.upcoming ? Icons.rocket_launch : (widget.launch.success ? Icons.check_circle : Icons.cancel),
                        color: widget.launch.upcoming ? Colors.blue : (widget.launch.success ? Colors.green : Colors.red)
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.launch.upcoming ? 'Upcoming' : (widget.launch.success ? 'Success' : 'Failure'),
                        style: TextStyle(
                          color: widget.launch.upcoming ? Colors.blue : (widget.launch.success ? Colors.green : Colors.red)
                        )
                      )
                    ],
                  ),
                  // reasons if failure
                  if (!widget.launch.success && widget.launch.failures.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      'Reasons:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                    ...widget.launch.failures.map((failure) => Text('• $failure')),
                  ],
                  SizedBox(height: 12),
                  Text(
                      'Links : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Row(
                    children: [
                      LinkBubbleWidget(
                        label: 'Article',
                        url: widget.launch.links.article,
                        icon: Icons.article,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4),
                      LinkBubbleWidget(
                        label: 'Wikipedia',
                        url: widget.launch.links.wikipedia,
                        icon: Icons.book,
                        color: Colors.green,
                      ),
                      SizedBox(width: 4),
                      LinkBubbleWidget(
                        label: 'Webcast',
                        url: widget.launch.links.webcast,
                        icon: Icons.video_library,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                ],
              ),
            ),
          )
        ],
      )
    );
  }
}