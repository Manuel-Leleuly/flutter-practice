import 'package:conditional_parent_widget/conditional_parent_widget.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/screens/meal_details_screen.dart';
import 'package:meal_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: title != null,
      parentBuilder: (child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title!),
          ),
          body: child,
        );
      },
      child: _MealsScreenBody(
        meals: meals,
        onToggleFavorite: onToggleFavorite,
      ),
    );
  }
}

class _MealsScreenBody extends StatelessWidget {
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  const _MealsScreenBody({
    required this.meals,
    required this.onToggleFavorite,
  });

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return MealDetailsScreen(
        meal: meal,
        onToggleFavorites: onToggleFavorite,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh... nothing here!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return MealItem(
          meal: meals[index],
          onSelectMeal: (meal) {
            selectMeal(context, meal);
          },
        );
      },
    );
  }
}
