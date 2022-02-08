import 'package:clynamic/seo/text_type.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

class HtmlText extends StatelessWidget {
  final Widget text;
  // ignored
  final HtmlTextType? type;
  final RenderController? controller;

  const HtmlText({
    Key? key,
    required this.text,
    this.type,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextRenderer(
      key: key,
      text: text,
      controller: controller,
    );
  }
}
