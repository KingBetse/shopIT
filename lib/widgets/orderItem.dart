import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart' as or;
import '../screen/order_screen.dart';

class OrderItem extends StatefulWidget {
// final String id;
// final String title;
// final double amount;
// final int quantity;
  final or.OrderItem order;
  final or.Orders k;

  const OrderItem(this.order, this.k, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expand = false;
  // OrderItem({
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print(widget.k.userId);
        print(widget.order.id);
        widget.k.deleteProdct(widget.k.userId, widget.order.id);
        Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
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
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
                title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
                subtitle: Text(DateFormat('dd MM yyyy mm:hh')
                    .format(widget.order.daeTime)),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _expand = !_expand;
                      });
                    },
                    icon:
                        Icon(_expand ? Icons.expand_less : Icons.expand_more))),
            if (_expand)
              Container(
                margin: const EdgeInsets.all(10),
                height: min(widget.order.product.length * 10 + 50, 180),
                child: ListView.builder(
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order.product[index].title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                          "${widget.order.product[index].price} * ${widget.order.product[index].quantity} ",
                          style: const TextStyle(fontSize: 15)),
                      // IconButton(
                      //     onPressed: () {
                      //       print(widget.k.userId);
                      //       print(widget.order.id);
                      //       widget.k
                      //           .deleteProdct(widget.k.userId, widget.order.id);
                      //       widget.k.fetchOrder();
                      //     },
                      //     icon: Icon(Icons.delete))
                    ],
                  ),
                  itemCount: widget.order.product.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
