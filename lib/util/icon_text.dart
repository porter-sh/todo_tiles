/// This file contains the [IconText] widget, which is a [StatelessWidget] that
/// simply displays an [Icon] and a [Text] widget next to each other.

import 'package:flutter/material.dart';

/// Public class [IconText] is a [StatelessWidget] that simply displays an
/// [Icon] and a [Text] widget next to each other.
class IconText extends StatelessWidget {
  /// Creates an [IconText] widget.
  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.spacing = 5,
    this.padding = const EdgeInsets.only(bottom: 12),
  });

  /// The icon to display.
  final Icon icon;

  /// The text to display.
  final Text text;

  /// The amount of space between the icon and the text.
  final double spacing;

  /// Padding around the widget.
  final EdgeInsetsGeometry padding;

  /// Returns the widget that displays the icon and text.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: spacing),
          text,
        ],
      ),
    );
  }
}
