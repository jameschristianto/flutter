import 'package:flutter/material.dart';
import 'package:laundry_house/data.dart';
import 'list_price.dart';

class PriceMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Price',
          style: TextStyle(
            fontFamily: 'Cabal',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: PriceMenuBody(),
    );
  }
}

class PriceMenuBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bubble_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: BOTTOM_PADDING,
              ),
              child: Text(
                'Regular',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListPrice(price.regularPrice),
            Container(
              padding: EdgeInsets.only(
                top: TOP_PADDING,
                bottom: BOTTOM_PADDING,
              ),
              child: Text(
                'Express',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListPrice(price.expressPrice),
          ],
        ),
      )
    );
  }
}