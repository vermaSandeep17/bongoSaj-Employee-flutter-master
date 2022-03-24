import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomSignUpRow extends StatelessWidget {
  const CustomSignUpRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have an account?',
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: 'Signup',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  //tap handler
                  // print('hi');
                },
            ),
          ],
        ),
      ),
    );
  }
}
