import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/cart_screen.dart';

import '../provider/cart.dart';

class CartItems extends StatelessWidget {
  final String cid;
  final String productId;
  final String ctitle;
  final double price;
  final int quantity;

  const CartItems(
    String id,
    String list,
    String title, {
    super.key,
    required this.cid,
    required this.productId,
    required this.ctitle,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Are you Sure?"),
            content:
                const Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Yes'))
            ],
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItems(productId);
        // Provider.of<Cart>(context, listen: false).removeItems(productId);

        // Navigator.of(context).pushReplacementNamed(Cart_Screen.routeName);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(ctitle),
          subtitle: Text('Total:\$${price * quantity}'),
          trailing: Text('$quantity x'),
          // IconButton(
          //     onPressed: () => Provider.of<Cart>(context, listen: false)
          //         .removeItems(productId),
          //     icon: Icon(Icons.delete)),
        ),
      ),
    );

    // );
  }
}
