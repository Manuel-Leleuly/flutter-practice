import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/favorites_provider.dart';
import 'package:meal_app/providers/filters_provider.dart';
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

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(DrawerTile identifier) async {
    Navigator.of(context).pop();
    switch (identifier) {
      case DrawerTile.filters:
        await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
            builder: (ctx) {
              return FiltersScreen();
            },
          ),
        );

        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activePageTitle = switch (_selectedPageIndex) {
      1 => 'Your Favorites',
      _ => 'Categories'
    };
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: _SelectedScreen(
        selectedPageIndex: _selectedPageIndex,
        selectedFilters: activeFilters,
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
class _SelectedScreen extends ConsumerStatefulWidget {
  final int selectedPageIndex;
  final Map<Filter, bool> selectedFilters;

  const _SelectedScreen({
    required this.selectedPageIndex,
    required this.selectedFilters,
  });

  @override
  ConsumerState<_SelectedScreen> createState() => _SelectedScreenState();
}

class _SelectedScreenState extends ConsumerState<_SelectedScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    switch (widget.selectedPageIndex) {
      case 1:
        return MealsScreen(
          meals: favoriteMeals,
        );
      default:
        return CategoriesScreen(
          availableMeals: ref.watch(filteredMealsProvider),
        );
    }
  }
}
