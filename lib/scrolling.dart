import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:anchor_scroll_controller/anchor_scroll_wrapper.dart';
import 'package:flutter/material.dart';

class ScrollSection {
  final String name;
  final Widget? title;
  final Widget child;

  ScrollSection({
    required this.name,
    required this.child,
    this.title,
  });
}

class PositionedListView extends StatelessWidget {
  final AnchorScrollController scrollController;
  final List<ScrollSection> sections;

  const PositionedListView({
    Key? key,
    required this.scrollController,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(32),
      itemCount: sections.length,
      itemBuilder: (context, index) => ListSection(
        title: sections[index].title ?? Text(sections[index].name),
        index: index,
        controller: scrollController,
        child: sections[index].child,
      ),
    );
  }
}

class ListSection extends StatelessWidget {
  final Widget title;
  final int index;
  final Widget child;
  final AnchorScrollController controller;

  const ListSection({
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
