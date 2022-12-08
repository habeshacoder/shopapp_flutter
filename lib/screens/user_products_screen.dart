// import 'dart:html';

import 'package:expandedflexible/provider/product.dart';
import 'package:expandedflexible/provider/products.dart';
import 'package:expandedflexible/screens/edit_product_sreen.dart';
import 'package:expandedflexible/widgets/app_drawer.dart';
import 'package:expandedflexible/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class UserProductScreen extends StatelessWidget {
  static const routeName = '/userproductscreen';

  Future<void> Refresh(BuildContext context) async {
    print('in refresh before fetch and set methos call');
    await Provider.of<Products>(context, listen: false)
        .fetchAndPutData(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    // List<Product> products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('user product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routName,
                arguments: 'fromadd',
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => Refresh(context),
                    child: Consumer<Products>(
                      builder: (context, products, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: products.items.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    UserProductItem(
                                      id: products.items[index].id,
                                      title: products.items[index].title,
                                      urlimage: products.items[index].imageUrl,
                                    ),
                                    const Divider(
                                      thickness: 3,
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        future: Refresh(context),
      ),
    );
  }
}
