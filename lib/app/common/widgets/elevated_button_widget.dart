import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final Widget? icon;
  final void Function()? onPressed;

  const ElevatedButtonWidget({super.key, required this.label, required this.onPressed, int? size, this.width, this.height, this.icon});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 100, height ?? 40),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const SizedBox.shrink(),
          const SizedBox(width: 15),
          Text(label),
        ],
      ),
    );
  }
}
