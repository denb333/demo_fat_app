import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int type = 1;
  double price = 0.0;
  void handleRadio(Object? e) {
    setState(() {
      type = e as int;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    price = args['price'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Method"),
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Center(
            child: Column(
              children: [
                SizedBox(),
                // Amazon Pay
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: type == 1
                        ? Border.all(width: 1, color: Colors.black)
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: type,
                          onChanged: handleRadio,
                          activeColor: Color(0xFFDB3022),
                        ),
                        Text(
                          "Amazon Pay",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: type == 1 ? Colors.black : Colors.grey,
                          ),
                        ),
                        Image.asset(
                          "images/bank/amazon.png",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Visa & MasterCard
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: type == 2
                        ? Border.all(width: 1, color: Colors.black)
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 2,
                          groupValue: type,
                          onChanged: handleRadio,
                          activeColor: Color(0xFFDB3022),
                        ),
                        Text(
                          "Credit/Debit Card",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: type == 2 ? Colors.black : Colors.grey,
                          ),
                        ),
                        Image.asset(
                          "images/bank/visa.png",
                          width: 35,
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          "images/bank/mastercard.png",
                          width: 35,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // PayPal
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: type == 3
                        ? Border.all(width: 1, color: Colors.black)
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 3,
                          groupValue: type,
                          onChanged: handleRadio,
                          activeColor: Color(0xFFDB3022),
                        ),
                        Text(
                          "PayPal",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: type == 3 ? Colors.black : Colors.grey,
                          ),
                        ),
                        Image.asset(
                          "images/bank/paypal.png",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Another Payment Method
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: type == 4
                        ? Border.all(width: 1, color: Colors.black)
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 4,
                          groupValue: type,
                          onChanged: handleRadio,
                          activeColor: Color(0xFFDB3022),
                        ),
                        Text(
                          "Another Payment Method",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: type == 4 ? Colors.black : Colors.grey,
                          ),
                        ),
                        Image.asset(
                          "images/bank/google.png",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub-total",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 100),
                    InkWell(
                      onTap: () {
                        // Thêm hành động tại đây
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFDB3022),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
