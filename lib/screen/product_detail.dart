import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

import 'package:animate_do/animate_do.dart';

import 'package:provider/provider.dart';

import 'package:shop_it/provider/cart.dart';
import 'package:shop_it/provider/product.dart';
import 'package:shop_it/provider/products.dart';

class Product_detail extends StatelessWidget {
  static const routeName = '/product_detail';

  const Product_detail({super.key});
  // final String id;
  // final String title;
  // final String description;
  // final double price;

  // final String imageUrl;

  // Product_detail(
  //     this.id, this.title, this.description, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context)
        .items
        .firstWhere((prod) => prod.id == id);
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title)),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red.shade100),
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loadedProduct.title,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      child: Text(
                        '${loadedProduct.price} Br',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  loadedProduct.description,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   child: GestureDetector(
                //     child: Container(
                //       // alignment: Alignment.centerLeft,
                //       margin: const EdgeInsets.symmetric(horizontal: 30),
                //       child: Text(
                //         loadedProduct.description,
                //         style: const TextStyle(
                //             fontSize: 20, fontWeight: FontWeight.w500),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Available Sizes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: loadedProduct.size.split(',').map((size) {
                    return AvailableSize(text: size.trim());
                  }).toList(),
                  // children: [
                  //   AvailableSize(text: '11'),
                  //   AvailableSize(text: '12'),
                  //   AvailableSize(text: '13'),
                  // ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Available Colors",
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: const [
                //     CircleAvatar(
                //       radius: 16,
                //       backgroundColor: Colors.red,
                //     ),
                //     SizedBox(
                //       width: 8.0,
                //     ),
                //     CircleAvatar(
                //       radius: 16,
                //       backgroundColor: Colors.amber,
                //     ),
                //     SizedBox(
                //       width: 8.0,
                //     ),
                //     CircleAvatar(
                //       radius: 16,
                //       backgroundColor: Colors.black,
                //     ),
                //   ],
                // ),

                SizedBox(
                  height: 60,
                ),
                FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => {
                            cart.addItems(loadedProduct.id, loadedProduct.price,
                                loadedProduct.title),
                            // Scaffold.of(context).ShowS
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Added to cart"),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () {
                                    cart.removeOne(loadedProduct.id);
                                  }),
                            )),

                            Navigator.pop(context),
                          },
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class AvailableSize extends StatefulWidget {
  final String text;

  const AvailableSize({required this.text});

  @override
  _AvailableSizeState createState() => _AvailableSizeState();
}

class _AvailableSizeState extends State<AvailableSize> {
  bool isSelected = false;

  void _toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Container(
        margin: const EdgeInsets.only(right: 16.0),
        width: 40.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? Colors.grey : Colors.grey,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
