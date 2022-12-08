import 'dart:io';

import 'package:expandedflexible/provider/auth.dart';
import 'package:expandedflexible/screens/order_screen.dart';
import 'package:expandedflexible/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('hello friend'),
            automaticallyImplyLeading: Platform.isIOS ? true : false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('payment'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('user products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('log out'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductScreen.routeName);
              print('before pop in drwaer in the log out');
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              print('after pop in drwaer in the log out');

              Provider.of<Auth>(context, listen: false).logOut();
              print(
                  'after pop and after log out call in drwaer in the log out');
            },
          ),
        ],
      ),
    );
  }
}
