import 'package:flutter/material.dart';
import 'package:laundry_house/data.dart';
import 'list_order.dart';

class DetailOrder extends StatelessWidget {
  final Order data;
  DetailOrder({this.data});

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
          'Detail Order',
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
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bubble_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: DetailScreen(data: data),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget{
  final Order data;
  DetailScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListOrder('Name', data.name),
            ListOrder('Phone', data.phone),
            ListOrder('Email', data.email),
            ListOrder('Item', data.item),
            ListOrder(data.display.substring(data.display.length - 2) == 'Kg' ? 'Weight' : 'Count', data.display),
            ListOrder('Address', data.address),
            ListOrder('Service', data.service),
            ListOrder('Price', data.address),
            ListOrder('Status', data.status),
          ],
        ),
      ),
    );
  }
}