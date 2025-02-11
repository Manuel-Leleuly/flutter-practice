import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      body: Column(
        children: [
          FilterToggle(
            value: activeFilters[Filter.glutenFree]!,
            title: 'Gluten-free',
            subtitle: 'Only include gluten-free meals',
            onToggleChange: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, isChecked);
            },
          ),
          FilterToggle(
            value: activeFilters[Filter.lactoseFree]!,
            title: 'Lactose-free',
            subtitle: 'Only include lactose-free meals',
            onToggleChange: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, isChecked);
            },
          ),
          FilterToggle(
            value: activeFilters[Filter.vegetarian]!,
            title: 'Vegetarian',
            subtitle: 'Only include vegetarian meals',
            onToggleChange: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarian, isChecked);
            },
          ),
          FilterToggle(
            value: activeFilters[Filter.vegan]!,
            title: 'Vegan',
            subtitle: 'Only include vegan meals',
            onToggleChange: (isChecked) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegan, isChecked);
            },
          ),
        ],
      ),
    );
  }
}

// helper widgets
class FilterToggle extends StatelessWidget {
  final bool value;
  final String title;
  final String subtitle;
  final void Function(bool isChecked) onToggleChange;

  const FilterToggle({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onToggleChange,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onToggleChange,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }
}
