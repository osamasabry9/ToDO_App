import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_x/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 14,
            ),
            margin: const EdgeInsets.only(
              top: 8,
            ),
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    readOnly: widget != null ? true : false,
                    style: subTitleStyle,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      border: InputBorder.none,
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: context.theme.backgroundColor,
                      //     width: 0,
                      //   ),
                      // ),
                      // focusedBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: context.theme.backgroundColor,
                      //     width: 0,
                      //   ),
                      // ),
                    ),
                  )),
                  widget ?? Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
