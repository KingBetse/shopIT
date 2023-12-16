import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_it/provider/cart.dart' show Cart;
import 'package:shop_it/provider/order.dart';
import '../widgets/cartItem.dart';

class Cart_Screen extends StatelessWidget {
  const Cart_Screen({super.key});
  static const routeName = './cartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    final orderitem = Provider.of<OrderItem>(context, listen: false);

    Future<void> _addOrder() async {
      try {
        await Provider.of<Orders>(context, listen: false)
            .addOrder(cart.item.values.toList(), cart.totalAmount);
        // print(cart.item.values.map(
        //   (e) => e.price,
        // ));
        cart.clear();
      } catch (error) {
        return showDialog<Null>(
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
    // final product = Provider.of<Product>(context);
    // final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 10,
                ),
                Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}')),
                const SizedBox(
                  width: 100,
                ),
                TextButton(
                  child: Text("ORDER NOW"),
                  onPressed: cart.totalAmount <= 0 ? null : () => {_addOrder()},
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: cart.itemCount,
          itemBuilder: (context, i) => CartItems(
            cart.items.values.toList()[i].id,
            cart.items.keys.toList()[i],
            cart.items.values.toList()[i].title,
            price: cart.items.values.toList()[i].price,
            quantity: cart.items.values.toList()[i].quantity, cid: '',
            ctitle: '', productId: '',

            // cid: '',
            // ctitle: '',
          ),
        ))
      ]),
    );
  }
}
