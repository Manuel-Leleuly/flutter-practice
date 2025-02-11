import 'package:flutter/material.dart';
import 'package:meal_app/data/category_data.dart';
import 'package:meal_app/models/category_model.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/screens/meals_screen.dart';
import 'package:meal_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Meal> availableMeals;
  final void Function(Meal meal) onToggleFavorites;

  const CategoriesScreen(
      {super.key,
      required this.onToggleFavorites,
      required this.availableMeals});

  void _selectCategory(BuildContext context, Category category) {
    final selectedMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return MealsScreen(
            title: category.title,
            meals: selectedMeals,
            onToggleFavorite: onToggleFavorites,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        ...availableCategories.map((category) {
          return CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          );
        })
      ],
    );
  }
}
