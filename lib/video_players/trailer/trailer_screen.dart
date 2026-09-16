import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_controller.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_widget.dart';

class TrailerScreen extends StatefulWidget {
  final String title;

  final VideoData trailerData;

  const TrailerScreen({super.key, this.title = '', required this.trailerData});

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  @override
  void dispose() {
    if (Get.isRegistered<TrailerController>(tag: widget.trailerData.id.toString())) {
      Get.delete<TrailerController>(tag: widget.trailerData.id.toString(), force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrailerWidget(
        tag: widget.trailerData.id.toString(),
        title: widget.title,
        trailerData: widget.trailerData,
      ),
    );
  }
}