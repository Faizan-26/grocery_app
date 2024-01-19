import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart';

class GroceryItemWidget extends StatefulWidget {
  const GroceryItemWidget({super.key, required this.item});
  final GroceryItem item;

  @override
  State<GroceryItemWidget> createState() => _GroceryItemWidgetState();
}

class _GroceryItemWidgetState extends State<GroceryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: widget.item.category.color,
          borderRadius: const BorderRadius.all(Radius.elliptical(4, 4)),
        ),
      ),
      title: Text(
        widget.item.name,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: Text(
        widget.item.quantity.toString(),
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}
