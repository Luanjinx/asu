import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'components/form_fields_component.dart';
import 'components/profile_photo_component.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController profileCont = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: profileCont.isLoading,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.editProfile,
      body: SingleChildScrollView(
        child: Column(
          spacing: 24,
          children: [
            ProfilePicComponent(),
            EditFormFieldComponent(),
          ],
        ).paddingAll(16),
      ),
    );
  }
}