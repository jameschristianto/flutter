import 'package:flutter/material.dart';

const int FLEX_1 = 3;
const int FLEX_2 = 1;
const int FLEX_3 = 10;
const double BOTTOM_PADDING = 20;

class ListOrder extends StatelessWidget {
  final String text, data;
  ListOrder(this.text, this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: BOTTOM_PADDING,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: FLEX_1,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          Expanded(
            flex: FLEX_2,
            child: Text(
              ' : ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          Expanded(
            flex: FLEX_3,
            child: Text(
              data,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.deepPurpleAccent.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}