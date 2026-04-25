import 'package:flutter/material.dart';
import '../data/models/myth_model.dart';
import '../data/services/myth_service.dart';

class MythProvider extends ChangeNotifier {
  List<Myth> myths = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  bool isGenerating = false;

  Future<void> fetchMyths() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await MythService.getMyths(page);

      List data = result["data"];

      if (data.isEmpty) {
        hasMore = false;
      } else {
        myths.addAll(
          data.map((e) => Myth.fromJson(e)).toList(),
        );
        page++;
      }
    } catch (e) {
      debugPrint("Error fetch myths: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> generate(String theme, int total) async {
    isGenerating = true;
    notifyListeners();

    try {
      await MythService.generateMyth(theme, total);

      // reset data
      myths.clear();
      page = 1;
      hasMore = true;

      await fetchMyths();
    } catch (e) {
      debugPrint("Error generate myths: $e");
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}