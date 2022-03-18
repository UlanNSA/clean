import 'package:flutter/material.dart';

class SelectOption<T> {
  final String? label;
  final Widget? leading;
  final Widget? smallLeading;
  final T? value;

  SelectOption({
    this.label,
    this.leading,
    this.smallLeading,
    this.value,
  });
}
