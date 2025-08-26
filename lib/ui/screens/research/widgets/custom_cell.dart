import 'package:flutter/material.dart';

Widget customCell(
    {required String text,
    double? width,
    required BuildContext context,
    Color? color,
    Color? textColor,
    EdgeInsetsGeometry? padding}) {
  return Container(
    color: color,
    width: width ?? MediaQuery.of(context).size.width / 4,
   // height: 55,
    padding: padding ?? const EdgeInsets.only(bottom: 12, top: 12, left: 10),
    child: Text(
      text,
      overflow:TextOverflow.ellipsis,
      style: color == null
          ? null
          : TextStyle(
            // fontSize: 10,
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold),
    ),
  );
}
