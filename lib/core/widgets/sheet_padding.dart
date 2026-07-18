import 'dart:math';

import 'package:flutter/material.dart';

import '../dimens.dart';

class SheetPadding extends StatelessWidget {
  const SheetPadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = max(
      mediaQuery.viewInsets.bottom,
      mediaQuery.viewPadding.bottom,
    );
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.spacingMd,
        right: Dimens.spacingMd,
        top: Dimens.spacingMd,
        bottom: bottomInset + Dimens.spacingMd,
      ),
      child: SingleChildScrollView(child: child),
    );
  }
}
