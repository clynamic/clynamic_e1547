import 'package:clynamic/gallery.dart';
import 'package:flutter/material.dart';

import 'scrolling.dart';

class FeatureItem {
  final String title;
  final String subtitle;
  final Widget icon;
  final String description;

  FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
  });
}

class FeatureDisplay extends StatefulWidget {
  final List<FeatureItem> features;
  final VoidCallback? onItemToggle;

  const FeatureDisplay({Key? key, required this.features, this.onItemToggle})
      : super(key: key);

  @override
  _FeatureDisplayState createState() => _FeatureDisplayState();
}

class _FeatureDisplayState extends State<FeatureDisplay> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const PositionedListHeader(
              child: Text('Features'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: IgnorePointer(
                ignoring: selected == null,
                child: AnimatedOpacity(
                  opacity: selected != null ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: () {
                      setState(() => selected = null);
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
            child: selected == null
                ? FeatureGrid(
                    features: widget.features,
                    onTapItem: (index) {
                      setState(() => selected = index);
                      widget.onItemToggle?.call();
                    },
                  )
                : SizedBox(
                    height: 500,
                    child: GalleryPageView(
                      itemCount: widget.features.length,
                      controller: PageController(initialPage: selected!),
                      builder: (context, index) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: FeatureCard(
                            item: widget.features[index],
                            expanded: true,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class FeatureGrid extends StatelessWidget {
  final List<FeatureItem> features;
  final void Function(int index)? onTapItem;

  const FeatureGrid({Key? key, required this.features, this.onTapItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount =
              (constraints.maxWidth / 350).clamp(2, double.infinity).round();
          EdgeInsets padding;
          if (constraints.maxWidth > 600) {
            padding = const EdgeInsets.all(8);
          } else {
            padding = const EdgeInsets.all(0);
          }
          return GridView(
            physics: const NeverScrollableScrollPhysics(),
            controller: ScrollController(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.5,
            ),
            children: features
                .map(
                  (e) => Padding(
                    padding: padding,
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
        },
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final FeatureItem item;
  final bool expanded;
  final VoidCallback? onTap;

  const FeatureCard(
      {Key? key, required this.item, this.onTap, this.expanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[900]!,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              expanded ? const EdgeInsets.all(32) : const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.icon,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
              if (expanded) const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  expanded ? item.description : item.subtitle,
                  textAlign: expanded ? null : TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
