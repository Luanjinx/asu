import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../model/live_tv_dashboard_response.dart';
import 'live_horizontal_list.dart';

class LiveCategoryListComponent extends StatelessWidget {
  final List<CategoryData> liveCategoryList;

  const LiveCategoryListComponent({super.key, required this.liveCategoryList});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();
    return AnimatedWrap(
      runSpacing: dynamicSpacing.$2,
      spacing: dynamicSpacing.$2,
      listAnimationType: commonListAnimationType,
      itemCount: liveCategoryList.length,
      itemBuilder: (context, index) {
        CategoryData category = liveCategoryList[index];
        return LiveHorizontalComponent(channelData: category);
      },
    );
  }
}