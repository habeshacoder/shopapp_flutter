import 'package:expandedflexible/provider/product.dart';
import 'package:expandedflexible/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/editproductscreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final imagecontroller = TextEditingController();
  final imagefocus = FocusNode();
  final priceFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var isLoading = false;
  var product = Product(
    id: 'null',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );
  @override
  void initState() {
    imagefocus.addListener(updateimageurl);
    super.initState();
  }

  void updateimageurl() {
    //
    if (!imagefocus.hasFocus) {
      if ((!imagecontroller.text.startsWith('http') &&
              !imagecontroller.text.startsWith('https')) ||
          (!imagecontroller.text!.endsWith('png') &&
              !imagecontroller.text.endsWith('jpg') &&
              !imagecontroller.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void saveform() async {
    bool validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (product.id != 'null') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(product.id, product);
    }
    //
    else {
      try {
        print(
            '...................from else befor add called..................');
        await Provider.of<Products>(context, listen: false).addProduct(product);
      } catch (erro) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('un known error '),
              content: const Text('something wrong happen..'),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('okay'),
                )
              ],
            );
          },
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    imagecontroller.dispose();
    imagefocus.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
    // _form.dispose();
    super.dispose();
  }

  var initvalue = {};
  var init = true;
  @override
  void didChangeDependencies() {
    if (init) {
      if (ModalRoute.of(context)!.settings.arguments == 'fromadd') {
        return;
      }
      String proid = ModalRoute.of(context)!.settings.arguments as String;
      if (proid != null) {
        product = Provider.of<Products>(context).getById(proid);

        initvalue = {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageurl': '',
        };
        imagecontroller.text = product.imageUrl;
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var appBar2 = AppBar(
      actions: [
        IconButton(
          onPressed: () {
            saveform();
          },
          icon: Icon(Icons.save),
        ),
      ],
      title: const Text('edit user product'),
    );
    return Scaffold(
      appBar: appBar2,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initvalue['title'],
                      decoration: const InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceFocus);
                      },
                      onSaved: (newValue) {
                        product = Product(
                          id: product.id,
                          title: newValue!,
                          description: product.description,
                          price: product.price,
                          imageUrl: product.imageUrl,
                          isFavorite: product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please provide title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initvalue['price'].toString(),
                      decoration: const InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(descriptionFocus);
                      },
                      focusNode: priceFocus,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        product = Product(
                          id: product.id,
                          title: product.title,
                          description: product.description,
                          price: double.parse(newValue!),
                          imageUrl: product.imageUrl,
                          isFavorite: product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please provide price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please  provide valid value';
                        }
                        if (double.tryParse(value)! <= 0) {
                          return 'price can not be zero. provide valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initvalue['description'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please provide description';
                        }
                        if (value.length < 10) {
                          return 'it is very short.provide a word with minimum length of 10 ';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'description'),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus();
                      },
                      maxLines: 3,
                      focusNode: descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      onSaved: (newValue) {
                        product = Product(
                          title: product.title,
                          description: newValue!,
                          price: product.price,
                          imageUrl: product.imageUrl,
                          isFavorite: product.isFavorite,
                          id: product.id,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          height: 100,
                          color: Colors.grey,
                          width: 100,
                          child: imagecontroller.text.isEmpty
                              ? const Text(
                                  'no image selected',
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(imagecontroller.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: initvalue['imageurl'],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please provide image url';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'please provide a valid image url';
                              }

                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'please provide valid image url';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'image url'),
                            focusNode: imagefocus,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imagecontroller,
                            onFieldSubmitted: (_) {
                              saveform();
                            },
                            onSaved: (newValue) {
                              product = Product(
                                id: product.id,
                                title: product.title,
                                description: product.description,
                                price: product.price,
                                imageUrl: newValue!,
                                isFavorite: product.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
