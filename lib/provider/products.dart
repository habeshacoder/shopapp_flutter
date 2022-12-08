// ignore_for_file: prefer_final_fields

import 'dart:ffi';
import 'dart:io';

import 'package:expandedflexible/provider/product.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//

class Products with ChangeNotifier {
  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final token;
  final userId;
  Products(this._item, this.token, this.userId);

  Future<void> fetchAndPutData({bool filterByUser = false}) async {
    final filterUserProduct =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products.json?auth=$token&$filterUserProduct');
    print('.........................before get in products');
    print('token value is ..........:' + token);
    try {
      final response = await http.get(url);
      //
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/userfavorites/$userId.json?auth=$token');
      final favoriteResponse = await http.get(url);
      final extractedFavorite = json.decode(favoriteResponse.body);
      print('...........................:');
      print(json.decode(response.body));
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
    } catch (error) {
      print(
        'error ..............................: ' + error.toString(),
      );
    }
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
    print('................from try before http.post....');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': userProduct.title,
            'description': userProduct.description,
            'price': userProduct.price,
            'imageurl': userProduct.imageUrl,
            // 'isfavorite': userProduct.isFavorite,
            'creatorId': userId,
          },
        ),
      );
      print('after http.post called ...............');
      final product = Product(
          id: json.decode(response.body)['name'],
          title: userProduct.title,
          description: userProduct.description,
          price: userProduct.price,
          imageUrl: userProduct.imageUrl);
      _item.insert(0, product);
      notifyListeners();
    } catch (error) {
      print(error.toString() + '.................................');
      throw error;
    }

    print('after notify listners..................');
  }

  Future<void> updateProduct(String id, Product product) async {
    final proindex = _item.indexWhere(
      (element) => element.id == id,
    );
    if (proindex >= 0) {
      final url =
          ('https://shopapp-2fcdd-default-rtdb.firebaseio.com/Products/$id.json?auth=$token');

      await http.patch(
        url,
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

    print('......................befre http.delte.............');
    final response = await http.delete(url);
    print(response.statusCode);
    print('.....................after......http.delete......');
    if (response.statusCode >= 400) {
      print('before insert in if......................');
      _item.insert(userproductindex, product);
      notifyListeners();
      print('after insert in if.................................');
      throw (response);
    }

    product = null;
  }
}
