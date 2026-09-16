import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../utils/colors.dart';

class PopularSearchesComponent extends StatelessWidget {
  const PopularSearchesComponent({super.key, required this.searchCont});

  final SearchScreenController searchCont;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (searchCont.isLoadingPopularSearches.value || searchCont.popularSearchList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.value.popularSearches, style: boldTextStyle(size: 16)),
            12.height,
            AnimatedWrap(
              spacing: 8,
              runSpacing: 8,
              listAnimationType: commonListAnimationType,
              children: searchCont.popularSearchList.take(5).map((searchTerm) {
                return TextIcon(
                  onTap: () {
                    searchCont.searchCont.text = searchTerm;
                    searchCont.onSearch();
                  },
                  spacing: 8,
                  prefix: IconWidget(
                    imgPath: Assets.iconsMagnifyingGlass,
                    color: iconColor,
                  ),
                  text: searchTerm,
                  textStyle: commonPrimaryTextStyle(size: 14),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}