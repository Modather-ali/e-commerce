import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  String productImage;
  String productName;
  String productUnit;
  num productPrice;
  Function onDelete;
  ProductItem({
    Key? key,
    required this.onDelete,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productUnit,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int cunt = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: Image.network(
                      widget.productImage,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${widget.productPrice}\$",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 15, top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Expanded(
                          child: Text(
                            widget.productUnit,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 32),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Container(
                    //   height: 25,
                    //   width: 70,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.grey),
                    //     borderRadius: BorderRadius.circular(30),
                    //   ),
                    //   child: Center(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         InkWell(
                    //           onTap: () {},
                    //           child: const Icon(
                    //             Icons.remove,
                    //             size: 20,
                    //           ),
                    //         ),
                    //          Text(
                    //           "000",
                    //           style: TextStyle(),
                    //         ),
                    //         InkWell(
                    //           onTap: () {},
                    //           child: const Icon(
                    //             Icons.add,
                    //             size: 20,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
