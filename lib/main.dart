// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison

// import 'package:online_market/screens/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:online_market/provider/auth.dart';
import 'package:online_market/provider/cart.dart';
import 'package:online_market/provider/orders.dart';
import 'package:online_market/provider/products.dart';
import 'package:online_market/screens/auth_screen.dart';
import 'package:online_market/screens/cart_screen.dart';
import 'package:online_market/screens/edit_product_sreen.dart';
import 'package:online_market/screens/order_screen.dart';
import 'package:online_market/screens/product_detail_screen.dart';
import 'package:online_market/screens/products_overview_screen.dart';
import 'package:online_market/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products([], '', ''),
          update: (context, auth, previousProducts) => Products(
            previousProducts?.items ?? [],
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders([], ''),
          update: (context, auth, previous) => Orders(
            previous?.ordrslist ?? [],
            auth.token,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Chat UI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home: auth.isAuth ? ProductOverView() : AuthScreen(),
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
