import 'package:online_market/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String titel;
  // const ProductDetailScreen({
  //   required this.titel,
  // });
  static String routeName = '/productDetailScreen';

  const ProductDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context)?.settings.arguments as String;
    final correntProduct = Provider.of<Products>(context).getById(productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          correntProduct.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                  correntProduct.imageUrl,
                ),
              ),
            ),
            Text(
              '${correntProduct.price}',
            ),
            Text(
              correntProduct.description,
              softWrap: true,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
