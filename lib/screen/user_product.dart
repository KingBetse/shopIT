import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/userProductItems.dart';
import '../tabScreen.dart';
import './editScreen.dart';

class UserProduct extends StatelessWidget {
  static const routeName = "./userProduct";

  const UserProduct({super.key});

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context, listen: false).items;
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Edit_Screen.routename);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.of(context).pushNamed(Edit_Screen.routename);
        },
        child: const Icon(Icons.add,
            color: Color.fromARGB(255, 0, 0, 0), size: 25),
      ),
      drawer: TabScreen(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productsData, _) => SizedBox(
                    height: 800,
                    width: double.infinity,
                    child: ListView(shrinkWrap: true, children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        // child: Center(
                        //   child: Text('abebe'),
                        // ),.values.toList()[i].

                        child: productsData.items.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 300),
                                child: Center(
                                    child: Text("You didn't post anything")))
                            : Column(
                                children: productsData.items.map((e) {
                                  // print(e.id);
                                  return ListTile(
                                    title: Text(e.title),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(e.imageUrl),
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    Edit_Screen.routename,
                                                    arguments: e.id);
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                Provider.of<Products>(context,
                                                        listen: false)
                                                    .deleteProdct(e.id);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                    ]),
                  ),
                )),
      ),
    );
  }
}
