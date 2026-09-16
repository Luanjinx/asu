import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/components/person_component/person_card.dart';
import 'package:streamit_laravel/screens/person/person_list/person_list_screen.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class OtherDetailsComponent extends StatelessWidget {
  final ContentModel contentData;

  final VoidCallback onNavigated;

  const OtherDetailsComponent({
    Key? key,
    required this.contentData,
    required this.onNavigated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contentData.isCastDetailsAvailable) ...[
          8.height,
          viewAllWidget(
            labelSize: 16,
            label: locale.value.cast,
            isSymmetricPaddingEnable: false,
            showViewAll: contentData.cast.length > 4,
            onButtonPressed: () {
              onNavigated.call();
              Get.to(
                () => PersonListScreen(title: "${locale.value.actors} of ${contentData.details.name}"),
                arguments: ArgumentModel(stringArgument: '${ApiRequestKeys.entertainmentIdKey}=${contentData.entertainmentId}&${ApiRequestKeys.typeKey}=${ApiRequestKeys.actorKey}'),
              );
            },
          ),
          HorizontalList(
            runSpacing: dynamicCardsDimensions.$2,
            spacing: dynamicCardsDimensions.$2,
            itemCount: contentData.cast.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final Cast cast = contentData.cast[index];
              return PersonCard(
                castData: cast,
                width: dynamicCardsDimensions.$1,
                height: dynamicCardsDimensions.$1,
                onNavigated: () {
                  onNavigated.call();
                },
              );
            },
          ),
        ],
        if (contentData.isDirectorDetailsAvailable) ...[
          8.height,
          viewAllWidget(
            labelSize: 16,
            isSymmetricPaddingEnable: false,
            label: locale.value.directors,
            showViewAll: contentData.directors.length > 4,
            onButtonPressed: () {
              onNavigated.call();
              Get.to(
                () => PersonListScreen(title: "${locale.value.directors} of ${contentData.details.name}"),
                arguments: ArgumentModel(stringArgument: '${ApiRequestKeys.entertainmentIdKey}=${contentData.entertainmentId}&${ApiRequestKeys.typeKey}=${ApiRequestKeys.directorKey}'),
              );
            },
          ),
          HorizontalList(
            padding: EdgeInsets.zero,
            runSpacing: dynamicCardsDimensions.$2,
            spacing: dynamicCardsDimensions.$2,
            itemCount: contentData.directors.length,
            itemBuilder: (context, index) {
              final Cast director = contentData.directors[index];
              return PersonCard(
                castData: director,
                width: dynamicCardsDimensions.$1,
                height: dynamicCardsDimensions.$1,
                onNavigated: () {
                  onNavigated.call();
                },
              );
            },
          ),
        ],
      ],
    );
  }
}