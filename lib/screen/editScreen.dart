import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
  final _discountNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageNode = FocusNode();
  final _brandNode = FocusNode();
  final _sizeNode = FocusNode();

  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    brand: '',
    size: '',
    gender: '',
    discount: 0,
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'brand': '',
    'size': '',
    'gender': '',
    'discount': ''
  };
  // String imageUrl = '';
  var isLoading = false;
  var _isInit = true;
  var _isSwitched = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments ?? '';
      // print(productId);
      // ignore: unnecessary_null_comparison
      if (productId != '') {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'discount': _editedProduct.discount.toString(),
          'imageUrl': '',
          'brand': _editedProduct.brand,
          'size': _editedProduct.size,
          'gender': _editedProduct.gender,
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
    _discountNode.dispose();
    _descriptionNode.dispose();
    _imageNode.dispose();
    _sizeNode.dispose();
    _imageController.dispose();
    super.dispose();
  }

  File? _imageFile;
  String? _imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _uploadImage() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dxbtmycgb/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'rozzbjog'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      setState(() {
        final url = jsonMap['url'];
        _imageUrl = url;
      });
    }
  }

  double disCalc(double price, double disc) {
    price = price * (disc / 100);
    return price;
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

  String dropDown = "Nike";
  String dropGender = "Male";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
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
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          label: Text("Title"),
                          border: OutlineInputBorder(),
                        ),
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
                              imageUrl: _editedProduct.imageUrl,
                              brand: _editedProduct.brand,
                              size: _editedProduct.size,
                              gender: _editedProduct.gender,
                              discount: _editedProduct.discount)
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Provide the Value";
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          label: Text("Price"),
                          border: OutlineInputBorder(),
                        ),
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
                              brand: _editedProduct.brand,
                              size: _editedProduct.size,
                              gender: _editedProduct.gender,
                              discount: _editedProduct.discount,
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
                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          label: Text("Description"),
                          border: OutlineInputBorder(),
                        ),
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
                              brand: _editedProduct.brand,
                              size: _editedProduct.size,
                              gender: _editedProduct.gender,
                              discount: _editedProduct.discount,
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
                        children: [
                          Text(
                            "Brand :",
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 26),
                            child: DropdownButton<String>(
                              value: dropDown,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Nike"),
                                  value: 'Nike',
                                ),
                                DropdownMenuItem(
                                  child: Text("Adidas"),
                                  value: 'Adidas',
                                ),
                                DropdownMenuItem(
                                  child: Text("Crocs"),
                                  value: 'Crocs',
                                ),
                                DropdownMenuItem(
                                  child: Text("Gucci"),
                                  value: 'Gucci',
                                ),
                                DropdownMenuItem(
                                  child: Text("Other"),
                                  value: 'Other',
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  // _editedProduct.brand = newValue.toString();
                                  dropDown = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Gender :",
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 26),
                            child: DropdownButton<String>(
                              value: dropGender,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Male"),
                                  value: 'Male',
                                ),
                                DropdownMenuItem(
                                  child: Text("Woman"),
                                  value: 'Woman',
                                ),
                                DropdownMenuItem(
                                  child: Text("Unisex"),
                                  value: 'Unisex',
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  // _editedProduct.gender = newValue.toString();
                                  dropGender = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initValues['size'],
                        decoration: InputDecoration(
                          label: Text("Size"),
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        onSaved: (newValue) => {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            brand: _editedProduct.brand,
                            size: newValue!,
                            gender: _editedProduct.gender,
                            discount: _editedProduct.discount,
                          )
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Provide the Value";
                          }
                        },
                      ),

                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Text("Discount:"),
                      //       Switch(
                      //           value: _isSwitched,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               _isSwitched = value;
                      //             });
                      //           }),
                      //     ]),
                      // _isSwitched == true
                      //     ?
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // TextFormField(
                      //   initialValue: _initValues['discount'],
                      //   decoration: InputDecoration(
                      //     label: Text("Discount"),
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   // textInputAction: TextInputAction.next,
                      //   keyboardType: TextInputType.number,
                      //   // maxLines: 3,
                      //   onFieldSubmitted: (_) {
                      //     FocusScope.of(context).requestFocus(_discountNode);
                      //   },
                      //   onSaved: (newValue) => {
                      //     _editedProduct = Product(
                      //       id: _editedProduct.id,
                      //       title: _editedProduct.title,
                      //       description: _editedProduct.description,
                      //       price: _editedProduct.price,
                      //       imageUrl: _editedProduct.imageUrl,
                      //       brand: _editedProduct.brand,
                      //       isFavourite: _editedProduct.isFavourite,
                      //       size: _editedProduct.size,
                      //       gender: _editedProduct.gender,
                      //       discount: double.parse(newValue!),
                      //     )
                      //   },
                      //   focusNode: _discountNode,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "Please Provide the Value";
                      //     }
                      //     if (double.tryParse(value) == null) {
                      //       return "Please Provide the Correct Value";
                      //     }
                      //     if (double.parse(value) <= 0) {
                      //       return "Please Provide the price above 0";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // : Text(""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  color: Colors.grey),
                              child: _imageController.text.isEmpty
                                  ? Center(child: Text("Image"))
                                  : FittedBox(
                                      child: _imageFile != null
                                          ? Image.file(_imageFile!)
                                          : Image.network(
                                              _imageController.text,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                          Expanded(
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.camera),
                                  onPressed: () {
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                                // if (_imageFile != null) ...[
                                //   // Image.file(_imageFile!),
                                //   ElevatedButton(
                                //     onPressed: () async {
                                //       await _uploadImage();
                                //       _imageController.text = _imageUrl!;
                                //       _editedProduct = Product(
                                //           id: _editedProduct.id,
                                //           title: _editedProduct.title,
                                //           description:
                                //               _editedProduct.description,
                                //           price: _editedProduct.price,
                                //           isFavourite:
                                //               _editedProduct.isFavourite,
                                //           imageUrl: _imageUrl!);
                                //     },
                                //     child: Text("upload"),
                                //   )
                                // ],
                                IconButton(
                                  icon: Icon(Icons.file_upload),
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                                if (_imageFile != null) ...[
                                  // Image.file(_imageFile!),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _uploadImage();
                                      _imageController.text = _imageUrl!;
                                      _editedProduct = Product(
                                        id: _editedProduct.id,
                                        title: _editedProduct.title,
                                        description: _editedProduct.description,
                                        price: _editedProduct.price,
                                        isFavourite: _editedProduct.isFavourite,
                                        imageUrl: _imageUrl!,
                                        brand: _editedProduct.brand,
                                        size: _editedProduct.size,
                                        gender: _editedProduct.gender,
                                        discount: _editedProduct.discount,
                                      );
                                    },
                                    child: Text("upload"),
                                  )
                                ],
                                // if (_imageUrl != null) ...[
                                //   // Image.network(_imageUrl!),
                                //   // Text(" the down load link is :$_imageUrl")
                                // ]
                              ],
                            ),

                            //    IconButton(
                            // onPressed: () async {
                            // print("hi");
                            // ImagePicker imagePicker = ImagePicker();
                            // XFile? file = await imagePicker.pickImage(
                            //     source: ImageSource.gallery);
                            // print("hi");
                            // print('${file?.path}');

                            // if (file == null) return;

                            // String uniquee = DateTime.now()
                            //     .microsecondsSinceEpoch
                            //     .toString();
                            // //Get a referance to storage root
                            // Reference referenceRoot =
                            //     FirebaseStorage.instance.ref();

                            // Reference referenceDirImage = referenceRoot.child(
                            //     'https://gs://shopit-a52e1.appspot.com/images');

                            // //create a reference for the image to be stored
                            // Reference referenceImageToUpload =
                            //     referenceDirImage.child(uniquee);
                            // try {
                            //   //store the file
                            //   await referenceImageToUpload
                            //       .putFile(File(file.path));
                            //   imageUrl = await referenceImageToUpload
                            //       .getDownloadURL();
                            //   print("ewwwwweeee");
                            // } catch (error) {
                            //   print("weeeeeeeeeeee   $error");
                            // }
                            // print("fdfdfdfdfd");

                            // },
                            // icon: Icon(Icons.camera_alt),
                            // )

                            //     TextFormField(
                            //   decoration:
                            //       InputDecoration(labelText: 'Imagen URL'),
                            //   keyboardType: TextInputType.url,
                            //   textInputAction: TextInputAction.done,
                            //   focusNode: _imageNode,
                            //   onSaved: (newValue) => {
                            //     _editedProduct = Product(
                            //         id: _editedProduct.id,
                            //         title: _editedProduct.title,
                            //         description: _editedProduct.description,
                            //         price: _editedProduct.price,
                            //         isFavourite: _editedProduct.isFavourite,
                            //         imageUrl: newValue!)
                            //   },
                            //   onFieldSubmitted: (value) => _saveForm(),
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Please Provide the Image URL";
                            //     }
                            //     if (!value!.startsWith('http') &&
                            //         !value.startsWith('https')) {
                            //       return "Please enter Valid URL";
                            //     }
                            //   },
                            // ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
