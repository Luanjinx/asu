import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/genres/genres_details/genres_details_screen.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../genres/model/genres_model.dart';

class GenresCard extends StatelessWidget {
  final GenreModel genresData;
  final double? height;
  final double? width;

  const GenresCard({super.key, required this.genresData, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GenresDetailsScreen(genreDetails: genresData), arguments: ArgumentModel(stringArgument: '${ApiRequestKeys.genreId}=${genresData.id}'));
      },
      child: Stack(
        children: [
          Hero(
            tag: 'genre_${genresData.poster}',
            child: CachedImageWidget(
              url: genresData.poster,
              height: height ?? Get.height * 0.12,
              width: width ?? Get.width / 4 - 8,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              radius: 6,
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
                    black.withValues(alpha: 0.2),
                    black.withValues(alpha: 0.5),
                    black.withValues(alpha: 0.9),
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
              genresData.name,
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