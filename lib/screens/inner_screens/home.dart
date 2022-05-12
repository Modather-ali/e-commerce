import 'package:dmazcofresh/screens/inner_screens/product_overview.dart';
import 'package:dmazcofresh/services/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import 'favorite.dart';
import 'shopping.dart';
import '../widgets/product_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseDatabase _database = FirebaseDatabase();
  final List _productUnits = [];
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          'Products',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavoriteScreen()));
            },
            child: const CircleAvatar(
              backgroundColor: Colors.deepOrange,
              radius: 20,
              child: Icon(
                Icons.favorite,
                size: 17,
                color: Colors.white,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShoppingCart()));
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    radius: 20,
                    child: Icon(
                      Icons.shopping_cart,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Consumer<ProductProvider>(
                      builder: (context, value, child) {
                    return Text(
                      value.orders.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
              height: _screenHeight,
              width: _screenWidth,
              child: FutureBuilder(
                  future: _database.getProductsData(category: "Chicken"),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 180),
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductOverview(
                                    productID: snapshot.data![index]
                                        ["productId"],
                                  ),
                                ),
                              );
                            },
                            productImage: snapshot.data![index]["productImage"],
                            productName: snapshot.data![index]["productTitle"],
                            productUnits: snapshot.data![index]["units"],
                            productId: snapshot.data![index]["productId"],
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                      );
                    } else {
                      return const Center(
                          child: SizedBox(
                        height: 48,
                        width: 48,
                        child: CircularProgressIndicator(
                          color: Colors.deepOrange,
                        ),
                      ));
                    }
                  })),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
