import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_content_model.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_poster_model.dart';
import 'package:streamit_laravel/utils/constants.dart';

class HiveService {
  static const String contentBoxName = 'contentBox';
  static const String posterBoxName = 'posterBox';

  Box<HiveContentModel>? _contentBox;
  Box<HivePosterModel>? _posterBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveContentModelAdapter());
    Hive.registerAdapter(HivePosterModelAdapter());
    _contentBox = await Hive.openBox<HiveContentModel>(contentBoxName);
    _posterBox = await Hive.openBox<HivePosterModel>(posterBoxName);
  }

  Box<HiveContentModel> get contentBox => _contentBox!;

  Box<HivePosterModel> get posterBox => _posterBox!;

  Future<void> saveContent(HiveContentModel content) async {
    await contentBox.put(content.id, content);
  }

  Future<void> deleteContent(int contentId) async {
    await deleteContentWithFiles(contentId);
  }

  /// Delete content with associated files (encrypted and decrypted)
  Future<bool> deleteContentWithFiles(int contentId) async {
    try {
      final item = contentBox.get(contentId);
      if (item != null && item.localFilePath != null && item.localFilePath!.isNotEmpty) {
        final encPath = item.localFilePath!;
        final encFile = File(encPath);

        // Delete encrypted file
        if (encFile.existsSync()) {
          await encFile.delete();
        }

        // Delete decrypted file if it exists (.dec file)
        final decPath = encPath.replaceFirst('.enc', '.dec');
        final decFile = File(decPath);
        if (decFile.existsSync()) {
          await decFile.delete();
        }
      }

      // Delete from Hive
      await contentBox.delete(contentId);
      return true;
    } catch (e) {
      log('Error deleting content with files: $e');
      return false;
    }
  }

  /// Get all completed downloaded content (watchedProgress >= 100 or watchedDuration >= totalDuration)
  List<HiveContentModel> getCompletedContent() {
    return contentBox.values.where((item) {
      if (!item.isDownloaded) return false;

      final isCompletedByProgress = item.watchedProgress >= 100.0;
      final isCompletedByDuration = item.totalDuration > 0 && item.watchedDuration >= (item.totalDuration - 1);

      return isCompletedByProgress || isCompletedByDuration;
    }).toList();
  }

  List<HiveContentModel> getAllContent() {
    return contentBox.values.toList();
  }

  HiveContentModel? getContentFromContentBox(int id) {
    return hiveService.contentBox.get(id);
  }

  Future<(String, String)> getFileTypeForDownloadedContent(int id) async {
    final HiveContentModel? data = getContentFromContentBox(id) ?? null;
    if (data != null) {
      final encPath = data.localFilePath;
      if (encPath != null && encPath.isNotEmpty) {
        // Check if encrypted file exists
        final encFile = File(encPath);
        if (encFile.existsSync()) {
          return (URLTypes.file, encPath);
        }
      }
      return ('', '');
    } else
      return ('', '');
  }
}