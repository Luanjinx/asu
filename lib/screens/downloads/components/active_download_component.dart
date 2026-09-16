import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/services/download_manager.dart';
import 'package:streamit_laravel/utils/colors.dart';

class ActiveDownloadComponent extends StatelessWidget {
  final DownloadState state;
  final Function(String title, String type) onCancel;

  const ActiveDownloadComponent({
    super.key,
    required this.state,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (state.item == null) return const SizedBox.shrink();

    final item = state.item!;
    ContentModel? contentModel;

    try {
      final dynamic decoded = jsonDecode(item.contentData);
      dynamic root = decoded;
      if (decoded is Map<String, dynamic>) {
        // Handle wrapped structure if necessary, similar to controller logic
        // For now, assuming standard structure or trying 'data'
        if (decoded.containsKey('data') && decoded['data'] is Map) {
          final data = decoded['data'];
          if (data.isNotEmpty) root = data;
        }
      }
      contentModel = ContentModel.fromContentJson(root);
    } catch (e) {
      log('Error parsing active download content: $e');
    }

    final title = contentModel?.details.name ?? locale.value.downloading;

    // Calculate progress as 0-1
    final progressValue = state.progress / 100.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(6)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.thumbnailImage.isNotEmpty)
                CachedImageWidget(
                  url: item.thumbnailImage,
                  width: 110,
                  height: 62,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRectOnly(topLeft: 6).paddingAll(0), // removed paddingAll(8) to flush or keep consistent

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: boldTextStyle(size: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                  8.height,
                  Text('${state.progress.toInt()}%', style: secondaryTextStyle(size: 12)),
                ],
              ).paddingSymmetric(horizontal: 12, vertical: 8).expand(),

              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  onCancel(title, contentModel?.details.type ?? 'content');
                },
              ),
            ],
          ),
          LinearProgressIndicator(
            value: progressValue.clamp(0.0, 1.0),
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(appColorPrimary),
            minHeight: 2,
          ).cornerRadiusWithClipRRectOnly(bottomLeft: 6, bottomRight: 6),
        ],
      ),
    );
  }
}