import 'package:online_market/provider/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItem({
    required this.amount,
    required this.datetime,
    required this.id,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final token;

  Orders(this._orders, this.token);

  List<OrderItem> get ordrslist {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/orders.json?auth=$token');

    try {
      final response = await http.get(Uri.parse(url));
      final List<OrderItem> loadedOrders = [];
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;
      extractedOrders.forEach(
        (key, value) {
          loadedOrders.add(OrderItem(
            amount: value['amount'],
            datetime: DateTime.parse(value['datetime']),
            id: key,
            products: (value['cartproduct'] as List<dynamic>)
                .map((value) => CartItem(
                    id: value['id'],
                    title: value['title'],
                    quantity: value['quantity'],
                    price: value['price']))
                .toList(),
          ));
        },
      );
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addordr(List<CartItem> cartproducts, double total) async {
    final url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/orders.json?auth=$token');
    final datetime = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'datetime': datetime.toIso8601String(),
          'cartproduct': cartproducts
              .map(
                (cartpro) => {
                  'id': cartpro.id,
                  'title': cartpro.title,
                  'quantity': cartpro.quantity,
                  'price': cartpro.price,
                },
              )
              .toList(),
        }));
    if (response.statusCode >= 400) {
      throw (response);
    }

    _orders.insert(
      0,
      OrderItem(
        amount: total,
        datetime: datetime,
        id: json.decode(response.body)['name'],
        products: cartproducts,
      ),
    );
    notifyListeners();
  }
}
