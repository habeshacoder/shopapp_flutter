import 'dart:math';

import 'package:flutter/material.dart';
import 'package:online_market/provider/orders.dart' as om;

class OrderItem extends StatefulWidget {
  final om.OrderItem order;
  const OrderItem({
    super.key,
    required this.order,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.order.amount}'),
            subtitle: Text(
              widget.order.datetime.toString(),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (expanded)
            SizedBox(
              height: min(widget.order.products.length * 20.0 + 100, 180),
              child: ListView(
                children: widget.order.products
                    .map(
                      (productitem) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(productitem.title),
                          const Spacer(),
                          Text(
                            '${productitem.quantity} x  \$${productitem.price}',
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
