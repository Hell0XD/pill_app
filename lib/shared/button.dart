import 'package:flutter/material.dart';
import '../consts.dart' as consts;


class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.isValid,
    required this.successText,
    required this.action,
  }) : super(key: key);

  final bool isValid;
  final String successText;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
          onPressed: action,
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
              backgroundColor:
                  MaterialStateProperty.all(isValid ? consts.blue : consts.gray5)),
          child: Text(
            isValid ? successText : "Fill in the fields ",
            style: TextStyle(
                color: isValid ? Colors.white : consts.gray2,
                fontWeight: FontWeight.w600,
                fontSize: consts.s),
          )),
    );
  }
}