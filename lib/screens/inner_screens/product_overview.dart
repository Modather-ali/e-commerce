import 'package:dmazcofresh/models/product.dart';
import 'package:dmazcofresh/providers/product_provider.dart';
import 'package:dmazcofresh/screens/inner_screens/shopping.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_database.dart';

class ProductOverview extends StatefulWidget {
  String productID;

  ProductOverview({required this.productID});

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  final FirebaseDatabase _database = FirebaseDatabase();
  bool wishListBool = false;
  int amount = 1;
  String productUnit = "";
  Map productData = {};

  _getProductData() async {
    productData = await _database.getProductData(id: widget.productID);
    productUnit = productData["units"].keys.first;
    setState(() {});
  }

  _checkUserFavorite() async {
    Map<String, dynamic>? userData;
    List userFavorite;
    userData = await _database.getUserData();
    userFavorite = userData!["favorite"];
    setState(() {
      wishListBool = userFavorite.contains(widget.productID);
    });
  }

  @override
  void initState() {
    _getProductData();
    _checkUserFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          "Product Overview",
          style: TextStyle(),
        ),
      ),
      body: productData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          productData["productTitle"],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          height: 250,
                          padding: const EdgeInsets.all(40),
                          child: Image.network(
                            productData["productImage"],
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                "Available Options",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: productData["units"]
                                      .keys
                                      .first
                                      .toString(),
                                  groupValue: productUnit,
                                  onChanged: (val) {
                                    setState(() {
                                      productUnit = val.toString();
                                    });
                                  },
                                  activeColor: Colors.orange,
                                ),
                                const Text("500gm"),
                                Radio(
                                  value:
                                      productData["units"].keys.last.toString(),
                                  groupValue: productUnit,
                                  onChanged: (val) {
                                    setState(() {
                                      productUnit = val.toString();
                                    });
                                  },
                                  activeColor: Colors.orange,
                                ),
                                const Text("1kg"),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "\$ "
                              "${productData["units"][productUnit] / 10}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (amount > 1) {
                                      setState(() {
                                        amount--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    child: const Icon(Icons.remove),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    amount.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      amount++;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Row(
        children: [
          _bottomNavigatorBar(
            backgroundColor: Colors.grey,
            color: Colors.white,
            iconColor: Colors.red,
            title: "Add To WishList",
            iconData: wishListBool ? Icons.favorite : Icons.favorite_outline,
            onTap: () async {
              setState(() {
                wishListBool = !wishListBool;
              });
              await _database.updateUserFavorite(productsID: widget.productID);
            },
          ),
          Consumer<ProductProvider>(
            builder: (context, value, child) {
              return _bottomNavigatorBar(
                backgroundColor: Colors.green,
                color: Colors.white,
                iconColor: Colors.white,
                title: "Add To Cart",
                iconData: Icons.shop_outlined,
                onTap: () {
                  value.addNewOrder(
                    product: Product(
                      productCategory: productData["productCategory"],
                      productDescription: productData["productDescription"],
                      productId: productData["productId"],
                      productImage: productData["productImage"],
                      productPrice: productData["units"][productUnit],
                      productTitle: productData["productTitle"],
                      productUnit: productUnit,
                      amount: amount,
                    ),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ShoppingCart()),
                    ModalRoute.withName(''),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigatorBar({
    required Color iconColor,
    required Color backgroundColor,
    required Color color,
    required String title,
    required IconData iconData,
    required void Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
