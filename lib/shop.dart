import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// import './provider/product.dart';
import './widgets/product_item.dart';
import '../provider/products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animate_do/animate_do.dart';

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

    List<String> categories = ["All", "Sneakers", "Boots", "Heels", "Sandals"];
    List<String> imageList = [
      'images/Black and White Minimalist Shoes Promotion Instagram Post.png',
      'images/Brown Modern New Arrival Instagram Post.png',
      'images/Brown Modern Shoes Sale Instagram Post.png',
    ];

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
        : Column(
            children: [
              SizedBox(
                height: 30,
              ),
              CarouselSlider(
                items: imageList.map((item) {
                  return Container(
                    child: Image.asset(
                      item,
                      fit: BoxFit.fill,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  enableInfiniteScroll: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((category) {
                    return AspectRatio(
                      aspectRatio: 2.2 / 1,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1000 + (index * 100)),
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                    itemCount: product.length),
              ),
            ],
          );
  }
}
