import 'package:online_market/provider/cart.dart';
import 'package:online_market/provider/orders.dart';
import 'package:online_market/widgets/carditem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';

  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    final items = cart.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('total'),
                const Spacer(),
                Chip(
                  label: Text('\$${cart.totalAmount}'),
                ),
                orderButton(cart: cart),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemcount,
              itemBuilder: (context, index) => CardItem(
                productId: items.keys.toList()[index],
                id: items.values.toList()[index].id,
                price: items.values.toList()[index].price,
                quantity: items.values.toList()[index].quantity,
                title: items.values.toList()[index].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  final Cart cart;
  const orderButton({
    super.key,
    required this.cart,
  });

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (widget.cart.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(
                context,
                listen: false,
              ).addordr(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                isLoading = false;
              });

              widget.cart.clearItems();
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text('Order Now'),
    );
  }
}
