import 'package:flutter/material.dart';

class LargeDividerComponent extends StatelessWidget {
  const LargeDividerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 20, thickness: 20, color: Color.fromRGBO(43, 151, 147, 0.1));
  }
}
