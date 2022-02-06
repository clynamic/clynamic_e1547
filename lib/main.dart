import 'dart:html';

import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:clynamic/scrolling.dart';
import 'package:clynamic/theme.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

import 'gallery.dart';
import 'lorem.dart';
import 'navigation.dart';

void main() {
  runApp(const App());
}

const String appTitle = 'e1547';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'clynamic - $appTitle',
      theme: appTheme,
      home: const Home(),
      navigatorObservers: [routeObserver],
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final AnchorScrollController scrollController = AnchorScrollController();

  @override
  Widget build(BuildContext context) {
    return NavigationList(
      title:
          NavigationTitle(title: appTitle, scrollController: scrollController),
      scrollController: scrollController,
      sections: [
        ScrollSection(
          name: NavigationHeaders.e1547.name,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Wrap(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  shape: const CircleBorder(),
                  elevation: 16,
                  child: SizedBox(
                    height: 140,
                    child: Image.asset(
                      'assets/app-icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextRenderer(
                        element: HeadingElement.h1(),
                        text: Text(
                          appTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(color: Colors.white, shadows: [
                            const Shadow(
                              offset: Offset(0, 8),
                              blurRadius: 6,
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextRenderer(
                        text: Text(
                          'A sophisticated e621 experience for android and iOS\n\n',
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScreenshotGallery(
                  assets: {
                    for (final e in assetNames) e: 'assets/screenshots/$e.png'
                  },
                ),
              ],
            ),
          ),
        ),
        ScrollSection(
          name: NavigationHeaders.Features.name,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(lorem),
              ],
            ),
          ),
        ),
        ScrollSection(
          name: NavigationHeaders.Download.name,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(lorem),
              ],
            ),
          ),
        ),
        ScrollSection(
          name: NavigationHeaders.Social.name,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(lorem),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: constant_identifier_names
enum NavigationHeaders {
  e1547,
  Features,
  Download,
  Social,
}

final List<String> assetNames = [
  'search',
  'detail',
  'drawer',
  'blacklist',
  'settings',
  'forum',
  'following',
];

class HighlightCard extends StatelessWidget {
  final Widget child;

  const HighlightCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).cardColor,
      child: child,
    );
  }
}
