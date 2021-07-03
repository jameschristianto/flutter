import 'package:flutter/material.dart';

class ButtonMenu extends StatelessWidget {
  final List<double> paddingMenu;
  final String textMenu;
  final IconData iconMenu;
  final Widget callback;
  final bool access;

  ButtonMenu({this.access, this.textMenu, this.iconMenu, this.paddingMenu, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: paddingMenu[0],
        left: paddingMenu[1],
        right: paddingMenu[2],
        bottom: paddingMenu[3],
      ),
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: () {
          if(access) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SafeArea(
                  child: callback,
                );
            }));
          }
          else showDialog(
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
                        'Please log in',
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
        },
        color: Colors.white,
        splashColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
            children: <Widget>[
              Icon(
                iconMenu,
                size: 50,
              ),
              SizedBox(width: 20),
              Text('$textMenu',
                style: TextStyle( // your text
                  fontSize: 25,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ]
        ),
      ),
    );
  }
}