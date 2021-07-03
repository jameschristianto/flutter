import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry_house/button_menu.dart';
import 'package:laundry_house/new_order_menu.dart';
import 'package:laundry_house/check_order_menu.dart';
import 'package:laundry_house/price_menu.dart';
import 'package:laundry_house/database_helper.dart';

const List<double> MENU_1 = [30, 30, 30, 15];
const List<double> MENU_2 = [15, 30, 30, 15];
const List<double> MENU_3 = [15, 30, 30, 30];

User user = new User(
  1,
  'name',
  'phone number',
  'email'
);

final TextEditingController _textEditingControllerName = TextEditingController();
final TextEditingController _textEditingControllerPhone = TextEditingController();
final TextEditingController _textEditingControllerEmail = TextEditingController();
final GlobalKey<FormState> userKey = GlobalKey<FormState>();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final databaseHelper = DatabaseHelper.instance;
  bool access, account, cancel = false;
  String labelName, labelPhone, labelEmail;

  @override
  void initState() {
    super.initState();
    getUserData();
    setState(() {

    });
  }

  void getUserData() async {
    await databaseHelper.read().then((userList){
      print(userList);

      if(userList.isEmpty) {
        setState(() {
          access = false;
          account = true;
        });
      }
      else {
        setState(() {
          access = true;
          account = false;
          user.id = userList[0]['id'];
          user.userName = userList[0]['user_name'];
          user.userPhone = userList[0]['user_phone'];
          user.userEmail = userList[0]['user_email'];
        });
      }
    });

    print(user.id);
    print(user.userName);
    print(user.userPhone);
    print(user.userEmail);
  }

  void setUserData(User user) async {
    final list = await databaseHelper.read();
    if(list.isNotEmpty) await databaseHelper.delete(1);
    await databaseHelper.create(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //
        //   },
        // ),
        title: Text(
          'Laundry House',
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
      body: SafeArea(
        child: MainScreenBody(access),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 75,
          width: 75,
          child: FloatingActionButton(
            child: Icon(
              Icons.account_circle_rounded,
              size: 65,
            ),
            backgroundColor: Colors.deepPurpleAccent,
            elevation: 5,
            onPressed: () {
              _textEditingControllerName.clear();
              _textEditingControllerPhone.clear();
              _textEditingControllerEmail.clear();

              labelName = user.userName;
              labelPhone =  user.userPhone;
              labelEmail = user.userEmail;

              if(cancel) account = false;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          content: Form(
                            key: userKey,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: TextFormField(
                                      enabled: account,
                                      controller: _textEditingControllerName,
                                      validator: (value) {
                                        return value.isEmpty
                                            ? "Please fill this field"
                                            : null;
                                      },
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      maxLength: 30,
                                      keyboardType: TextInputType.name,
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
                                        disabledBorder: OutlineInputBorder(
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
                                        labelText: labelName,
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: TextFormField(
                                      enabled: account,
                                      controller: _textEditingControllerPhone,
                                      validator: (value) {
                                        return value.isEmpty
                                            ? "Please fill this field"
                                            : null;
                                      },
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      maxLength: 15,
                                      keyboardType: TextInputType.phone,
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
                                        disabledBorder: OutlineInputBorder(
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
                                        labelText: labelPhone,
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    child: TextFormField(
                                      enabled: account,
                                      controller: _textEditingControllerEmail,
                                      validator: (value) {
                                        return value.isEmpty
                                            ? "Please fill this field"
                                            : null;
                                      },
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      maxLength: 30,
                                      keyboardType: TextInputType.emailAddress,
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
                                        disabledBorder: OutlineInputBorder(
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
                                        labelText: labelEmail,
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 50,
                                    child: ElevatedButton(
                                        child: Text(
                                          account ? 'Submit' : 'Edit',
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
                                        onPressed: () async {
                                          if (account) {
                                            if(userKey.currentState.validate()) {
                                              setState(() {
                                                user.userName =
                                                    _textEditingControllerName
                                                        .text;
                                                user.userPhone =
                                                    _textEditingControllerPhone
                                                        .text;
                                                user.userEmail =
                                                    _textEditingControllerEmail
                                                        .text;

                                                account = false;
                                                access = true;

                                                labelName = user.userName;
                                                labelPhone = user.userPhone;
                                                labelEmail = user.userEmail;

                                                print(user.id);
                                                print(user.userName);
                                                print(user.userPhone);
                                                print(user.userEmail);

                                                cancel = false;

                                                setUserData(user);

                                                Navigator.pop(context);
                                              });
                                            }
                                          }
                                          else {
                                            setState(() {
                                              account = true;

                                              labelName = 'name';
                                              labelPhone = 'phone number';
                                              labelEmail = 'email';

                                              cancel = true;
                                            });
                                          }
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                  /*return Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 5,
                        color: Colors.black,
                      ),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              autofocus: true,
                              decoration: new InputDecoration(
                                  labelText: 'Full Name', hintText: 'eg. John Smith'),
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
              );*/
                },
              );
              //Navigator.pushReplacement(
              //  context,
              //  MaterialPageRoute(
              //    builder: (BuildContext context) => MainScreen())
              //);
            }
          ),
        ),
      ),
    );
  }
}

class MainScreenBody extends StatelessWidget {
  final bool access;
  MainScreenBody(this.access);

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ButtonMenu(
              access: this.access,
              textMenu: 'NEW ORDER',
              iconMenu: Icons.assignment_outlined,
              paddingMenu: MENU_1,
              callback: NewOrderMenu(),
            ),
            ButtonMenu(
              access: this.access,
              textMenu: 'CHECK ORDER',
              iconMenu: Icons.assignment_turned_in_outlined,
              paddingMenu: MENU_2,
              callback: CheckOrderMenu(),
            ),
            ButtonMenu(
              access: this.access,
              textMenu: 'PRICE',
              iconMenu: Icons.money,
              paddingMenu: MENU_3,
              callback: PriceMenu(),
            ),
          ],
        ),
      ),
    );
  }
}