import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry_house/data.dart';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:laundry_house/database_helper.dart';

Data data = new Data();

final textFieldController = TextEditingController();
final bigTextFieldController = TextEditingController();

final keyTextField = new GlobalKey<FormState>();
final keyBigTextField = new GlobalKey<FormState>();

class NewOrderMenu extends StatelessWidget {
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
          'New Order',
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
      body: NewOrderMenuBody(),
    );
  }
}

class NewOrderMenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bubble_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: 5,
              ),
              child: Text(
                'Select Item',
                style: TextStyle( // your text
                  fontSize: 25,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5,
                left: 30,
                right: 30,
                bottom: 15,
              ),
              child: DropDown(),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: 5,
              ),
              child: RadioButton(),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: 15,
              ),
              child: BigTextField(),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: 15,
              ),
              child: SubmitButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isSubmitted = false;
  final databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    await databaseHelper.read().then((userList){
      print(userList);

      data.userName = userList[0]['user_name'];
      data.userPhone = userList[0]['user_phone'];
      data.userEmail = userList[0]['user_email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width : 100,
          height: 50,
          child: ElevatedButton(
            child: Text(
              'Submit',
              style: TextStyle( // your text
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              FirebaseDatabase.instance.reference().once().then((DataSnapshot snapshot) {
                if(snapshot.value == null) {
                  data.numberOfOrder = 1;
                }
                else {
                  log('Key : ${snapshot.key}');
                  log('Value : ${snapshot.value}');
                  log('String : ${snapshot.value.toString()}');
                  log('Length : ${snapshot.value.length}');
                  data.numberOfOrder = snapshot.value.length + 1;
                }
              });

              if(data.selectedItem == 'Clothes') {
                data.countItem = '';
                data.weightItem = textFieldController.text;
              }
              else {
                data.countItem = textFieldController.text;
                data.weightItem = '';
              }
              data.address = bigTextFieldController.text;

              if(data.selectedItem == 'Clothes' && data.selectedService == 'Regular') data.price = ((int.parse(data.weightItem) * price.regularPrice['Clothes']) + price.regularPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Bed Sheet' && data.selectedService == 'Regular') data.price = ((int.parse(data.countItem) * price.regularPrice['Bed Sheet']) + price.regularPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Shoes' && data.selectedService == 'Regular') data.price = ((int.parse(data.countItem) * price.regularPrice['Shoes']) + price.regularPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Bag' && data.selectedService == 'Regular') data.price = ((int.parse(data.countItem) * price.regularPrice['Bag']) + price.regularPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Clothes' && data.selectedService == 'Express') data.price = ((int.parse(data.weightItem) * price.expressPrice['Clothes']) + price.expressPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Bed Sheet' && data.selectedService == 'Express') data.price = ((int.parse(data.countItem) * price.expressPrice['Bed Sheet']) + price.expressPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Shoes' && data.selectedService == 'Express') data.price = ((int.parse(data.countItem) * price.expressPrice['Shoes']) + price.expressPrice['Pick up fee']).toString();
              else if(data.selectedItem == 'Bag' && data.selectedService == 'Express') data.price = ((int.parse(data.countItem) * price.expressPrice['Bag']) + price.expressPrice['Pick up fee']).toString();

              data.price = 'Rp. ' + data.price;

              if(keyTextField.currentState.validate() && keyBigTextField.currentState.validate()) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Confirmation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            'Total : ' + data.price,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        backgroundColor: Colors.deepPurpleAccent,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              log('selectedItem : ${data.selectedItem}');
                              log('countItem : ${data.countItem}');
                              log('weightItem : ${data.weightItem}');
                              log('selectedService : ${data.selectedService}');
                              log('address : ${data.address}');
                              log('status : ${data.status}');
                              log('name : ${data.userName}');
                              log('phone : ${data.userPhone}');
                              log('email : ${data.userEmail}');
                              log('price : ${data.price}');

                              final firebaseData = FirebaseDatabase.instance.reference().child('order ' + data.numberOfOrder.toString());
                              firebaseData.set({
                                "item": data.selectedItem,
                                "weight": data.weightItem,
                                "count": data.countItem,
                                "service": data.selectedService,
                                "address": data.address,
                                "status": data.status,
                                "name": data.userName,
                                "phone": data.userPhone,
                                "email": data.userEmail,
                                "price": data.price
                              });
                              isSubmitted = true;
                              data.selectedItem = 'Clothes';
                              data.weightItem = '';
                              data.countItem = '';
                              data.selectedService = '';
                              data.address = '';
                              data.userName = '';
                              data.userPhone = '';
                              data.userEmail = '';
                              data.price = '';
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              isSubmitted = false;
                              Navigator.pop(context);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                ).then((val) {
                  if(isSubmitted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop(true);
                        });
                        return Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 40,
                              ),
                              child: Container(
                                width: 150,
                                height: 75,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  color: Colors.deepPurpleAccent.withOpacity(0.9),
                                ),
                                child: Text(
                                  'Order Successful',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      barrierDismissible: false,
                    ).then((val) {
                      Navigator.pop(context);
                    });
                  }
                });
              }
              else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.of(context).pop(true);
                    });
                    return Center(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 40,
                          ),
                          child: Container(
                            width: 150,
                            height: 75,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: Colors.deepPurpleAccent.withOpacity(0.9),
                            ),
                            child: Text(
                              'Incomplete Data',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  barrierDismissible: false,
                );
              }
            },
          )
        ),
      ],
    );
  }
}
class BigTextField extends StatefulWidget {
  @override
  _BigTextFieldState createState() => _BigTextFieldState();
}

