import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';

class ContentListController extends BaseListController<PosterDataModel> {
  SliderController sliderController = SliderController();
  ArgumentModel argumentData = ArgumentModel(boolArgument: true);

  @override
  void onInit() {
    if (Get.arguments is ArgumentModel) {
      argumentData = Get.arguments as ArgumentModel;
      argumentData.stringArgument += '&${ApiRequestKeys.isReleasedKey}=1';
      if (argumentData.extra['extraStringArguments'] != null) {
        argumentData.stringArgument +=
            '&${argumentData.extra['extraStringArguments']}';
      }
      update([argumentData]);
    }
    init();
    super.onInit();
  }

  Future<void> init() async {
    currentPage(1);
    if (Get.arguments is ArgumentModel) {
      await Future.wait(
        [
          //Managed default banner for content list only when intArgument is -1(which is default)
          if (argumentData.extra['banner'] == true) ...[
            sliderController.getBanner(
              type: argumentData.stringArgument,
              showLoader: true,
            ),
          ],
          getListData(showLoader: true),
        ],
      );
    }
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    if(isLoading.value) return;
    setLoading(showLoader);

    await listContentFuture(
      CoreServiceApis.getContentList(
        type: argumentData.stringArgument,
        page: currentPage.value,
        contentList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }
}
