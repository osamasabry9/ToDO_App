import 'package:flutter/material.dart';
import 'package:to_do_x/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.lable, required this.onTap})
      : super(key: key);

  final String lable;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        child: TextButton(
          onPressed: onTap,
          child: Text(
            lable,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
