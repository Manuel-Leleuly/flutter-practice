import 'package:flutter/material.dart';
import 'package:meal_app/data/meal_data.dart';
import 'package:meal_app/models/meal_model.dart';
import 'package:meal_app/screens/categories_screen.dart';
import 'package:meal_app/screens/filters_screen.dart';
import 'package:meal_app/screens/meals_screen.dart';
import 'package:meal_app/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(DrawerTile identifier) async {
    Navigator.of(context).pop();
    switch (identifier) {
      case DrawerTile.filters:
        final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
            builder: (ctx) {
              return FiltersScreen(currentFilter: _selectedFilters);
            },
          ),
        );

        setState(() {
          _selectedFilters = result ?? kInitialFilters;
        });

        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String activePageTitle = switch (_selectedPageIndex) {
      1 => 'Your Favorites',
      _ => 'Categories'
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: _SelectedScreen(
        selectedPageIndex: _selectedPageIndex,
        selectedFilters: _selectedFilters,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

// helper widgets
class _SelectedScreen extends StatefulWidget {
  final int selectedPageIndex;
  final Map<Filter, bool> selectedFilters;

  const _SelectedScreen({
    required this.selectedPageIndex,
    required this.selectedFilters,
  });

  @override
  State<_SelectedScreen> createState() => _SelectedScreenState();
}

class _SelectedScreenState extends State<_SelectedScreen> {
  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('${meal.title} is no longer a favorite');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('${meal.title} marked as favorite');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.selectedPageIndex) {
      case 1:
        return MealsScreen(
          meals: [],
          onToggleFavorite: _toggleMealFavoriteStatus,
        );
      default:
        return CategoriesScreen(
          onToggleFavorites: _toggleMealFavoriteStatus,
          availableMeals: getFilteredMeals(widget.selectedFilters, dummyMeals),
        );
    }
  }
}

// helper functions
List<Meal> getFilteredMeals(Map<Filter, bool> mealFilters, List<Meal> meals) {
  return meals.where((meal) {
    if (mealFilters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
    if (mealFilters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
    if (mealFilters[Filter.vegetarian]! && !meal.isVegetarian) return false;
    if (mealFilters[Filter.vegan]! && !meal.isVegan) return false;
    return true;
  }).toList();
}
