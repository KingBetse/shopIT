import 'package:flutter/material.dart';

class UserProdItems extends StatelessWidget {
  final String ctitle;
  final String cimgUrl;
  // ignore: non_constant_identifier_names, prefer_const_constructors_in_immutables
  UserProdItems(String title, {required this.ctitle, required this.cimgUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ctitle),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(cimgUrl),
      ),
      trailing: SizedBox(
        width: 100,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
