import 'dart:convert';
import 'package:dio/dio.dart';

class SubtitleEntry {
  final Duration start;
  final Duration end;
  final String text;

  SubtitleEntry({
    required this.start,
    required this.end,
    required this.text,
  });
}

// Top-level function for compute
Future<List<SubtitleEntry>> getSubtitleData(String url) async {
  try {
    final dio = Dio();
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return parseSubtitles(response.data.toString());
    }
  } catch (e) {}
  return [];
}

List<SubtitleEntry> parseSubtitles(String content) {
  final List<SubtitleEntry> subtitles = [];
  final lines = LineSplitter.split(content).toList();

  // Basic parser for SRT (simplified)
  int index = 0;
  while (index < lines.length) {
    String line = lines[index].trim();
    if (line.isEmpty) {
      index++;
      continue;
    }

    // Skip index number if present
    if (int.tryParse(line) != null) {
      index++;
      if (index >= lines.length) break;
      line = lines[index].trim();
    }

    // Parse time
    if (line.contains('-->')) {
      final parts = line.split('-->');
      if (parts.length == 2) {
        final start = parseDuration(parts[0].trim());
        final end = parseDuration(parts[1].trim());

        index++;
        String text = "";
        while (index < lines.length && lines[index].trim().isNotEmpty) {
          text += (text.isEmpty ? "" : "\n") + lines[index].trim();
          index++;
        }

        subtitles.add(SubtitleEntry(start: start, end: end, text: text));
      } else {
        index++;
      }
    } else {
      index++;
    }
  }

  return subtitles;
}

Duration parseDuration(String s) {
  // s: 00:00:20,000 or 00:00:20.000
  s = s.replaceAll(',', '.');
  try {
    final parts = s.split(':');
    if (parts.length == 3) {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      List<String> secParts = parts[2].split('.');
      int seconds = int.parse(secParts[0]);
      int milliseconds = 0;
      if (secParts.length > 1) {
        milliseconds = int.tryParse(secParts[1].padRight(3, '0').substring(0, 3)) ?? 0;
      }
      return Duration(hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds);
    }
  } catch (_) {}
  return Duration.zero;
}