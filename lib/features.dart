import 'package:clynamic/gallery.dart';
import 'package:clynamic/theme.dart';
import 'package:flutter/material.dart';

import 'scrolling.dart';

class FeatureItem {
  final String title;
  final String subtitle;
  final Widget icon;
  final String description;

  const FeatureItem({
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
            PositionedListHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Features'),
                  AnimatedOpacity(
                    opacity: selected == null ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '(tap any)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                      initialIndex: selected!,
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
  final FeatureItem item;
  final bool expanded;
  final VoidCallback? onTap;

  const FeatureCard({
    Key? key,
    required this.item,
    this.onTap,
    this.expanded = false,
  }) : super(key: key);

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: dimTextColor(context, 0.8),
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
            child: Text(
              item.subtitle,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: dimTextColor(context),
                  ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ];
      }
    }

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
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.headline6,
                        overflow: TextOverflow.ellipsis,
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
