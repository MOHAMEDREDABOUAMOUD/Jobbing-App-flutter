// ignore_for_file: unnecessary_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:signin_signup/pages/home_page.dart';

class PaymentScreen extends StatelessWidget {
  final String emailMe;
  const PaymentScreen({super.key, required this.emailMe});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Payment(
        emailMe: emailMe,
      ),
    );
  }
}

class Payment extends StatefulWidget {
  final String emailMe;
  const Payment({super.key, required this.emailMe});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String cardHolderName = '';
  String cvvNumber = '';
  String expityDate = '';
  bool showback = false;

  void onCreditcardModel(CreditCardModel creditcardModel) {
    setState(() {
      cardNumber = creditcardModel.cardNumber;
      cardHolderName = creditcardModel.cardHolderName;
      expityDate = creditcardModel.expiryDate;
      cvvNumber = creditcardModel.cvvCode;
      showback = creditcardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Payment"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expityDate,
              height: 210,
              cardHolderName: cardHolderName,
              cvvCode: cvvNumber,
              showBackView: showback,
              cardBgColor: Colors.black,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              animationDuration: Duration(milliseconds: 1200),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                    cardNumber: cardNumber,
                    expiryDate: expityDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvNumber,
                    onCreditCardModelChange: onCreditcardModel,
                    themeColor: Colors.black,
                    formKey: _formKey),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Main(
                                    email: widget.emailMe,
                                  )));
                    },
                    child: Icon(Icons.navigate_next),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
