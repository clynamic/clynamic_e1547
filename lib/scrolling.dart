import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:anchor_scroll_controller/anchor_scroll_wrapper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class PositionedListItem {
  final String name;
  final Widget? title;
  final Widget child;

  PositionedListItem({
    required this.name,
    required this.child,
    this.title,
  });
}

class PositionedListView extends StatelessWidget {
  final AnchorScrollController scrollController;
  final List<PositionedListItem> sections;

  const PositionedListView({
    Key? key,
    required this.scrollController,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: sections.length,
      itemBuilder: (context, index) => PositionedListSection(
        title: sections[index].title ?? Text(sections[index].name),
        index: index,
        controller: scrollController,
        child: sections[index].child,
      ),
    );
  }
}

class PositionedListSection extends StatelessWidget {
  final Widget title;
  final int index;
  final Widget child;
  final AnchorScrollController controller;

  const PositionedListSection({
    Key? key,
    required this.title,
    required this.index,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnchorItemWrapper(
      index: index,
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline4!,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: title,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class ExpandableCardInset extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final bool allowCollapse;
  final Color? insideColor;
  final Color? outsideColor;
  final BorderRadius? borderRadius;

  const ExpandableCardInset({
    Key? key,
    required this.child,
    this.title,
    this.allowCollapse = false,
    this.insideColor,
    this.outsideColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = this.borderRadius ??
        const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        );

    Widget header() {
      return Material(
        clipBehavior: Clip.antiAlias,
        color: outsideColor ?? Theme.of(context).backgroundColor,
        borderRadius: borderRadius,
        elevation: 4,
        child: Opacity(
          opacity: allowCollapse ? 1 : 0,
          child: IgnorePointer(
            ignoring: !allowCollapse,
            child: ExpandableButton(
              child: Row(
                children: [
                  if (title != null) title!,
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ExpandableIcon(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ExpandableTheme(
      data: ExpandableThemeData(
        iconColor: Theme.of(context).iconTheme.color,
      ),
      child: ExpandableNotifier(
        initialExpanded: true,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: insideColor ?? Colors.grey[900]!,
            borderRadius: borderRadius,
          ),
          child: Expandable(
            collapsed: header(),
            expanded: Column(
              children: [
                header(),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
