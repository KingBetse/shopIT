import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_it/provider/cart.dart';
import 'package:shop_it/provider/product.dart';
import 'package:shop_it/provider/products.dart';
import 'package:shop_it/screen/product_detail.dart';

class Product_item extends StatelessWidget {
  final bool showFav;
  // final String id;
  // final String title;
  // final String imageUrl;
  const Product_item(this.showFav, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final productContainer = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final products = productsData.Items;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, products, child) => IconButton(
              icon: Icon(
                products.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                products.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            productContainer.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: const Icon(
                Icons.shopping_cart_checkout_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                cart.addItems(productContainer.id, productContainer.price,
                    productContainer.title);
                // Scaffold.of(context).ShowS
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Added to cart"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeOne(productContainer.id);
                      }),
                ));
              }),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(Product_detail.routeName,
              arguments: productContainer.id),
          child: Image.network(
            productContainer.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
