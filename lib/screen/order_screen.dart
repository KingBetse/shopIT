import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_it/provider/cart.dart';
import 'package:shop_it/provider/order.dart' show Orders;
import 'package:shop_it/tabScreen.dart';
import '../widgets/orderItem.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "./orderScreen";

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Future? _orderFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrder();
  }

  void initState() {
    _orderFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final order = Provider.of<Orders>(context);
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Order"),
      ),
      drawer: const TabScreen(),
      body: FutureBuilder(
          future: _orderFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text("You go some Issue "),
                );
              } else {
                return Consumer<Orders>(
                  builder: ((context, order, child) => ListView.builder(
                        itemBuilder: (context, index) =>
                            OrderItem(order.order[index]),
                        itemCount: order.order.length,
                      )),
                );
              }
            }
          })),
    );
  }
}
