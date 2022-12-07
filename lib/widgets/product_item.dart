import 'package:expandedflexible/provider/auth.dart';
import 'package:expandedflexible/provider/cart.dart';
import 'package:expandedflexible/provider/product.dart';
import 'package:expandedflexible/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({
  //   required this.id,
  //   required this.imageUrl,
  //   required this.title,
  // });
  @override
  Widget build(BuildContext context) {
    // print('build method');135

    Product product = Provider.of<Product>(context);
    Cart cart = Provider.of<Cart>(context);
    Auth auth = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        leading: IconButton(
          onPressed: () {
            product.toggleFavorite(auth.token, auth.userId);
          },
          icon: product.isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.yellow,
                )
              : const Icon(
                  Icons.favorite_border,
                  color: Colors.yellow,
                ),
        ),
        backgroundColor: Colors.black87,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          onPressed: () {
            cart.addItem(
              product.id,
              product.price,
              product.title,
            );
            final snackBar = SnackBar(
              content: const Text('Yay! A SnackBar!'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  cart.singlechilddeletion(product.id);
                  print('SNACK BAR');
                },
              ),
            );
            //immidiatly display snackbar if user add carts frequantlly
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }
}
