import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_it/screen/cart_screen.dart';

import 'package:shop_it/screen/product_detail.dart';

import './tabScreen.dart';
import './shop.dart';
import './provider/products.dart';
import '../provider/cart.dart';
import './provider/order.dart';
import './screen/order_screen.dart';
import './screen/user_product.dart';
import './screen/editScreen.dart';
import './screen/auth_screen.dart';
import './provider/auth.dart';

void main() => runApp(const MyApp());

enum FilterOpp { Favorites, All }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (context, auth, previousProducts) => Products(
            auth.token.toString(),
            auth.userId.toString(),
            previousProducts == null ? [] : previousProducts.Items,
          ),
          // create: (context) => Products(),
          // )
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (contex) => Orders('', '', []),
          update: (context, value, previous) => Orders(
            value.token.toString(),
            value.userId.toString(),
            previous == null ? [] : previous.orders,
          ),
        ),
        ChangeNotifierProvider(
          create: (contex) => OrderItem(
              id: '', amount: 0, product: [], daeTime: DateTime.now()),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            fontFamily: "Lato",
            // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            //     .copyWith(secondary: Colors.deepOrange)),
          ),
          home: auth.isAuth ? MyHomePage() : AuthScreen(),
          routes: {
            Product_detail.routeName: (context) => const Product_detail(),
            Cart_Screen.routeName: (context) => const Cart_Screen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            UserProduct.routeName: (context) => const UserProduct(),
            Edit_Screen.routename: (context) => const Edit_Screen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var showOnlyFavorite = false;
  var _isloading = false;
  @override
  void initState() {
    _isloading = true;

    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false).fetchProduct().then((_) {
        setState(() {
          _isloading = false;
        });
      });
    });
    super.initState();
  }

  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ShopIT"), actions: [
          PopupMenuButton(
            onSelected: (FilterOpp selectedValue) {
              setState(() {
                if (selectedValue == FilterOpp.Favorites) {
                  showOnlyFavorite = true;
                } else {
                  showOnlyFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: FilterOpp.Favorites, child: Text('Favorite')),
              const PopupMenuItem(
                value: FilterOpp.All,
                child: Text("All"),
              )
            ],
          ),
          Consumer<Cart>(
              builder: (context, valuee, child) => Badge(
                    label: Text(valuee.itemCount.toString()),
                    child: child,
                  ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(Cart_Screen.routeName),
              ))
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.all_out),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
          ],
          currentIndex: myIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
        ),
        drawer: const TabScreen(),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
            // shopPage(showOnlyFavorite)
            shopPage(myIndex));
  }
}
