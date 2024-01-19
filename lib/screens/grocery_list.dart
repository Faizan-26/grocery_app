import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/data/categories.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/new_item.dart';
import 'package:grocery_app/widgets/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryList = [];
  bool _isLoading = true;
  void _loadItems() async {
    final url = Uri.https(
        'flutter-grocery-app-46cd0-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItemsList = [];
    for (final item in listData.entries) {
      final Category caTegory = categories.entries
          .firstWhere((element) => item.value['category'] == element.value.name)
          .value;
      loadedItemsList.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: caTegory,
      ));
    }
    setState(() {
      _groceryList = loadedItemsList;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Groceries",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final newItem = await Navigator.of(context)
                    .push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
                  return const NewItemScreen();
                }));
                if (newItem == null) {
                  return;
                }
                setState(() {
                  _groceryList.add(newItem);
                });
                //_loadItems();
              })
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : _groceryList.isEmpty
              ? const Center(
                  child: Text("Add Some Items!"),
                )
              : ListView.builder(
                  itemCount: _groceryList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Dismissible(
                        key: ValueKey(_groceryList[index].id),
                        onDismissed: (dir) {
                          setState(() {
                            _groceryList.remove(_groceryList[index]);
                          });
                        },
                        child: GroceryItemWidget(item: _groceryList[index]));
                  },
                ),
    );
  }
}
