import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// import './provider/product.dart';
import './widgets/product_item.dart';
import '../provider/products.dart';

class shopPage extends StatelessWidget {
  // final List<Product> loadedProduct =
  // final bool showFavourite;
  final int index;
  static const routeName = '/';

  // const shopPage(this.showFavourite, {super.key});
  const shopPage(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final product =
        index == 1 ? productsData.favouriteItems : productsData.items;
    // print("$productsData.favouriteItems");

    return product.isEmpty && index == 1
        ? Center(
            child: Text(
              'No Favorite Added',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Anton',
                fontWeight: FontWeight.w300,
              ),
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: product[i],
                  // create: (c) => products[i],
                  child: Product_item(index),
                ),
            padding: const EdgeInsets.all(10.0),
            itemCount: product.length);
  }
}
