import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  void Function()? onPressed;
  Widget child;
  GeneralButton({Key? key, this.onPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color.fromRGBO(240, 98, 146, 100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 20)),
      ),
      child: child,
    );
  }
}
