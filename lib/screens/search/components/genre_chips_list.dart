import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class GenreChipsListComponent extends StatelessWidget {
  const GenreChipsListComponent({super.key, required this.searchCont});

  final SearchScreenController searchCont;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (searchCont.isLoadingGenres.value) {
          return const SizedBox.shrink();
        }

        if (searchCont.genresList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconWidget(
                    imgPath: Assets.iconsSliders,
                    color: context.primaryColor,
                    size: 18,
                  ),
                  8.width,
                  Text(
                    locale.value.genres,
                    style: commonPrimaryTextStyle(),
                  ),
                ],
              ),
              8.height,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: searchCont.genresList.map((genre) {
                    final isSelected = searchCont.selectedGenreIds.contains(genre.id);
                    return GestureDetector(
                      onTap: () => searchCont.toggleGenreSelection(genre.id),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        decoration: boxDecorationDefault(
                          color: isSelected ? appColorPrimary : cardColor,
                          borderRadius: BorderRadius.circular(4),
                          border: isSelected ? null : Border.all(color: iconColor.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Text(
                          genre.name,
                          style: commonSecondaryTextStyle(color: isSelected ? white : null),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}