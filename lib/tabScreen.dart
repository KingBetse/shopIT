import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_it/provider/auth.dart';
import 'package:shop_it/screen/user_product.dart';
import './provider/auth.dart';

import './screen/order_screen.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("ShoeIT"),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(
              Icons.shopify,
              size: 30,
            ),
            title: const Text(
              "MyShop",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              leading: const Icon(
                Icons.card_giftcard,
                size: 30,
              ),
              title: const Text("My Order", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              }),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              leading: const Icon(
                Icons.description,
                size: 30,
              ),
              title: const Text("My Product", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProduct.routeName);
              }),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text("Log Out", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logOut();
              }),
        ],
      ),
    );
  }
}
