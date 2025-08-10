import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

import 'scrolling.dart';
import 'theme.dart';

class FeatureItem {
  const FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final String description;
}

class FeatureDisplay extends StatefulWidget {
  const FeatureDisplay({super.key, required this.features, this.onItemToggle});

  final List<FeatureItem> features;
  final VoidCallback? onItemToggle;

  @override
  State<FeatureDisplay> createState() => _FeatureDisplayState();
}

class _FeatureDisplayState extends State<FeatureDisplay> {
  int? selected;
  int? previous;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PositionedListHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Seo.text(
                      text: 'Features',
                      style: TextTagStyle.h3,
                      child: const Text('Features'),
                    ),
                    Flexible(
                      child: AnimatedOpacity(
                        opacity: selected == null ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '(tap any)',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: IgnorePointer(
                ignoring: selected == null,
                child: AnimatedOpacity(
                  opacity: selected != null ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        previous = selected;
                        selected = null;
                      });
                      widget.onItemToggle?.call();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: 1000,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  FeatureGrid(
                    features: widget.features,
                    onTapItem: (index) {
                      setState(() {
                        previous = index;
                        selected = index;
                      });
                      widget.onItemToggle?.call();
                    },
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: selected == null,
                      child: AnimatedOpacity(
                        opacity: selected != null ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              previous = selected;
                              selected = null;
                            });
                            widget.onItemToggle?.call();
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            color: Colors.black.withAlpha(128),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Builder(
                      builder: (context) => IgnorePointer(
                        ignoring: selected == null,
                        child: AnimatedOpacity(
                          opacity: selected != null ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          onEnd: () => setState(() {
                            if (selected == null) {
                              previous = null;
                            }
                          }),
                          child: previous != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: Center(
                                    child: FeatureCard(
                                      item: widget.features[previous!],
                                      expanded: true,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key, required this.features, this.onTapItem});

  final List<FeatureItem> features;
  final void Function(int index)? onTapItem;

  @override
  Widget build(BuildContext context) {
    return Grid(
      children: features
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(8),
              child: FeatureCard(
                item: e,
                onTap: onTapItem != null
                    ? () => onTapItem!(features.indexOf(e))
                    : null,
              ),
            ),
          )
          .toList(),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.item,
    this.onTap,
    this.expanded = false,
  });

  final FeatureItem item;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    List<Widget> subtitle() {
      if (expanded) {
        return [
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              primary: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Seo.text(
                  text: item.description,
                  child: Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: dimTextColor(context, 0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      } else {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Seo.text(
              text: item.subtitle,
              style: TextTagStyle.h4,
              child: Text(
                item.subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: dimTextColor(context)),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ];
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: expanded
              ? const EdgeInsets.all(32)
              : const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.icon,
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Seo.text(
                        text: item.title,
                        style: TextTagStyle.h2,
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...subtitle(),
            ],
          ),
        ),
      ),
    );
  }
}
