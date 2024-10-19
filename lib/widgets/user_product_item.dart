// ignore_for_file: use_key_in_widget_constructors

import 'package:online_market/provider/products.dart';
import 'package:online_market/screens/edit_product_sreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String urlimage;
  const UserProductItem({
    required this.id,
    required this.title,
    required this.urlimage,
  });
  @override
  Widget build(BuildContext context) {
    final snackBar = ScaffoldMessenger.of(context);
    return Container(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(urlimage),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routName,
                    arguments: id,
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProductbyid(id);
                  } catch (error) {
                    snackBar.showSnackBar(
                      SnackBar(
                        content: Text(
                          'something went wrong  $error',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete),
              )
            ],
          ),
        ),
      ),
    );
  }
}
