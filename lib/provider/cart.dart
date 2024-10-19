// ignore_for_file: prefer_final_fields

import 'package:online_market/widgets/carditem.dart';
import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  //
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
      (key, value) {
        total += value.price * value.quantity;
      },
    );
    return total;
  }

  //
  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //chage product
      _items.update(
        productId,
        (existingcartitemValue) => CartItem(
          id: existingcartitemValue.id,
          title: existingcartitemValue.title,
          price: existingcartitemValue.price,
          quantity: existingcartitemValue.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removecart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //undo from adding carts
  void singlechilddeletion(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingcartitemValue) => CartItem(
          id: existingcartitemValue.id,
          title: existingcartitemValue.title,
          price: existingcartitemValue.price,
          quantity: existingcartitemValue.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

// make the items list empty after shopping i.es
// after user orders

  void clearItems() {
    _items = {};
    notifyListeners();
  }
}
