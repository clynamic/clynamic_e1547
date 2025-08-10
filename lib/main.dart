import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:seo/seo.dart';

import 'download.dart';
import 'features.dart';
import 'gallery.dart';
import 'info.dart';
import 'navigation.dart';
import 'reviews.dart';
import 'scrolling.dart';
import 'social.dart';
import 'theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '$siteName - $appTitle',
        theme: appTheme,
        home: const Home(),
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
                      child: Seo.image(
                        alt: appTitle,
                        src: appIcon,
                        child: Image.asset(appIcon, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Seo.text(
                      text: appTitle,
                      style: TextTagStyle.h1,
                      child: Text(
                        appTitle,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(0, 8),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            child: Column(
              children: [
                Seo.text(
                  text: appDescription,
                  style: TextTagStyle.h2,
                  child: const Text(
                    appDescription,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ScreenshotInlineGallery(
                  assets: {
                    for (final e in screenshotNames) e: '$screenshotDir$e.png',
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
            name: NavigationHeaders.Reviews.name,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Seo.text(
                  text: 'Reviews',
                  style: TextTagStyle.h3,
                  child: const Text('Reviews'),
                ),
                Seo.text(
                  text: reviewInfo,
                  child: Text(
                    reviewInfo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            child: ReviewList(reviews: reviews),
          ),
          PositionedListItem(
            name: NavigationHeaders.Download.name,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Seo.text(
                  text: 'Download',
                  style: TextTagStyle.h3,
                  child: const Text('Download'),
                ),
                Seo.text(
                  text: downloadInfo,
                  child: Text(
                    downloadInfo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            child: const DownloadList(downloads: downloads),
          ),
          PositionedListItem(
            name: NavigationHeaders.Social.name,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Seo.text(
                  text: 'Social',
                  style: TextTagStyle.h3,
                  child: const Text('Social'),
                ),
                Seo.text(
                  text: socialInfo,
                  child: Text(
                    socialInfo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ).copyWith(bottom: 32),
              child: const SocialWrap(socials: socials),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: constant_identifier_names
enum NavigationHeaders { e1547, Features, Reviews, Download, Social }
