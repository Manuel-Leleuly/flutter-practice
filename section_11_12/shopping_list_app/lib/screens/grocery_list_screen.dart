import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/helpers/firebase_helpers.dart';
import 'package:shopping_list_app/models/grocery_item_model.dart';
import 'package:shopping_list_app/models/models.dart';
import 'package:shopping_list_app/screens/new_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;

  Future<List<GroceryItem>> _loadItems() async {
    final response = await http.get(getFirebaseUrl('shopping-list'));

    // TODO: improve exceptions
    if (isFetchError(response)) {
      throw Exception('Failed to fetch grocery items. Please try again later.');
    }

    final JsonResponse listData = json.decode(response.body);

    final categoryData = convertListJsonToGroceryList(listData);

    setState(() {
      _groceryItems = categoryData;
    });

    return categoryData;
  }

  @override
  void initState() {
    _loadedItems = _loadItems();
    super.initState();
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) {
          return const NewItemScreen();
        },
      ),
    );

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final itemIndex = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final response = await http.delete(
      getFirebaseUrl('shopping-list/${item.id}'),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      // Optional: show error message
      setState(() {
        _groceryItems.insert(itemIndex, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (ctx, snapshot) {
          return GroceryListContent(
            groceryItems: snapshot.data ?? [],
            onRemoveItem: _removeItem,
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            error: snapshot.error.toString(),
          );
        },
      ),
    );
  }
}

// helper widgets
class GroceryListContent extends StatelessWidget {
  final List<GroceryItem> groceryItems;
  final void Function(GroceryItem item) onRemoveItem;
  final bool isLoading;
  final String error;

  const GroceryListContent({
    super.key,
    required this.groceryItems,
    required this.onRemoveItem,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != 'null') {
      return Center(
        child: Text(error),
      );
    }

    if (groceryItems.isEmpty) {
      return const Center(
        child: Text('No items added yet.'),
      );
    }

    return ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          onDismissed: (direction) {
            onRemoveItem(groceryItems[index]);
          },
          key: ValueKey(groceryItems[index].id),
          child: ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(groceryItems[index].quantity.toString()),
          ),
        );
      },
    );
  }
}
