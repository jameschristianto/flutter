import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:laundry_house/data.dart';
import 'package:laundry_house/detail_order.dart';

Order dataOrder;

class CheckOrderMenu extends StatelessWidget {
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
          'Check Order',
          style: TextStyle(
            fontFamily: 'Cabal',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 80,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.refresh),
        //     onPressed: () {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (BuildContext context) => CheckOrderMenu()));
        //     }
        //   ),
        // ],
      ),
      body: CheckOrderMenuBody(),
    );
  }
}

class CheckOrderMenuBody extends StatefulWidget {
  @override
  _CheckOrderMenuBodyState createState() => _CheckOrderMenuBodyState();
}

class _CheckOrderMenuBodyState extends State<CheckOrderMenuBody> {
  List<Order> dataOrderList = [];

  @override
  void initState() {
    super.initState();
    getDatabaseData();
  }

  Future getDatabaseData() async{
    List<Order> dataOrderList = [];

    await FirebaseDatabase.instance.reference().once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        dataOrderList.clear();

        for (var i = 1; i <= snapshot.value.length; i++) {
          String child = 'order ' + i.toString();
          log('child: $child');
          log('item: ${snapshot.value[child]['item']}');
          log('count: ${snapshot.value[child]['count']}');
          log('weight: ${snapshot.value[child]['weight']}');
          log('service: ${snapshot.value[child]['service']}');
          log('address: ${snapshot.value[child]['address']}');
          log('status: ${snapshot.value[child]['status']}');
          log('name: ${snapshot.value[child]['name']}');
          log('phone: ${snapshot.value[child]['phone']}');
          log('email: ${snapshot.value[child]['email']}');
          log('price: ${snapshot.value[child]['price']}');

          dataOrder = new Order(
              item: snapshot.value[child]['item'].toString(),
              service: snapshot.value[child]['service'].toString(),
              address: snapshot.value[child]['address'].toString(),
              status: snapshot.value[child]['status'].toString(),
              name: snapshot.value[child]['name'].toString(),
              phone: snapshot.value[child]['phone'].toString(),
              email: snapshot.value[child]['email'].toString(),
              price: snapshot.value[child]['price'].toString()
          );

          if (snapshot.value[child]['count']
              .toString()
              .isEmpty) {
            dataOrder.display =
                snapshot.value[child]['weight'].toString() + ' Kg';
          }
          else {
            dataOrder.display =
                snapshot.value[child]['count'].toString() + ' Item';
          }

          dataOrderList.add(dataOrder);
        }
      }
    });

    setState(() => this.dataOrderList = dataOrderList);
  }

  @override
  Widget build(BuildContext context) {
    return dataOrderList.length == 0 ?
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bubble_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: Center(
          child: Text(
            'no order',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.deepPurpleAccent.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      ) :
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bubble_background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: RefreshIndicator(
            child: ListView.builder(
              itemCount: dataOrderList.length,
              itemBuilder: (context, index) {
                final Order dataList = dataOrderList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return SafeArea(
                          child: DetailOrder(data: dataList),
                        );
                    }));
                  },
                  child: Card(
                    elevation: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  dataList.item,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    dataList.display,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              dataList.status,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            onRefresh: () {
              return getDatabaseData();
            },
          ),
        ),
      );
  }
}