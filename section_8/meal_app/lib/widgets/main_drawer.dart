import 'package:flutter/material.dart';

enum DrawerTile {
  meals,
  filters,
}

class MainDrawer extends StatelessWidget {
  final void Function(DrawerTile identifier) onSelectScreen;

  const MainDrawer({
    super.key,
    required this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  'Cooking Up!',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          MainDrawerListTile(
            icon: Icons.restaurant,
            title: 'Meals',
            onTap: () => onSelectScreen(DrawerTile.meals),
          ),
          MainDrawerListTile(
            icon: Icons.settings,
            title: 'Filters',
            onTap: () => onSelectScreen(DrawerTile.filters),
          ),
        ],
      ),
    );
  }
}

// helper widgets
class MainDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MainDrawerListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
            ),
      ),
      onTap: onTap,
    );
  }
}
