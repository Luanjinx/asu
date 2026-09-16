import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/person/person_detail_screen.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';

import '../../../../components/cached_image_widget.dart';

class PersonCard extends StatelessWidget {
  final Cast castData;
  final double? height;
  final double? width;

  final VoidCallback? onNavigated;

  const PersonCard({
    super.key,
    required this.castData,
    this.height,
    this.width,
    this.onNavigated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onNavigated?.call();
        Get.to(() => PersonDetailScreen(personDet: castData), arguments: ArgumentModel(stringArgument: "${ApiRequestKeys.idKey}=${castData.id}&${ApiRequestKeys.typeKey}=${castData.designation}"));
      },
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Hero(
            tag: '${castData.designation}_${castData.profileImage}',
            child: CachedImageWidget(
              url: castData.profileImage,
              height: height ?? Get.height * 0.12,
              width: width ?? Get.width / 4 - 8,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              radius: 6,
              firstName: castData.name,
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              height: height ?? Get.height * 0.12,
              width: width ?? Get.width / 4 - 8,
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    black.withValues(alpha: 0.0),
                    black.withValues(alpha: 0.1),
                    black.withValues(alpha: 0.5),
                    black.withValues(alpha: 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 8,
            start: 2,
            end: 2,
            child: Text(
              castData.name,
              style: boldTextStyle(size: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}