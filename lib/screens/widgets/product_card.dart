import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import 'snack_bar.dart';

class ProductCard extends StatefulWidget {
  final String productImage;
  final String productName;
  final Map productUnits;
  final String productId;
  final void Function()? onTap;

  const ProductCard({
    required this.productId,
    required this.productUnits,
    required this.productImage,
    required this.productName,
    required this.onTap,
    t,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int amount = 0;
  List<String> units = [];

  String currentUnit = "";

  @override
  void initState() {
    widget.productUnits.forEach((key, value) {
      units.add(key);
    });
    currentUnit = widget.productUnits.keys.first;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: _screenWidth * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                width: double.infinity,
                child: Image.network(
                  widget.productImage,
                  fit: BoxFit.cover,
                  height: _screenHeight * 0.17,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: widget.productName.length > 13 ? 12 : 13,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<ProductProvider>(
                          builder: (context, value, child) {
                        return DropdownButton(
                          items: units
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            int index;
                            setState(() {
                              currentUnit = val.toString();
                            });
                            if (amount > 0) {
                              index = value.orders.indexWhere(
                                (element) =>
                                    element.productId == widget.productId,
                              );
                              value.removeOrder(index);
                              value.addNewOrder(
                                product: Product(
                                  productCategory: "Chicken",
                                  productDescription: widget.productName,
                                  productId: widget.productId,
                                  productImage: widget.productImage,
                                  productPrice:
                                      widget.productUnits[currentUnit],
                                  productTitle: widget.productName,
                                  productUnit: currentUnit,
                                  amount: amount,
                                ),
                              );
                            }
                          },
                          isExpanded: false,
                          hint: Text(
                            currentUnit,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }),
                      Text(
                        "\$ " +
                            (widget.productUnits[currentUnit] * 0.1).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child:
                    Consumer<ProductProvider>(builder: (context, value, child) {
                  if (amount < 1) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          amount = 1;
                        });
                        value.addNewOrder(
                          product: Product(
                            productCategory: "Chicken",
                            productDescription: widget.productName,
                            productId: widget.productId,
                            productImage: widget.productImage,
                            productPrice: widget.productUnits[currentUnit],
                            productTitle: widget.productName,
                            productUnit: currentUnit,
                            amount: amount,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBar(
                            message: widget.productName +
                                " added to the Shopping Cart",
                          ),
                        );
                      },
                      child: const Text(
                        "+ ADD",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Icon(
                            amount == 1 ? Icons.delete : Icons.remove,
                            color: Colors.red,
                          ),
                          onTap: () {
                            int index;
                            setState(() {
                              amount--;
                            });

                            if (amount >= 1) {
                              index = value.orders.indexWhere(
                                (element) =>
                                    element.productId == widget.productId,
                              );
                              value.removeOrder(index);
                              value.addNewOrder(
                                product: Product(
                                  productCategory: "Chicken",
                                  productDescription: widget.productName,
                                  productId: widget.productId,
                                  productImage: widget.productImage,
                                  productPrice:
                                      widget.productUnits[currentUnit],
                                  productTitle: widget.productName,
                                  productUnit: currentUnit,
                                  amount: amount,
                                ),
                              );
                            } else {
                              index = value.orders.indexWhere(
                                (element) =>
                                    element.productId == widget.productId,
                              );
                              value.removeOrder(index);
                            }
                          },
                        ),
                        Text(
                          amount.toString(),
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w700),
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                          onTap: () {
                            int index;
                            setState(() {
                              amount++;
                            });

                            index = value.orders.indexWhere(
                              (element) =>
                                  element.productId == widget.productId,
                            );
                            value.removeOrder(index);
                            value.addNewOrder(
                              product: Product(
                                productCategory: "Chicken",
                                productDescription: widget.productName,
                                productId: widget.productId,
                                productImage: widget.productImage,
                                productPrice: widget.productUnits[currentUnit],
                                productTitle: widget.productName,
                                productUnit: currentUnit,
                                amount: amount,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
