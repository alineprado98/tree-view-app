import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgReaderWidget extends StatelessWidget {
  final Color? color;
  final String path;
  final double? height;
  final double? width;
  const SvgReaderWidget({
    super.key,
    required this.path,
    this.color,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
