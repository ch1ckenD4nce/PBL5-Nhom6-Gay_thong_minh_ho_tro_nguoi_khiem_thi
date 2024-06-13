import 'package:flutter/material.dart';

class Box2 extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const Box2(
      {super.key,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(onPressed: onPressed, icon: Icon(Icons.settings))
            ],
          ),
        ],
      ),
    );
  }
}
