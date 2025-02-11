import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/helpers/firebase_helpers.dart';
import 'package:shopping_list_app/models/category_model.dart';
import 'package:shopping_list_app/models/grocery_item_model.dart';
import 'package:shopping_list_app/models/models.dart';
import 'package:shopping_list_app/validators/new_item_validator.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final newItemValidator = const NewItemValidator();

  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;
  bool _isSending = false;

  void _onSaveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      final itemData = GroceryItem(
        id: DateTime.now().toString(),
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      );

      final response = await http.post(
        getFirebaseUrl('shopping-list'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(itemData.toJson()),
      );

      final JsonResponse resData = json.decode(response.body);

      if (context.mounted) {
        Navigator.of(context).pop(
          GroceryItem(
            id: resData['name'],
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: newItemValidator.validateName,
                initialValue: _enteredName,
                onSaved: (newValue) {
                  _enteredName = newValue!;
                },
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: newItemValidator.validateQuantity,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _enteredQuantity.toString(),
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _enteredQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      validator: newItemValidator.validateCategory,
                      items: categories.entries.map((category) {
                        return DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 6),
                              Text(category.value.title),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: switch (_isSending) {
                      true => null,
                      false => () {
                          _formKey.currentState!.reset();
                        },
                    },
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSending ? null : _onSaveItem,
                    child: switch (_isSending) {
                      true => const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        ),
                      false => const Text('Add Item'),
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
