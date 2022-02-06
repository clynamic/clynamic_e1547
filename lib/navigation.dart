import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:backdrop/backdrop.dart';
import 'package:clynamic/scrolling.dart';
import 'package:flutter/material.dart';

class NavigationList extends StatelessWidget {
  final AnchorScrollController scrollController;
  final List<ScrollSection> sections;
  final Widget? title;

  const NavigationList({
    Key? key,
    required this.scrollController,
    required this.sections,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: scrollController,
      child: Material(
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: BackdropScaffold(
                    backgroundColor: Colors.transparent,
                    stickyFrontLayer: true,
                    appBar: BackdropAppBar(
                      title: title,
                      automaticallyImplyLeading: false,
                      actions: const [BackdropToggleButton()],
                    ),
                    frontLayerElevation: 4,
                    frontLayerScrim: Colors.black54,
                    backLayer: NavigationBackLayer(
                      headers: sections.map((e) => e.name).toList(),
                      scrollController: scrollController,
                    ),
                    frontLayer: PositionedListView(
                      scrollController: scrollController,
                      sections: sections,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBackLayer extends StatelessWidget {
  final List<String> headers;
  final AnchorScrollController scrollController;

  const NavigationBackLayer(
      {Key? key, required this.headers, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (String header in headers) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Backdrop.of(context).concealBackLayer();
                scrollController.scrollToIndex(index: headers.indexOf(header));
              },
              child: Text(
                header,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> separated = [];
    for (Widget child in children) {
      if (children.indexOf(child) == 0) {
        separated.add(child);
      } else {
        separated.add(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '•',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            child,
          ],
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              children: separated,
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationTitle extends StatefulWidget {
  final String title;
  final AnchorScrollController scrollController;

  const NavigationTitle(
      {Key? key, required this.title, required this.scrollController})
      : super(key: key);

  @override
  _NavigationTitleState createState() => _NavigationTitleState();
}

class _NavigationTitleState extends State<NavigationTitle> {
  bool showTitle = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(onIndexChanged);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onIndexChanged);
    super.dispose();
  }

  void onIndexChanged() {
    setState(() {
      showTitle = widget.scrollController.offset > 120;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool show = Backdrop.of(context).isBackLayerConcealed && showTitle;
    return MouseRegion(
      cursor: show ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap:
            show ? () => widget.scrollController.scrollToIndex(index: 0) : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: show ? 1 : 0,
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
