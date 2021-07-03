import 'package:flutter/material.dart';

const int FLEX_1 = 2;
const int FLEX_2 = 1;
const int FLEX_3 = 4;
const double TOP_PADDING = 20;
const double BOTTOM_PADDING = 20;
const double LEFT_PADDING = 20;

class ListPrice extends StatelessWidget {
  final Map<String, int> map;
  ListPrice(this.map);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (var i = 0; i < map.length; i++) {
      children.add(ListPriceBody(i, map));
    }

    return Column(
      children: children,
    );
  }
}

class ListPriceBody extends StatelessWidget {
  final int index;
  final Map<String, int> map;
  ListPriceBody(this.index, this.map);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: BOTTOM_PADDING,
        left: LEFT_PADDING,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: FLEX_1,
            child: Text(
              map.keys.elementAt(index),
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
              'Rp. ' + map.values.elementAt(index).toString(),
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