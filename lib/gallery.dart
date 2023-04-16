import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

import 'navigation.dart';
import 'scrolling.dart';
import 'theme.dart';

class ScreenshotInlineGallery extends StatelessWidget {
  const ScreenshotInlineGallery({super.key, required this.assets});

  final Map<String, String> assets;

  @override
  Widget build(BuildContext context) {
    return ExpandableCardInset(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 42),
        child: SizedBox(
          height: 400,
          child: GalleryPageView(
            tileWidth: 190,
            padEnds: false,
            itemCount: assets.length,
            builder: (context, index) => ScreenshotCard(
              aspectRatio: 0.47,
              assetPath: assets.values.toList()[index],
              name: assets.keys.toList()[index],
              onTap: () {
                showScreenshotFullscreenGallery(
                  context,
                  assets,
                  index,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void showScreenshotFullscreenGallery(
  BuildContext context,
  Map<String, String> assets,
  int? initialIndex,
) {
  Navigator.of(context).push(
    MaterialTransparentRoute(
      builder: (context) => ScreenshotFullscreenGallery(
        assets: assets,
        initialIndex: initialIndex,
      ),
    ),
  );
}

class ScreenshotFullscreenGallery extends StatelessWidget {
  const ScreenshotFullscreenGallery({
    super.key,
    required this.assets,
    this.initialIndex,
  });

  final Map<String, String> assets;
  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [
          CloseButton(),
        ],
        backgroundColor: Colors.transparent,
        flexibleSpace: const IgnorePointer(),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).maybePop();
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 1000,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: GalleryPageView(
                initialIndex: initialIndex ?? 0,
                itemCount: assets.length,
                builder: (context, index) => ScreenshotCard(
                  aspectRatio: 0.47,
                  assetPath: assets.values.toList()[index],
                  name: assets.keys.toList()[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenshotCard extends StatelessWidget {
  const ScreenshotCard({
    super.key,
    required this.assetPath,
    required this.name,
    this.aspectRatio = 1,
    this.onTap,
  });
  final String assetPath;
  final String name;
  final VoidCallback? onTap;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Center(
            child: Hero(
              tag: 'screenshot_$name',
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).colorScheme.background,
                  elevation: 8,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: ImageRenderer(
                          alt: name,
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: onTap,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextRenderer(
            style: TextRendererStyle.header6,
            child: Text(name),
          ),
        ),
      ],
    );
  }
}

class GalleryPageView extends StatefulWidget {
  const GalleryPageView({
    super.key,
    required this.builder,
    this.itemCount,
    this.padEnds = true,
    this.tileWidth,
    this.viewportFraction,
    this.initialIndex = 0,
  }) : assert(tileWidth == null || viewportFraction == null,
            'Cannot specify tileWidth and viewportFraction');

  final bool padEnds;
  final double? tileWidth;
  final double? viewportFraction;
  final int? itemCount;
  final IndexedWidgetBuilder builder;
  final int initialIndex;

  @override
  State<GalleryPageView> createState() => _GalleryPageViewState();
}

class _GalleryPageViewState extends State<GalleryPageView> {
  late PageController controller =
      PageController(initialPage: widget.initialIndex);

  void updatePageController(double maxWidth) {
    double oneOrHigher(double value) => (value > 1) ? 1 : value;
    double updated;
    if (widget.viewportFraction != null) {
      updated = widget.viewportFraction!;
    } else if (widget.tileWidth != null) {
      updated = oneOrHigher(widget.tileWidth! / maxWidth);
    } else {
      updated = 1;
    }
    if (updated != controller.viewportFraction) {
      controller = PageController(
        viewportFraction: updated,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const DesktopScrollBehaviour(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          updatePageController(constraints.maxWidth);
          return Row(
            children: [
              GalleryPageButton(
                controller: controller,
                direction: GalleryButtonDirection.left,
              ),
              Expanded(
                child: PageView.builder(
                  padEnds: widget.padEnds,
                  controller: controller,
                  itemCount: widget.itemCount,
                  itemBuilder: widget.builder,
                ),
              ),
              GalleryPageButton(
                controller: controller,
                direction: GalleryButtonDirection.right,
              ),
            ],
          );
        },
      ),
    );
  }
}

enum GalleryButtonDirection {
  left,
  right,
}

class GalleryPageButton extends StatefulWidget {
  const GalleryPageButton({
    super.key,
    required this.direction,
    required this.controller,
  });

  final GalleryButtonDirection direction;
  final PageController controller;

  @override
  State<GalleryPageButton> createState() => _GalleryPageButtonState();
}

class _GalleryPageButtonState extends State<GalleryPageButton> {
  bool dimButton = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.hasClients &&
          widget.controller.position.hasContentDimensions) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getIcon() {
      switch (widget.direction) {
        case GalleryButtonDirection.left:
          return const Icon(Icons.keyboard_arrow_left);
        case GalleryButtonDirection.right:
          return const Icon(Icons.keyboard_arrow_right);
      }
    }

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        bool enabled = false;

        if (widget.controller.hasClients &&
            widget.controller.position.hasContentDimensions) {
          switch (widget.direction) {
            case GalleryButtonDirection.left:
              enabled = widget.controller.position.minScrollExtent <
                  widget.controller.position.pixels;
              break;
            case GalleryButtonDirection.right:
              enabled = widget.controller.position.maxScrollExtent >
                  widget.controller.position.pixels;
              break;
          }
        }

        return AnimatedOpacity(
          opacity: enabled ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                Expanded(
                  child: IgnorePointer(
                    ignoring: !enabled,
                    child: MouseRegion(
                      onEnter: (event) => setState(() => dimButton = false),
                      onExit: (event) => setState(() => dimButton = true),
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.grey,
                          end: dimButton
                              ? Colors.grey
                              : Theme.of(context).iconTheme.color,
                        ),
                        duration: const Duration(milliseconds: 100),
                        builder: (context, value, child) => IconButton(
                          onPressed: () {
                            int page = widget.controller.page!.round();
                            switch (widget.direction) {
                              case GalleryButtonDirection.left:
                                page--;
                                break;
                              case GalleryButtonDirection.right:
                                page++;
                                break;
                            }
                            widget.controller.animateToPage(
                              page,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: getIcon(),
                          color: value,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
