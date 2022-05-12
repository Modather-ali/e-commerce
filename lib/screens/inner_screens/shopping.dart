import 'package:dmazcofresh/providers/product_provider.dart';
import 'package:dmazcofresh/screens/inner_screens/coupon.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_database.dart';
import '../widgets/snack_bar.dart';
import 'bottom_nav_view.dart';
import 'delivery_details.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final FirebaseDatabase _database = FirebaseDatabase();

  // Map<String, dynamic>? _userData;
  // _getUserData() async {
  //   _userData = await _database.getUserData();
  //   setState(() {});
  // }

  @override
  void initState() {
    // _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 3,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const BottomNavView()),
                ModalRoute.withName(''),
              );
            },
            icon: const Icon(Icons.home)),
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          // value.userData["location"] = _userData!["location"];
          // if (_userData != null) {
          //   value.userData = _userData!;
          //   setState(() {});
          // }
          return SizedBox(
            height: _screenHeight,
            width: _screenWidth,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: _screenHeight,
                  width: _screenWidth,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                        color: Colors.white,
                        height: _screenHeight * 0.47,
                        width: _screenWidth,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: value.orders.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.network(
                                value.orders[index].productImage,
                              ),
                              title: Text(value.orders[index].productTitle),
                              subtitle: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Text(
                                      "\$ " +
                                          (value.orders[index].productPrice *
                                                  0.1)
                                              .toString(),
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 12),
                                    ),
                                    const Text(" - "),
                                    Text(
                                      value.orders[index].productUnit,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const Text(" x "),
                                    Text(value.orders[index].amount.toString()),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Total \$ ${value.orders[index].productPrice * 0.1 * value.orders[index].amount}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  value.removeOrder(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar(
                                      message: "Product removed",
                                      color: Colors.red,
                                    ),
                                  );
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CouponScreen()));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: _screenWidth,
                          height: 40,
                          child: Row(
                            children: [
                              const Icon(Icons.code),
                              const SizedBox(width: 10),
                              const Text(
                                "COUPON",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(5),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Items Total"),
                                Text(
                                  "\$" + (value.totalAmount * 0.1).toString(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Taxes & charges"),
                                Text("\$0"),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Grand Total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                Text(
                                  "\$" + value.totalAmount.toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
                if (value.userData["location"] != "")
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery at " + value.userData["currentPlace"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                LocationPermission permission;

                                bool _serviceEnabled =
                                    await Geolocator.isLocationServiceEnabled();
                                if (!_serviceEnabled) {
                                  await Permission.location.request();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar(
                                          message:
                                              "Please active location service",
                                          color: Colors.red));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const DeliveryDetails()));
                                }
                              },
                              child: const Text(
                                "Change",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                          value.userData["location"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "\$ " + (value.totalAmount * 0.1).toString(),
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: MaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: _screenWidth,
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Update your information",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DeliveryDetails()));
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
