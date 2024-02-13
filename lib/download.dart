import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadItem {
  const DownloadItem({
    required this.title,
    required this.url,
    required this.icon,
    required this.platforms,
  });

  final String title;
  final String url;
  final Widget icon;
  final List<TargetPlatform> platforms;
}

class DownloadList extends StatelessWidget {
  const DownloadList({super.key, required this.downloads});

  final List<DownloadItem> downloads;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: downloads.map((e) => DownloadCard(item: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadCard extends StatelessWidget {
  const DownloadCard({super.key, required this.item});

  final DownloadItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => launchUrl(Uri.parse(item.url)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.icon,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LinkRenderer(
                          text: item.title,
                          href: item.url,
                          child: Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.platforms.map((e) => e.name).join(', '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
