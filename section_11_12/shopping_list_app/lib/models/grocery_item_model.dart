import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category_model.dart';
import 'package:shopping_list_app/models/models.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> itemJson) {
    return GroceryItem(
      id: itemJson['id'],
      name: itemJson['name'],
      quantity: itemJson['quantity'],
      category: getCategoryFromTitle(itemJson['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "quantity": quantity,
      "category": category.title,
    };
  }
}

// helper function
Category getCategoryFromTitle(String title) {
  return categories.values.firstWhere(
    (category) => category.title == title,
    orElse: () => categories[Categories.other] as Category,
  );
}

List<GroceryItem> convertListJsonToGroceryList(JsonResponse response) {
  final List<GroceryItem> groceries = [];

  response.forEach(
    (key, value) {
      final JsonResponse groceryData = {
        "id": key,
        ...value,
      };

      groceries.add(GroceryItem.fromJson(groceryData));
    },
  );

  return groceries;
}
