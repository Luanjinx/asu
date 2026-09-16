// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../main.dart';
import '../../utils/common_functions.dart';
import 'components/menu.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  DateTime? currentBackPressTime;
  RxList<BottomBarItem> bottomNavItems = [
    BottomBarItem(
      title: () => locale.value.home,
      icon: Assets.iconsHouse,
      type: BottomItem.home.name,
      selectedIcon: Assets.iconsHouseFill,
    ),
    BottomBarItem(
      title: () => locale.value.search,
      icon: Assets.iconsMagnifyingGlass,
      type: BottomItem.search.name,
      selectedIcon: Assets.iconsMagnifyingGlassFill,
    ),
    BottomBarItem(
      title: () => locale.value.comingSoon,
      icon: Assets.iconsConfetti,
      type: BottomItem.comingsoon.name,
      selectedIcon: Assets.iconsConfettiFill,
    ),
    if (appConfigs.value.enableLiveTv)
      BottomBarItem(
        title: () => locale.value.liveTv,
        icon: Assets.iconsTelevisionSimple,
        type: BottomItem.livetv.name,
        selectedIcon: Assets.iconsTelevisionSimpleFill,
      ),
    BottomBarItem(
      title: () => locale.value.profile,
      icon: Assets.iconsUserCircleGear,
      type: BottomItem.profile.name,
      selectedIcon: Assets.iconsUserCircleGearFill,
    ),
  ].obs;

  @override
  void onInit() {
    if (!appConfigs.value.enableMovie && !appConfigs.value.enableTvShow && !appConfigs.value.enableVideo) {
      bottomNavItems.removeWhere((element) => element.type == BottomItem.comingsoon.name);
    }

    currentIndex(0);

    super.onInit();
  }

  void addDataOnBottomNav() {
    bottomNavItems.refresh();
    if (!appConfigs.value.enableMovie && !appConfigs.value.enableTvShow && !appConfigs.value.enableVideo && bottomNavItems.any((element) => element.type == BottomItem.comingsoon.name)) {
      bottomNavItems.removeWhere((element) => element.type == BottomItem.comingsoon.name);
    }
  }
}