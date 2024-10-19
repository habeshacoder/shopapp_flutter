import 'package:online_market/provider/auth.dart';
import 'package:online_market/provider/cart.dart';
import 'package:online_market/provider/product.dart';
import 'package:online_market/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Cart cart = Provider.of<Cart>(context);
    Auth auth = Provider.of<Auth>(context, listen: false);
    return GridTile(
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
    );
  }
}
