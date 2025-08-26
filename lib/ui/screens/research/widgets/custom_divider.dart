import 'package:flutter/material.dart';

Widget customDivider({required BuildContext context, double? width}) {
  return Container(
    height: 2,
    width: width ?? MediaQuery.of(context).size.width / 4,
    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.4))),
  );
}
