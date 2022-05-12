import 'package:dmazcofresh/screens/widgets/super_text_field.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text(
          "Apply Coupon",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SuperTextField(
              fieldName: "Enter coupon code",
              textInputType: TextInputType.text,
              suffixIcon: TextButton(
                onPressed: () {},
                child: const Text("apply"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
