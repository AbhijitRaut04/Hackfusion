import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ComplaintCard extends StatelessWidget {
  final String subject;
  final String desc;
  final List<String> to;
  final List<String> attachments;

  const ComplaintCard({
    super.key,
    required this.subject,
    required this.desc,
    required this.to,
    required this.attachments,
  });

  bool isImage(String url) {
    return url.endsWith(".jpg") ||
        url.endsWith(".jpeg") ||
        url.endsWith(".png") ||
        url.endsWith(".gif");
  }

  bool isVideo(String url) {
    return url.endsWith(".mp4") ||
        url.endsWith(".mov") ||
        url.endsWith(".avi") ||
        url.endsWith(".mkv");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject
            Text(
              subject,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Description
            Text(
              desc,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Complained To (Recipients)
            if (to.isNotEmpty)
              Wrap(
                spacing: 6,
                children: to
                    .map((recipient) => Chip(
                  label: Text(recipient),
                  backgroundColor: Colors.blue.shade100,
                ))
                    .toList(),
              ),

            const SizedBox(height: 8),

            // Attachments Section
            if (attachments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attachments:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  // Scrollable attachment preview
                  SizedBox(
                    height: 100, // Fixed height for media previews
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: attachments.length,
                      itemBuilder: (context, index) {
                        String url = attachments[index];

                        if (isImage(url)) {
                          // Show Image
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                url,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                          );
                        } else if (isVideo(url)) {
                          // Show Video
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: VideoThumbnail(url: url),
                          );
                        } else {
                          // Show Default File Icon
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.insert_drive_file, size: 50),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Widget to show video thumbnail
class VideoThumbnail extends StatefulWidget {
  final String url;

  const VideoThumbnail({super.key, required this.url});

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Refresh UI after initialization
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
        ],
      ),
    )
        : const SizedBox(width: 100, height: 100, child: Center(child: CircularProgressIndicator()));
  }
}
