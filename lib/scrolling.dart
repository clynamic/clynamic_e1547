import 'dart:math';

import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'scroll_animator.dart';

typedef PositionedListItemBuilder = Widget Function(
    BuildContext context, int index);

class PositionedListItem {
  PositionedListItem({
    required Widget child,
    this.name,
    this.title,
  }) : builder = ((context, index) => child);

  PositionedListItem.builder({
    required this.builder,
    this.name,
    this.title,
  });

  final String? name;
  final Widget? title;
  late final PositionedListItemBuilder builder;
}

class PositionedListView extends StatelessWidget {
  const PositionedListView({
    super.key,
    required this.scrollController,
    required this.sections,
  });

  final AnchorScrollController scrollController;
  final List<PositionedListItem> sections;

  @override
  Widget build(BuildContext context) {
    return ScrollAnimator(
      controller: scrollController,
      scrollSpeed: 1.5,
      builder: (context, controller, phyiscs) => ListView.builder(
        controller: controller,
        physics: phyiscs,
        itemCount: sections.length,
        itemBuilder: (context, index) => PositionedListSection(
          title: sections[index].title,
          index: index,
          controller: controller as AnchorScrollController,
          child: sections[index].builder(context, index),
        ),
      ),
    );
  }
}

class PositionedListSection extends StatelessWidget {
  const PositionedListSection({
    super.key,
    required this.title,
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final Widget? title;
  final Widget child;
  final AnchorScrollController controller;

  @override
  Widget build(BuildContext context) {
    return AnchorItemWrapper(
      index: index,
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PositionedListHeader(
            child: title,
          ),
          child,
        ],
      ),
    );
  }
}

class PositionedListHeader extends StatelessWidget {
  const PositionedListHeader({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineMedium!,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: child,
      ),
    );
  }
}

class ExpandableCardInset extends StatelessWidget {
  const ExpandableCardInset({
    super.key,
    required this.child,
    this.title,
    this.allowCollapse = false,
    this.insideColor,
    this.outsideColor,
    this.borderRadius,
  });

  final Widget? title;
  final Widget child;
  final bool allowCollapse;
  final Color? insideColor;
  final Color? outsideColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = this.borderRadius ??
        const BorderRadius.vertical(bottom: Radius.circular(16));

    Widget header() {
      return Material(
        clipBehavior: Clip.antiAlias,
        color: outsideColor ?? Theme.of(context).colorScheme.background,
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
            color: insideColor ?? Theme.of(context).cardColor,
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

class Grid extends StatelessWidget {
  const Grid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMinCrossAxisExtent(
            minCrossAxisExtent: (constraints.maxWidth / 4).clamp(200, 400),
            childAspectRatio: 1.5,
          ),
          children: children,
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_asserts_with_message

class SliverGridDelegateWithMinCrossAxisExtent extends SliverGridDelegate {
  const SliverGridDelegateWithMinCrossAxisExtent({
    required this.minCrossAxisExtent,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  })  : assert(minCrossAxisExtent > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0);

  final double minCrossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  bool _debugAssertIsValid(double crossAxisExtent) {
    assert(crossAxisExtent > 0.0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid(constraints.crossAxisExtent));
    final int maxCrossAxisCount =
        (constraints.crossAxisExtent / (minCrossAxisExtent + crossAxisSpacing))
            .floor();
    final int crossAxisCount = max(1, maxCrossAxisCount);
    final double usableCrossAxisExtent = max(
      0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithMinCrossAxisExtent oldDelegate) {
    return oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio;
  }
}
