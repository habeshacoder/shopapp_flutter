import 'package:expandedflexible/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CardItem({
    required this.productId,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('are you sure ?'),
            content: Text('do you want to delete this cart ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('ok')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('cancel'),
              )
            ],
          ),
        );
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
      ),
      key: ValueKey(id),
      onDismissed: (direction) {
        //
        Provider.of<Cart>(
          context,
          listen: false,
        ).removecart(productId);
      },
      // confirmDismiss: ,
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price ')),
            ),
            title: Text(title),
            subtitle: Text(
              'total \$${price * quantity}',
            ),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
