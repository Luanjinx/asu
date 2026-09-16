import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';

import '../../../main.dart';
import '../../home/model/dashboard_res_model.dart';

class EmptySearchListComponent extends StatelessWidget {
  final CategoryListModel sectionCategoryData;

  const EmptySearchListComponent({super.key, required this.sectionCategoryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.value.popularMovies,
          style: boldTextStyle(),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sectionCategoryData.data.map(
            (e) {
              return ContentListComponent(contentData: e);
            },
          ).toList(),
        ),
      ],
    );
  }
}