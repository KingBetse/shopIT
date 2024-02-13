import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

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
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context)
        .items
        .firstWhere((prod) => prod.id == id);

    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title)),
      body: Column(
        children: [
          Container(
            child: Image.network(loadedProduct.imageUrl),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            loadedProduct.title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              loadedProduct.description,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              '${loadedProduct.price} \$',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
