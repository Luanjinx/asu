import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/filtered_content_list_screen.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../../components/app_scaffold.dart';
import '../../../../main.dart';

class LanguageListScreen extends StatelessWidget {
  final List<LanguageModel> languageList;
  final String title;

  const LanguageListScreen({
    super.key,
    required this.languageList,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: title,
      body: languageList.isEmpty
          ? Center(
              child: AppNoDataWidget(
                title: locale.value.noContentFound,
                retryText: '',
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.3,
              ),
              itemCount: languageList.length,
              itemBuilder: (context, index) {
                final LanguageModel language = languageList[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => FilteredContentListScreen(title: language.name),
                      arguments: ArgumentModel(
                        stringArgument:
                            '${ApiRequestKeys.language}=${language.name}',
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'language_${language.id}',
                    child: CachedImageWidget(
                      url: language.languageImage,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      radius: 6,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
