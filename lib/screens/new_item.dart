import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/data/categories.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";
  int _enteredQuantity = 1;
  var selectedCategory = categories[Categories.other];
  bool _isLoading = false;
  void _saveItem() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-grocery-app-46cd0-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': selectedCategory!.name,
        }),
      );

      _enteredQuantity = 1;
      _formKey.currentState!.reset();

      if (!context.mounted) {
        return;
      }
      final Map<String, dynamic> resData = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: selectedCategory!,
      ));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    // labelText: "Item Name",
                    label: Text("Item name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter name";
                    } else if (value.trim().length <= 1) {
                      return "Name must be more then 1 letter ";
                    } else if (value.trim().length > 50) {
                      return "Name cannot be more then 50 letters";
                    }
                    return null; // means value is valid
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Quantity value!";
                          } else if (int.tryParse(value) == null) {
                            return "Please enter valid quantity!";
                          } else if (int.tryParse(value)! <= 0) {
                            return "Value cannot be less then 1";
                          }
                          return null; // means value is valid
                        },
                        decoration: const InputDecoration(
                          labelText: "Quantity",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                        ),
                        initialValue: _enteredQuantity.toString(),
                        onSaved: (value) {
                          _enteredQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: selectedCategory,
                          items: [
                            for (final category in categories
                                .entries) // categories.entries is a list of MapEntry<Category, Category>
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: category.value.color,
                                        borderRadius: const BorderRadius.all(
                                            Radius.elliptical(4, 4)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(category.value.name)
                                  ],
                                ),
                              )
                          ],
                          onChanged: (value) {
                            selectedCategory = value;
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  height: 3 / 2 * 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                _enteredQuantity = 1;
                                _formKey.currentState!.reset();
                              },
                        child: const Text("Reset form")),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveItem,
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator())
                          : const Text("Add Item"),
                    )
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
