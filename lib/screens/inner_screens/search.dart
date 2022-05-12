import 'package:dmazcofresh/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../services/firebase_database.dart';
import '../widgets/snack_bar.dart';
import 'product_overview.dart';

List<Map<String, dynamic>>? productsData;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseDatabase _database = FirebaseDatabase();
  //

  _getProductsData() async {
    productsData = await _database.getProductsData(category: "Chicken");
    setState(() {});
  }

  @override
  void initState() {
    _getProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text("Search"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchView());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: productsData != null
          ? ListView.separated(
              itemCount: productsData!.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10),
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductOverview(
                          productID: productsData![index]["productId"],
                        ),
                      ),
                    );
                  },
                  leading: Image.network(
                    productsData![index]["productImage"],
                  ),
                  title: Text(productsData![index]["productTitle"].toString()),
                  subtitle: Text(
                    "\$ " +
                        (productsData![index]["units"].values.first * 0.1)
                            .toString(),
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: Consumer<ProductProvider>(
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          value.addNewOrder(
                            product: Product(
                              productCategory: "Chicken",
                              productDescription: productsData![index]
                                  ["productDescription"],
                              productId: productsData![index]["productId"],
                              productImage: productsData![index]
                                  ["productImage"],
                              productPrice:
                                  productsData![index]["units"].values.first,
                              productTitle: productsData![index]
                                  ["productTitle"],
                              productUnit:
                                  productsData![index]["units"].keys.first,
                              amount: 1,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar(
                              message: productsData![index]["productTitle"] +
                                  " added to the Shopping Cart",
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: const Text(
                            "+ ADD",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            ),
    );
  }
}

class SearchView extends SearchDelegate {
  List<Map<String, dynamic>>? filterProducts;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filterProducts = productsData!
        .where((product) => product["productTitle"].contains(query))
        .toList();
    return ListView.separated(
      itemCount: filterProducts!.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductOverview(
                  productID: productsData![index]["productId"],
                ),
              ),
            );
          },
          leading: Image.network(
            productsData![index]["productImage"],
          ),
          title: Text(productsData![index]["productTitle"].toString()),
          subtitle: Text(
            "\$ " +
                (productsData![index]["units"].values.first * 0.1).toString(),
            style: const TextStyle(color: Colors.green),
          ),
          trailing: InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              child: const Text(
                "+ ADD",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
