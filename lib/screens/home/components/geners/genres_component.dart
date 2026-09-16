import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../../components/shimmer_widget.dart';
import '../../../genres/genres_list_screen.dart';
import '../../../genres/model/genres_model.dart';
import 'genres_card.dart';

class GenreComponent extends StatelessWidget {
  final CategoryListModel genresDetails;
  final bool isLoading;

  const GenreComponent({super.key, required this.genresDetails, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (genresDetails.data.isEmpty) return const SizedBox.shrink();
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: genresDetails.name,
          showViewAll: genresDetails.showViewAll,
          onButtonPressed: () {
            Get.to(() => GenresListScreen(title: genresDetails.name));
          },
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          runSpacing: 10,
          spacing: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: genresDetails.data.length,
          itemBuilder: (context, index) {
            final GenreModel genre = genresDetails.data[index];

            if (isLoading) {
              return ShimmerWidget(
                width: dynamicCardsDimensions.$1,
                height: dynamicCardsDimensions.$1,
              ).cornerRadiusWithClipRRect(6);
            }
            return GenresCard(
              genresData: genre,
              height: dynamicCardsDimensions.$1,
              width: dynamicCardsDimensions.$1,
            );
          },
        ),
      ],
    );
  }
}