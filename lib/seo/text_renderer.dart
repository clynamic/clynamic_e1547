import 'package:clynamic/seo/text_type.dart';
import 'package:seo_renderer/helpers/utils.dart';

import 'package:flutter/material.dart';

class HtmlText extends StatelessWidget {
  final Widget text;
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
    throw UnimplementedError('No implementation for HtmlText found!');
  }
}
