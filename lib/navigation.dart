import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';

import 'scrolling.dart';

class NavigationList extends StatelessWidget {
  const NavigationList({
    super.key,
    required this.scrollController,
    required this.sections,
    this.title,
  });

  final AnchorScrollController scrollController;
  final List<PositionedListItem> sections;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: scrollController,
      child: Material(
        color: Colors.transparent,
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
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      actions: [
                        Tooltip(
                          message: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                          child: const NavigationToggleButton(),
                        ),
                      ],
                    ),
                    frontLayerElevation: 4,
                    frontLayerScrim: Colors.black54,
                    backLayerBackgroundColor: Colors.transparent,
                    backLayer: NavigationBackLayer(
                      sections: sections,
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
  const NavigationBackLayer({
    super.key,
    required this.sections,
    required this.scrollController,
  });

  final List<PositionedListItem> sections;
  final AnchorScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (final section in sections) {
      if (section.name != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Backdrop.of(context).concealBackLayer();
                  scrollController.scrollToIndex(
                      index: sections.indexOf(section));
                },
                child: Text(
                  section.name!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
        );
      }
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
                style: Theme.of(context).textTheme.headlineSmall,
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
  const NavigationTitle({
    super.key,
    required this.title,
    required this.scrollController,
  });

  final String title;
  final AnchorScrollController scrollController;

  @override
  State<NavigationTitle> createState() => _NavigationTitleState();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showTitle = widget.scrollController.offset > 120;
      });
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
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}

class NavigationToggleButton extends StatelessWidget {
  const NavigationToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.close_menu,
        progress: Backdrop.of(context).animationController.view,
      ),
      tooltip: Backdrop.of(context).isBackLayerConcealed
          ? MaterialLocalizations.of(context).openAppDrawerTooltip
          : MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () => Backdrop.of(context).fling(),
    );
  }
}

class MaterialTransparentRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  MaterialTransparentRoute({
    required this.builder,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog,
  });

  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  bool get opaque => false;

  @override
  final bool maintainState;
}
