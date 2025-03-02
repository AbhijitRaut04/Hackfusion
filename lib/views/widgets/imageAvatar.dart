import 'dart:io';
import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  const ImageAvatar({super.key, required this.radius, this.url, this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(file!=null)
          CircleAvatar(
            backgroundImage: FileImage(file!),
            radius: radius,
          )
        else if (url != null && url!.isNotEmpty)
          CircleAvatar(
            backgroundImage: NetworkImage(url!),
            radius: radius,
          )
        else
          CircleAvatar(
            backgroundImage: const AssetImage("assets/images/avatar.jpg"),
            radius: radius,
          )
      ],
    );
  }
}
