import 'package:flutter/material.dart';

class HomeButtonItem {
  final VoidCallback onClickCallback;
  final String title;
  final IconData iconData;
  final Color iconColor;

  HomeButtonItem(
    this.iconData,
    this.title,
    this.iconColor,
    this.onClickCallback,
  );
}
