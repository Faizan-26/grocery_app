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
  final List<GroceryItem> _groceryList = [];
  void _loadItems() async {
    final url = Uri.https(
        'flutter-grocery-app-46cd0-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    print(response.body);

    final Map<String, Map<String, dynamic>> listData =
        json.decode(response.body);
    final List<GroceryItem> loadedItemsList = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere((element) => item.value['category']== element.key);
      // loadedItemsList.add(GroceryItem(
      //   id: item.key,
      //   name: item.value['name'],
      //   quantity: item.value['quantity'],
        // category: Category(name, color),
    //  ));
    }
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
                await Navigator.of(context)
                    .push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
                  return const NewItemScreen();
                }));
                final url = Uri.https(
                    'flutter-grocery-app-46cd0-default-rtdb.firebaseio.com',
                    'shopping-list.json');
                _loadItems();
              })
        ],
      ),
      body: _groceryList.isEmpty
          ? const Center(
              child: Text("Add Some Items!"),
            )
          : ListView.builder(
              itemCount: _groceryList.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Dismissible(
                    key: ValueKey(_groceryList[index].id),
                    onDismissed: (dir) {
                      setState(() async {
                        _groceryList.remove(_groceryList[index]);
                      });
                    },
                    child: GroceryItemWidget(item: _groceryList[index]));
              },
            ),
    );
  }
}
