import 'dart:html';

import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:clynamic/scrolling.dart';
import 'package:clynamic/theme.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';

import 'features.dart';
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
        PositionedListItem(
          name: NavigationHeaders.e1547.name,
          title: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextRenderer(
                text: Text(
                  'A sophisticated e621 experience for android and iOS\n\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ScreenshotInlineGallery(
                assets: {
                  for (final e in assetNames) e: 'assets/screenshots/$e.png'
                },
              ),
            ],
          ),
        ),
        PositionedListItem.builder(
          name: NavigationHeaders.Features.name,
          builder: (context, index) => FeatureDisplay(
            features: features,
            onItemToggle: () => scrollController.scrollToIndex(index: index),
          ),
        ),
        PositionedListItem(
          name: NavigationHeaders.Download.name,
          title: const Text('Download'),
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
        PositionedListItem(
          name: NavigationHeaders.Social.name,
          title: const Text('Social'),
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

List<FeatureItem> features = [
  FeatureItem(
    title: 'Browse',
    subtitle: 'Browse posts, pools and relations easily',
    icon: const Icon(Icons.open_in_browser),
    description: '• Browse and search posts and pools\n\n'
        '• Autocomplete, add and subtract tags from searches\n\n'
        '• Click tags to search and long click to read their wiki\n\n'
        '• Reach parents, children and pools of a post in a single tap\n\n'
        '• Read descriptions with beautiful DText\n\n',
  ),
  FeatureItem(
    title: 'Like',
    subtitle: 'Favorite, vote on and block posts',
    icon: const Icon(Icons.favorite),
    description: '• Favorite posts and list your favorites\n\n'
        '• Sync your blacklist with full syntax support\n\n'
        '• Up and downvote posts\n\n'
        '• Edit post tags, descriptions, parents, ratings, and sources\n\n'
        '• Flag and report inappropriate posts\n\n',
  ),
  FeatureItem(
    title: 'Save',
    subtitle: 'Download pictures and follow tags',
    icon: const Icon(Icons.download),
    description: '• Download pictures and videos\n\n'
        '• Multi-download posts by long clicking them in the grid\n\n'
        '• Follow artists, tag searches and pools\n\n'
        '• Keep track of how many new posts for your follows are available\n\n'
        '• Share links or open posts in your browser',
  ),
  FeatureItem(
      title: 'Watch',
      subtitle: 'Swipe through images, videos and gifs',
      icon: const Icon(Icons.play_arrow),
      description: '• Swipe through detail and fullscreen post views\n\n'
          '• Watch short and long videos with matching controls\n\n'
          '• See animated gifs everywhere (you cant stop them)\n\n'
          '• Double tap videos to skip ahead or revert\n\n'
          '• Mute or unmute videos on the fly and in the settings\n\n'),
  FeatureItem(
    title: 'Talk',
    subtitle: 'Comment on posts and visit the forums',
    icon: const Icon(Icons.comment),
    description: '• Write comments with DText syntax and preview\n\n'
        '• Reply to other users or edit your comments\n\n'
        '• Up and downvote comments\n\n'
        '• See user profiles and see their stats and uploads\n\n'
        '• Browse and search forum threads\n\n'
        '• Report inappropriate comments\n\n',
  ),
  FeatureItem(
    title: 'Customize',
    subtitle: 'Adjust colors and grids to your liking',
    icon: const Icon(Icons.wb_twighlight),
    description: '• Choose from light, dark, amoled and the blue theme\n\n'
        '• Shrink or enlarge post tiles in the grid settings\n\n'
        '• Show post infos on tiles or have simple images only\n\n'
        '• Enable automatic upvoting when favoriting\n\n'
        '• Test out new features or keep it stable with the beta switch\n\n',
  ),
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
