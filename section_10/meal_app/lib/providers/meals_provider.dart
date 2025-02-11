import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/data/meal_data.dart';

final mealsProvider = Provider((ref) {
  return List.of(dummyMeals);
});
