import 'package:clynamic/theme.dart';
import 'package:flutter/material.dart';

class ScreenshotGallery extends StatefulWidget {
  final Map<String, String> assets;

  const ScreenshotGallery({Key? key, required this.assets}) : super(key: key);

  @override
  _ScreenshotGalleryState createState() => _ScreenshotGalleryState();
}

class _ScreenshotGalleryState extends State<ScreenshotGallery> {
  PageController pageController = PageController();
  final double tileWidth = 180;
  final double buttonThreshold = 600;

  void updatePageController(double maxWidth) {
    double oneOrHigher(double value) => (value > 1) ? 1 : value;
    double updated = oneOrHigher(tileWidth / maxWidth);
    if (updated != pageController.viewportFraction) {
      pageController = PageController(
        viewportFraction: updated,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ScrollConfiguration(
        behavior: const DesktopScrollBehaviour(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            updatePageController(constraints.maxWidth);
            bool showButtons = constraints.maxWidth > buttonThreshold;
            return Row(
              children: [
                if (showButtons)
                  GalleryPageButton(
                    controller: pageController,
                    direction: GalleryButtonDirection.left,
                  ),
                Expanded(
                  child: PageView.builder(
                    padEnds: false,
                    controller: pageController,
                    itemCount: widget.assets.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Expanded(
                          child: Card(
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
                                    onTap: () {
                                      print(
                                          'gallery pressed: ${widget.assets.keys.toList()[index]}');
                                    },
                                  ),
                                )
                              ],
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
                if (showButtons)
                  GalleryPageButton(
                    controller: pageController,
                    direction: GalleryButtonDirection.right,
                  ),
              ],
            );
          },
        ),
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
  bool dim = true;

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
                    onEnter: (event) {
                      setState(() {
                        dim = false;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        dim = true;
                      });
                    },
                    child: TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                        begin: Colors.grey,
                        end: dim
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
