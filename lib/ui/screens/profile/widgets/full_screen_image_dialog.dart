import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullScreenImageDialog extends StatelessWidget {
  final ImageProvider imageProvider;
  final String? imageUrl;
  final Uint8List? uint8Listtype;
  const FullScreenImageDialog(
      {super.key,
      required this.imageProvider,
      required this.imageUrl,
      this.uint8Listtype});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: (imageUrl!.startsWith('/'))
          ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imageUrl!),
                  fit: BoxFit.fill,
                ),
              ),
            )
          : Center(
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 0.8,
                maxScale: 5.0,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: uint8Listtype != null
                      ? Image.memory(
                          uint8Listtype!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Image not available',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        )
                      : Image(
                          image: imageProvider,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Image not available',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
    );
  }
}
