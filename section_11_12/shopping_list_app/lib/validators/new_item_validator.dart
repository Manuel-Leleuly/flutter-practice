import 'package:shopping_list_app/models/category_model.dart';

class NewItemValidator {
  const NewItemValidator();

  String? validateName(String? name) {
    final isValueEmpty = name == null || name.isEmpty;
    final isValueInLength = !isValueEmpty && name.trim().length <= 50;
    if (!isValueInLength) {
      return 'Must be between 1 and 50 characters.';
    }
    return null;
  }

  String? validateQuantity(String? quantity) {
    final valueInNumber = int.tryParse(quantity ?? "");

    final isValueEmpty =
        quantity == null || quantity.isEmpty || valueInNumber == null;
    final isValueInLength = !isValueEmpty && valueInNumber >= 0;
    if (!isValueInLength) {
      return 'Must be a valid positive number.';
    }

    return null;
  }

  String? validateCategory(Category? category) {
    if (category == null) {
      return 'Category is required';
    }

    return null;
  }
}
