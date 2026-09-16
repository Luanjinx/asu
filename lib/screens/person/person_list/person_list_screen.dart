import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../home/components/person_component/person_card.dart';
import 'person_list_controller.dart';

// ignore: must_be_immutable
class PersonListScreen extends StatelessWidget {
  String title;

  PersonListScreen({super.key, required this.title});

  final PersonListController personListCont = Get.find<PersonListController>();

  @override
  Widget build(BuildContext context) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 3);
    return NewAppScaffold(
      scrollController: personListCont.scrollController,
      isLoading: personListCont.isLoading,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: title.validate(),
      onRefresh: personListCont.onRefresh,
      isPinnedAppbar: true,
      body: SnapHelperWidget(
        future: personListCont.listContentFuture.value,
        initialData: cachedPersonList,
        loadingWidget: ContentListShimmer(
          spacing: dynamicCardsDimensions.$2,
          width: dynamicCardsDimensions.$1,
          height: dynamicCardsDimensions.$1,
        ),
        errorBuilder: (error) {
          return AppNoDataWidget(
            height: Get.height * 0.35,
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: personListCont.onRetry,
          ).center().visible(!personListCont.isLoading.value);
        },
        onSuccess: (res) {
          return Obx(
            () {
              final bool shouldShowLoader = personListCont.isFetchingList.value && personListCont.listContent.isEmpty;

              if (shouldShowLoader) {
                return ContentListShimmer(
                  spacing: dynamicCardsDimensions.$2,
                  width: dynamicCardsDimensions.$1,
                  height: dynamicCardsDimensions.$1,
                );
              }

              if (personListCont.isLoading.isFalse && personListCont.listContent.isEmpty) {
                return AppNoDataWidget(
                  height: Get.height * 0.40,
                  title: locale.value.noPeopleFound,
                  subTitle: locale.value.noCastOrCrewMembersAvailable,
                  retryText: "",
                  imageWidget: const EmptyStateWidget(),
                ).paddingSymmetric(horizontal: 16);
              }

              return AnimatedWrap(
                runSpacing: dynamicCardsDimensions.$2,
                spacing: dynamicCardsDimensions.$2,
                listAnimationType: commonListAnimationType,
                itemCount: personListCont.listContent.length,
                itemBuilder: (context, index) {
                  Cast data = personListCont.listContent[index];
                  return PersonCard(
                    castData: data,
                    width: dynamicCardsDimensions.$1,
                    height: dynamicCardsDimensions.$1,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}