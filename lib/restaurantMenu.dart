import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.para1, required this.para2});

  final String para1;
  final String para2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(para1),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Restaurants/$para1/MenuCategory")
            .orderBy("name", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryItemsList(
                          collection: "Restaurants/$para1/MenuCategory",
                          selectedCategory: document['name'],
                          table: para2,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.emoji_food_beverage),
                      title: Text(document['name']),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class CategoryItemsList extends StatefulWidget {
  const CategoryItemsList(
      {Key? key,
      required this.collection,
      required this.selectedCategory,
      required this.table})
      : super(key: key);

  final String collection;
  final String selectedCategory;
  final String table;

  @override
  State<CategoryItemsList> createState() => _CategoryItemsListState();
}

class _CategoryItemsListState extends State<CategoryItemsList> {
  late List<dynamic> orders = [];

  void placeOrder() {
    // TODO send orders to firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Order List"),
              content: SizedBox(
                width: 500,
                height: 500,
                child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(orders[index]),
                          trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  orders.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              )),
                        ),
                      );
                    }),
              ),
              actions: [
                TextButton(
                  onPressed: placeOrder,
                  child: const Text("Place the Order"),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.shopping_basket),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(
                  '${widget.collection}/${widget.selectedCategory}/list')
              .orderBy('name', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.emoji_food_beverage),
                      title: Text(document['name']),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          orders.add(document['name']);
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
