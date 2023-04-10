import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.id, required this.tableNo});

  final String id;
  final String tableNo;

  //todo mobilde giren kullanıcılar id'leri ile databasede saklanıyor. masanın adisyon yönetimi
  //todo bu id'ler ile sağlanıyor. webte user id olmadığı için özel bir çözüm üretilmeli

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersPage(
                ordersRef: FirebaseFirestore.instance
                    .collection("Restaurants/${id}/Tables")
                    .doc(tableNo)
                    .collection("Orders"),
                tableRef: FirebaseFirestore.instance
                    .collection("Restaurants/${id}/Tables")
                    .doc(tableNo),
              ),
            ),
          );
        },
        child: const Icon(Icons.shopping_basket),
      ),
      appBar: AppBar(
        title: RestaurantNameText(
          id: id,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Restaurants/$id/MenuCategory")
            .orderBy("name", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                //restorant menüsü kategorileri listeleme
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryItemsList(
                          restaurantPath: "Restaurants/$id",
                          selectedCategory: document['name'],
                          table: tableNo,
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

class CategoryItemsList extends StatelessWidget {
  const CategoryItemsList(
      {Key? key,
        required this.restaurantPath,
        required this.selectedCategory,
        required this.table})
      : super(key: key);

  final String restaurantPath;
  final String selectedCategory;
  final String table;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersPage(
                tableRef: FirebaseFirestore.instance
                    .collection("$restaurantPath/Tables")
                    .doc(table),
                ordersRef: FirebaseFirestore.instance
                    .collection("$restaurantPath/Tables")
                    .doc(table)
                    .collection("Orders"),
              ),
            ),
          );
        },
        child: const Icon(Icons.shopping_basket),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(
              '$restaurantPath/MenuCategory/$selectedCategory/list')
              .orderBy('name', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  //kategornin içindeki ürünleri listeme
                  //todo fiyat, yorum, estimated time vb diğer bilgiler
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.emoji_food_beverage),
                      title: Text(document['name']),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection("$restaurantPath/Tables")
                              .doc(table)
                              .collection("Orders")
                              .where("itemRef", isEqualTo: document.reference)
                              .get();
                          if (querySnapshot.size > 0) {
                            // Item already exists in order, update its quantity
                            final orderDoc = querySnapshot.docs.first;
                            final quantity = orderDoc["quantity_notSubmitted_notServiced"] + 1;
                            orderDoc.reference.update({"quantity_notSubmitted_notServiced": quantity});
                          } else {
                            // Item doesn't exist in order, add it with quantity 1
                            FirebaseFirestore.instance
                                .collection("$restaurantPath/Tables")
                                .doc(table)
                                .collection("Orders")
                                .doc()
                                .set({
                              "itemRef": document.reference,
                              "quantity_notSubmitted_notServiced" : 1,
                              "quantity_Submitted_notServiced" : 0,
                              "quantity_Submitted_Serviced" : 0,
                            });
                          }
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

class RestaurantNameText extends StatelessWidget {
  const RestaurantNameText({Key? key, required this.id}) : super(key: key);
  final String id;

  //restorant id'sinden restorant ismini Text Widget olarak döndürme

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("Restaurants").doc(id).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!['name']);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
