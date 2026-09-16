import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../components/cached_image_widget.dart';

class PersonProfileWidget extends StatelessWidget {
  final Cast personDetail;

  const PersonProfileWidget({super.key, required this.personDetail});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Hero(
          tag: '${personDetail.designation}_${personDetail.profileImage}',
          child: CachedImageWidget(
            url: personDetail.profileImage,
            height: Get.height * 0.6,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: Get.height * 0.65,
            width: double.infinity,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 0.65, 1.0],
                colors: [
                  appScreenBackgroundDark.withValues(alpha: 0.05),
                  appScreenBackgroundDark.withValues(alpha: 0.45),
                  appScreenBackgroundDark.withValues(alpha: 0.8),
                  appScreenBackgroundDark,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}