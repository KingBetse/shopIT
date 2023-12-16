import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class Edit_Screen extends StatefulWidget {
  const Edit_Screen({super.key});
  static const routename = './editScreen';
  @override
  State<Edit_Screen> createState() => _Edit_ScreenState();
}

class _Edit_ScreenState extends State<Edit_Screen> {
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments ?? '';
      print(productId);
      // ignore: unnecessary_null_comparison
      if (productId != '') {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceNode.dispose();
    _descriptionNode.dispose();
    _imageNode.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });

    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .UpdateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("an error Occured"),
                  content: Text('Something went wrong '),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(label: Text("Title")),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        onSaved: (newValue) => {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: newValue!,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl)
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Provide the Value";
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(label: Text("Price")),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceNode,
                        onSaved: (newValue) => {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(newValue!),
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite)
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Provide the Value";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please Provide the Correct Value";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please Provide the price above 0";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(label: Text("Description")),
                        // textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionNode);
                        },
                        onSaved: (newValue) => {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: newValue!,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite)
                        },
                        focusNode: _descriptionNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Provide the Value";
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  color: Colors.grey),
                              child: _imageController.text.isEmpty
                                  ? Center(child: Text("Enter a URL"))
                                  : FittedBox(
                                      child: Image.network(
                                        _imageController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Imagen URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageNode,
                              onSaved: (newValue) => {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    isFavourite: _editedProduct.isFavourite,
                                    imageUrl: newValue!)
                              },
                              onFieldSubmitted: (value) => _saveForm(),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Provide the Image URL";
                                }
                                if (!value!.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return "Please enter Valid URL";
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}