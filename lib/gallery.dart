import 'package:clynamic/scrolling.dart';
import 'package:clynamic/theme.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

class ScreenshotInlineGallery extends StatelessWidget {
  final Map<String, String> assets;

  const ScreenshotInlineGallery({Key? key, required this.assets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCardInset(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 42),
        child: SizedBox(
          height: 400,
          child: GalleryPageView(
            assets: assets,
            aspectRatio: 0.47,
            tileWidth: 190,
            padEnds: false,
            onTap: (index) {
              showScreenshotFullscreenGallery(
                context,
                assets,
                PageController(initialPage: index),
              );
            },
          ),
        ),
      ),
    );
  }
}

void showScreenshotFullscreenGallery(
  BuildContext context,
  Map<String, String> assets,
  PageController? controller,
) {
  Navigator.of(context).push(
    MaterialTransparentRoute(
      builder: (context) => ScreenshotFullscreenGallery(
        assets: assets,
        controller: controller,
      ),
    ),
  );
}

class ScreenshotFullscreenGallery extends StatelessWidget {
  final Map<String, String> assets;
  final PageController? controller;

  const ScreenshotFullscreenGallery(
      {Key? key, required this.assets, this.controller})
      : super(key: key);

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
                aspectRatio: 0.47,
                assets: assets,
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GalleryPageView extends StatefulWidget {
  final Map<String, String> assets;
  final bool padEnds;
  final double aspectRatio;
  final double? tileWidth;
  final double? viewportFraction;
  final void Function(int index)? onTap;
  final PageController? controller;

  GalleryPageView({
    Key? key,
    required this.assets,
    this.padEnds = true,
    this.aspectRatio = 1,
    this.tileWidth,
    this.viewportFraction,
    this.onTap,
    this.controller,
  }) : super(key: key) {
    assert(tileWidth == null || viewportFraction == null,
        'Cannot specify tileWidth and viewportFraction');
  }

  @override
  _GalleryPageViewState createState() => _GalleryPageViewState();
}

class _GalleryPageViewState extends State<GalleryPageView> {
  late PageController controller = widget.controller ?? PageController();

  @override
  void didUpdateWidget(covariant GalleryPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller = widget.controller ?? PageController();
    }
  }

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
                  itemCount: widget.assets.length,
                  itemBuilder: (context, index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Center(
                          child: Hero(
                            tag: 'asset_${widget.assets.keys.toList()[index]}',
                            child: AspectRatio(
                              aspectRatio: widget.aspectRatio,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Theme.of(context).backgroundColor,
                                elevation: 8,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        widget.assets.values.toList()[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        onTap: widget.onTap != null
                                            ? () => widget.onTap?.call(index)
                                            : null,
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
                        child: Text(widget.assets.keys.toList()[index]),
                      ),
                    ],
                  ),
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
  final GalleryButtonDirection direction;
  final PageController controller;

  const GalleryPageButton(
      {Key? key, required this.direction, required this.controller})
      : super(key: key);

  @override
  _GalleryPageButtonState createState() => _GalleryPageButtonState();
}

class _GalleryPageButtonState extends State<GalleryPageButton> {
  bool dimButton = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
        );
      },
    );
  }
}
