import 'dart:html';

import 'package:clynamic/seo/text_type.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/helpers/utils.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer_web.dart';

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

  HtmlElement typeToElement(HtmlTextType? type) {
    switch (type) {
      case HtmlTextType.header1:
        return HeadingElement.h1();
      case HtmlTextType.header2:
        return HeadingElement.h2();
      case HtmlTextType.header3:
        return HeadingElement.h3();
      case HtmlTextType.header4:
        return HeadingElement.h4();
      case HtmlTextType.header5:
        return HeadingElement.h5();
      case HtmlTextType.header6:
        return HeadingElement.h6();
      case HtmlTextType.paragraph:
      default:
        return ParagraphElement();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextRenderer(
      key: key,
      text: text,
      element: typeToElement(type),
      controller: controller,
    );
  }
}
