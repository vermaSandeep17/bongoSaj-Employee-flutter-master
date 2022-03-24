import 'package:flutter/material.dart';

class SingInButton extends StatelessWidget {
  const SingInButton({
    Key? key,
    required this.width,
    required this.onTapHandler,
  }) : super(key: key);

  final double width;
  final void Function() onTapHandler;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onTapHandler,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.deepOrange,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 15,
            ),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
