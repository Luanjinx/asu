import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/continue_watching_list/components/remove_continue_watching_component.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../../main.dart';
import '../../../network/core_api.dart';
import '../../continue_watching_list/components/continue_watching_item_component.dart';
import '../../continue_watching_list/continue_watching_list_screen.dart';
import '../home_controller.dart';

class ContinueWatchComponent extends StatelessWidget {
  final List<PosterDataModel> continueWatchList;

  const ContinueWatchComponent({super.key, required this.continueWatchList});

  @override
  Widget build(BuildContext context) {
    if (continueWatchList.isEmpty) return const Offstage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: locale.value.continueWatching,
          showViewAll: continueWatchList.isNotEmpty,
          onButtonPressed: () {
            Get.to(() => ContinueWatchingListScreen());
          },
        ),
        HorizontalList(
            spacing: 12,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: continueWatchList.length,
            itemBuilder: (context, index) {
              PosterDataModel continueWatchData = continueWatchList[index];
              return Hero(
                tag: index,
                child: ContinueWatchingItemComponent(
                  continueWatchData: continueWatchList[index],
                  onRemoveTap: () {
                    handleRemoveFromContinueWatch(
                      context,
                      continueWatchList[index].id,
                      continueWatchData.details.name,
                      continueWatchData.details.type,
                    );
                  },
                ),
              );
            }),
      ],
    );
  }

  Future<void> handleRemoveFromContinueWatch(BuildContext context, int id, String title, String type) async {
    Get.bottomSheet(
      AppDialogWidget(
        image: Assets.iconsTrash,
        imageColor: appColorPrimary,
        child: RemoveContinueWatchingComponent(
          onRemoveTap: () async {
            Get.back();
            final HomeController homeScreenCont = Get.find();
            homeScreenCont.isWatchListLoading(false);
            await CoreServiceApis.removeContinueWatching(continueWatchingId: id).then((value) async {
              successSnackBar(value.message);
              homeScreenCont.removeFromContinueWatching(id);
            }).catchError((e) {
              homeScreenCont.isWatchListLoading(false);
              errorSnackBar(error: e);
            }).whenComplete(() => homeScreenCont.isWatchListLoading(false));
          },
          title: locale.value.removeFromContinueWatchingTitle(title, type.getContentTypeTitleSingular()),
        ),
      ),
    );
  }
}