// import 'package:online_market/provider/product.dart';
import 'package:online_market/provider/products.dart';
import 'package:online_market/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final showOnlyFavorites;
  const ProductsGrid(this.showOnlyFavorites, {super.key});
  @override
  Widget build(BuildContext context) {
    final productsinstance = Provider.of<Products>(context);
    final loadedProducts = showOnlyFavorites
        ? productsinstance.onlyFavorites
        : productsinstance.items;
    //
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(
            // id: loadedProducts[index].id,
            // imageUrl: loadedProducts[index].imageUrl,
            // title: loadedProducts[index].title),
            ),
      ),
    );
  }
}
