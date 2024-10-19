// import 'package:online_market/provider/cart.dart';
// ignore_for_file: non_constant_identifier_names

import 'package:online_market/widgets/app_drawer.dart';
import 'package:online_market/widgets/order_item.dart' as ow;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_market/provider/orders.dart';

class OrderScreen extends StatefulWidget {
  static const routName = '/orderScreen';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final url =
      ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products/orders.json');
  var isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrders();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orders order = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('your order'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: order.ordrslist.length,
              itemBuilder: (context, index) => ow.OrderItem(
                order: order.ordrslist[index],
              ),
            ),
    );
  }
}
