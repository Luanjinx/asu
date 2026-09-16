import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/genres/genres_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/components/geners/genres_card.dart';
import 'model/genres_model.dart';

class GenresListScreen extends StatelessWidget {
  final String? title;

  GenresListScreen({super.key, this.title});

  final GenresController genresCont = Get.find<GenresController>();

  @override
  Widget build(BuildContext context) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 3);
    return NewAppScaffold(
      scrollController: genresCont.scrollController,
      isLoading: genresCont.isLoading,
      currentPage: genresCont.currentPage,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.genres,
      onRefresh: genresCont.onRefresh,
      body: SnapHelperWidget(
        future: genresCont.listContentFuture.value,
        initialData: cachedRentedContentList.isNotEmpty ? cachedRentedContentList : null,
        loadingWidget: ContentListShimmer(
          spacing: dynamicCardsDimensions.$2,
          width: dynamicCardsDimensions.$1,
          height: dynamicCardsDimensions.$1,
        ),
        errorBuilder: (error) {
          return AppNoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              genresCont.onRetry();
            },
          ).visible(!genresCont.isLoading.value);
        },
        onSuccess: (res) {
          return Obx(
            () => genresCont.listContent.isEmpty
                ? AppNoDataWidget(
                    title: locale.value.noGenresFound,
                    subTitle: locale.value.noGenresAvailableSubtitle,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      genresCont.onRetry();
                    },
                  ).center().visible(!genresCont.isLoading.value)
                : AnimatedWrap(
                    listAnimationType: commonListAnimationType,
                    runSpacing: dynamicCardsDimensions.$2,
                    spacing: dynamicCardsDimensions.$2,
                    itemCount: genresCont.listContent.length,
                    itemBuilder: (p0, index) {
                      GenreModel genre = genresCont.listContent[index];
                      return GenresCard(
                        width: dynamicCardsDimensions.$1,
                        height: dynamicCardsDimensions.$1,
                        genresData: genre,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}