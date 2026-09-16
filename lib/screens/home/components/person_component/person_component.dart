import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../../components/shimmer_widget.dart';
import '../../../person/person_list/person_list_screen.dart';
import 'person_card.dart';

class PersonComponent extends StatelessWidget {
  final CategoryListModel personDetails;

  final bool isLoading;

  final bool showViewAll;

  const PersonComponent({
    super.key,
    required this.personDetails,
    this.isLoading = false,
    this.showViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    if (personDetails.data.isEmpty) return const SizedBox.shrink();
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewAllWidget(
          showViewAll: showViewAll,
          label: personDetails.name,
          onButtonPressed: () {
            Get.to(() => PersonListScreen(title: personDetails.name.validate()));
          },
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          spacing: dynamicSpacing.$2,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: personDetails.data.length,
          itemBuilder: (context, index) {
            final Cast cast = personDetails.data[index];
            if (isLoading) {
              return ShimmerWidget(
                width: dynamicSpacing.$1,
                height: dynamicSpacing.$1,
              ).cornerRadiusWithClipRRect(6);
            } else {
              return PersonCard(
                castData: cast,
                width: dynamicSpacing.$1,
                height: dynamicSpacing.$1,
              );
            }
          },
        ),
      ],
    );
  }
}