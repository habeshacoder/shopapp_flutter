import 'package:expandedflexible/provider/cart.dart';
import 'package:expandedflexible/provider/products.dart';
import 'package:expandedflexible/screens/cart_screen.dart';
import 'package:expandedflexible/widgets/app_drawer.dart';
// import 'package:expandedflexible/provider/products.dart';
import 'package:expandedflexible/widgets/badge.dart';
import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  myfavorite,
  showall,
}

class ProductOverView extends StatefulWidget {
  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var showOnlyFavorites = false;
  var isinit = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndPutData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('my shop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.myfavorite) {
                  showOnlyFavorites = true;
                } else {
                  showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text('my favorites'),
                  value: FilterOptions.myfavorite,
                ),
                const PopupMenuItem(
                  child: Text('show all'),
                  value: FilterOptions.showall,
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, _) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.itemcount.toString(),
              color: Colors.red,
            ),
          ),

          // Badge(
          //   child: const IconButton(
          //     onPressed: null,
          //     icon: Icon(Icons.shopping_cart),
          //   ),
          //   value: cart.itemcount.toString(),
          //   color: Colors.red,
          // )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFavorites),
    );
  }
}
