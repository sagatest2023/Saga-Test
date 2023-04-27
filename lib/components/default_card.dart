import 'package:flutter/material.dart';

class DefaultCard extends StatelessWidget {
  const DefaultCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height * 0.9,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
