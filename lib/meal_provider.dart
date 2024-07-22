import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'meal.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  DatabaseHelper _dbHelper = DatabaseHelper();

  MealProvider() {
    _loadMeals();
  }

  List<Meal> get meals => _filteredMeals;

  void addMeal(Meal meal) async {
    await _dbHelper.insertMeal(meal);
    _loadMeals();
  }

  void updateMeal(Meal meal) async {
    await _dbHelper.updateMeal(meal);
    _loadMeals();
  }

  void removeMeal(Meal meal) async {
    if (meal.id != null) {
      await _dbHelper.deleteMeal(meal.id!);
      _loadMeals();
    }
  }

  void _loadMeals() async {
    _meals = await _dbHelper.meals();
    _filteredMeals = _meals;
    notifyListeners();
  }

  void filterMeals(DateTime startDate, DateTime endDate) {
    _filteredMeals = _meals.where((meal) {
      return meal.dateTime.isAfter(startDate) &&
          meal.dateTime.isBefore(endDate);
    }).toList();
    notifyListeners();
  }
}
