// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison

// import 'package:expandedflexible/screens/home_screen.dart';
import 'package:expandedflexible/provider/auth.dart';
import 'package:expandedflexible/provider/cart.dart';
import 'package:expandedflexible/provider/orders.dart';
import 'package:expandedflexible/provider/products.dart';
import 'package:expandedflexible/screens/auth_screen.dart';
import 'package:expandedflexible/screens/cart_screen.dart';
import 'package:expandedflexible/screens/edit_product_sreen.dart';
import 'package:expandedflexible/screens/order_screen.dart';
import 'package:expandedflexible/screens/product_detail_screen.dart';
import 'package:expandedflexible/screens/products_overview_screen.dart';
import 'package:expandedflexible/screens/splash_screen.dart';
import 'package:expandedflexible/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousproducts) => Products(
              previousproducts == null ? [] : previousproducts.items,
              auth.token,
              auth.userId),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(
              previous == null ? [] : previous.ordrslist,
              auth.token,
              auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter chat ui',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          // home: ProductOverView(),
          home: auth.isAuth
              ? ProductOverView()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : snapshot.data == false
                              ? AuthScreen()
                              : ProductOverView(),
                ),
          routes: {
            CartScreen.routName: (context) => CartScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            OrderScreen.routName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
