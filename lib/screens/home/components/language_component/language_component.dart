import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/filtered_content_list_screen.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../../components/shimmer_widget.dart';
import 'language_list_screen.dart';

class LanguageComponent extends StatelessWidget {
  final CategoryListModel languageDetails;
  final bool isLoading;

  const LanguageComponent({super.key, required this.languageDetails, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (languageDetails.data.isEmpty) return const SizedBox.shrink();
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewAllWidget(
          label: languageDetails.name.capitalizeEachWord(),
          showViewAll: true,
          onButtonPressed: () {
            Get.to(
              () => LanguageListScreen(
                languageList: languageDetails.data as List<LanguageModel>,
                title: languageDetails.name.capitalizeEachWord(),
              ),
            );
          },
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          spacing: dynamicSpacing.$2,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: languageDetails.data.length,
          itemBuilder: (context, index) {
            LanguageModel language = languageDetails.data[index];
            if (isLoading) {
              return ShimmerWidget(
                height: 60,
                width: dynamicSpacing.$1,
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Get.to(() => FilteredContentListScreen(title: language.name), arguments: ArgumentModel(stringArgument: '${ApiRequestKeys.language}=${language.name}', intArgument: 1));
                },
                child: Hero(
                  tag: 'language_${language.id}',
                  child: CachedImageWidget(
                    url: language.languageImage,
                    height: 120,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    radius: 6,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}