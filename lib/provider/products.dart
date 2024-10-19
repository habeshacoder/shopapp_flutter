// ignore_for_file: prefer_final_fields

import 'package:online_market/provider/product.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//

class Products with ChangeNotifier {
  List<Product> _item = [];

  final token;
  final userId;
  Products(this._item, this.token, this.userId);

  Future<void> fetchAndPutData() async {
    var url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products.json?auth=$token');
    try {
      final response = await http.get(Uri.parse(url));
      //
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/userfavorites/$userId.json?auth=$token');
      final favoriteResponse = await http.get(Uri.parse(url));
      final extractedFavorite = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      //
      extractedData.forEach(
        (prokey, provalue) {
          loadedProducts.add(
            Product(
              id: prokey,
              title: provalue['title'],
              description: provalue['description'],
              price: provalue['price'],
              imageUrl: provalue['imageurl'],
              // isFavorite: provalue['isfavorite'],
              isFavorite: extractedData == null
                  ? false
                  : extractedData['prokey'] ?? false,
            ),
          );
        },
      );
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {}
  }

  var showOnlyFavorites = false;
  List<Product> get items {
    return [..._item];
  }

  List<Product> get onlyFavorites {
    return _item.where((element) => element.isFavorite).toList();
  }

  Product getById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product userProduct) async {
    final url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products.json?auth=$token');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': userProduct.title,
            'description': userProduct.description,
            'price': userProduct.price,
            'imageurl': userProduct.imageUrl,
            // 'isfavorite': userProduct.isFavorite,
          },
        ),
      );
      final product = Product(
          id: json.decode(response.body)['name'],
          title: userProduct.title,
          description: userProduct.description,
          price: userProduct.price,
          imageUrl: userProduct.imageUrl);
      _item.insert(0, product);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final proindex = _item.indexWhere(
      (element) => element.id == id,
    );
    if (proindex >= 0) {
      final url =
          ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products/$id.json?auth=$token');

      await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _item[proindex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProductbyid(String id) async {
    //
    final userproductindex = _item.indexWhere((element) => element.id == id);
    Product? product = _item[userproductindex];
    _item.removeWhere((element) => element.id == id);
    notifyListeners();
    final url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products/$id.json?auth=$token');

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _item.insert(userproductindex, product);
      notifyListeners();
      throw (response);
    }

    product = null;
  }
}
