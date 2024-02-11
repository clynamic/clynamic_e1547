import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_strategy/url_strategy.dart';

import 'download.dart';
import 'features.dart';
import 'gallery.dart';
import 'info.dart';
import 'navigation.dart';
import 'scrolling.dart';
import 'social.dart';
import 'theme.dart';

void main() {
  setPathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RobotDetector(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '$siteName - $appTitle',
        theme: appTheme,
        home: const Home(),
        navigatorObservers: [seoRouteObserver],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final AnchorScrollController scrollController = AnchorScrollController();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: siteBackgroundColor,
      child: NavigationList(
        title: NavigationTitle(
          title: appTitle,
          scrollController: scrollController,
        ),
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
                      child: ImageRenderer(
                        alt: appTitle,
                        child: Image.asset(
                          appIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextRenderer(
                      style: TextRendererStyle.header1,
                      child: Text(
                        appTitle,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
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
              children: [
                const TextRenderer(
                  style: TextRendererStyle.header2,
                  child: Text(
                    appDescription,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ScreenshotInlineGallery(
                  assets: {
                    for (final e in screenshotNames) e: '$screenshotDir$e.png'
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
            title: const TextRenderer(
              style: TextRendererStyle.header3,
              child: Text('Download'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextRenderer(
                    child: Text(
                      downloadInfo,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: dimTextColor(context, 0.6)),
                    ),
                  ),
                ),
                const DownloadList(downloads: downloads),
              ],
            ),
          ),
          PositionedListItem(
            name: NavigationHeaders.Social.name,
            title: const TextRenderer(
              style: TextRendererStyle.header3,
              child: Text('Social'),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ).copyWith(
                bottom: 32,
              ),
              child: const SocialWrap(
                socials: socials,
              ),
            ),
          ),
        ],
      ),
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
