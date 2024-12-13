import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';

class BookmarkProvider extends ChangeNotifier {
  final Set<Food> _bookmarkedFoods = {};

  Set<Food> get bookmarkedFoods => _bookmarkedFoods;

  bool isBookmarked(Food food) => _bookmarkedFoods.contains(food);

  void toggleBookmark(Food food) {
    if (_bookmarkedFoods.contains(food)) {
      _bookmarkedFoods.remove(food);
    } else {
      _bookmarkedFoods.add(food);
    }
    notifyListeners();
  }
}