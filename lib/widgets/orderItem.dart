import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart' as or;

class OrderItem extends StatefulWidget {
// final String id;
// final String title;
// final double amount;
// final int quantity;
  final or.OrderItem order;

  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expand = false;
  // OrderItem({
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
              title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
              subtitle: Text(
                  DateFormat('dd MM yyyy mm:hh').format(widget.order.daeTime)),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expand = !_expand;
                    });
                  },
                  icon: Icon(_expand ? Icons.expand_less : Icons.expand_more))),
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
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                        "${widget.order.product[index].price} * ${widget.order.product[index].quantity} ",
                        style: const TextStyle(fontSize: 15))
                  ],
                ),
                itemCount: widget.order.product.length,
              ),
            ),
        ],
      ),
    );
  }
}