class _BigTextFieldState extends State<BigTextField> {
  @override
  Widget build(BuildContext context) {
    bigTextFieldController.clear();
    return Form(
      key: keyBigTextField,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              'Address',
              style: TextStyle( // your text
                fontSize: 25,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          Container(
            child: TextFormField(
              controller: bigTextFieldController,
              autovalidateMode: AutovalidateMode.always,
              validator: (String value){
                return value.isEmpty ? "Please fill this field" : null;
              },
              minLines: 3,
              maxLines: 3,
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurpleAccent,
              ),
              maxLength: 100,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter Your Address',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioButton extends StatefulWidget {
  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  SingingCharacter _character = SingingCharacter.Regular;

  @override
  Widget build(BuildContext context) {
    data.selectedService = _character.toString().split(".").last;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            'Select Service',
            style: TextStyle( // your text
              fontSize: 25,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: SingingCharacter.Regular,
                groupValue: _character,
                activeColor: Colors.deepPurpleAccent,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    data.selectedService = _character.toString().split(".").last;
                  });
                },
              ),
              Text(
                'Regular',
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 16,
                )
              ),
              SizedBox(width: 50),
              Radio(
                value: SingingCharacter.Express,
                groupValue: _character,
                activeColor: Colors.deepPurpleAccent,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    data.selectedService = _character.toString().split(".").last;
                  });
                },
              ),
              Text(
                  'Express',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 16,
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TextField extends StatefulWidget {
  final String textName, textHint, textSuffix;

  TextField({this.textName, this.textHint, this.textSuffix});

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  TextInputFormatter decimalEnable;

  @override
  Widget build(BuildContext context) {
    textFieldController.clear();

    if(widget.textName == 'Weight Items') {
      decimalEnable = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
    }
    else {
      decimalEnable = FilteringTextInputFormatter.digitsOnly;
    }

    return Form(
      key: keyTextField,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 30,
              bottom: 5,
            ),
            child: Text(
              widget.textName,
              style: TextStyle( // your text
                fontSize: 25,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: TextFormField(
              controller: textFieldController,
              autovalidateMode: AutovalidateMode.always,
              validator: (String value){
                return value.isEmpty ? "Please fill this field" : null;
              },
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurpleAccent,
              ),
              maxLength: 5,
              keyboardType: TextInputType.number,
              inputFormatters: [decimalEnable],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: widget.textHint,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                ),
                suffixText: widget.textSuffix,
                suffixStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _chosenValue = 'Clothes';
  bool condition = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: DropdownButton<String>(
            value: _chosenValue,
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 16,
            ),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: SizedBox(),
            itemHeight: 55,
            items: <String>[
              'Clothes',
              'Bed Sheet',
              'Shoes',
              'Bag',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(
              'Select One',
              style: TextStyle(
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                  fontSize: 16,
              ),
            ),
            onChanged: (String value) {
              setState(() {
                _chosenValue = value;

                if(_chosenValue == 'Clothes'){
                  condition = true;
                }
                else{
                  condition = false;
                }

                data.selectedItem = _chosenValue;
              });
            },
          )
        ),
        condition ? TextField(
            textName: 'Weight Items',
            textHint: 'Rounded Weight of Your Item',
            textSuffix: 'Kg',
        ) : TextField(
            textName: 'Count Items',
            textHint: 'Count of Your Item',
            textSuffix:'Item',
        ),
      ]
    );
  }
}