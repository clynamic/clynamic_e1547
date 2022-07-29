import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadItem {
  final String title;
  final String url;
  final String? infoUrl;
  final Widget icon;

  const DownloadItem({
    required this.title,
    required this.url,
    required this.icon,
    this.infoUrl,
  });
}

class DownloadList extends StatelessWidget {
  final List<DownloadItem> downloads;

  const DownloadList({Key? key, required this.downloads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: downloads.map((e) => DownloadCard(item: e)).toList(),
      ),
    );
  }
}

class DownloadCard extends StatelessWidget {
  final DownloadItem item;

  const DownloadCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => launchUrl(Uri.parse(item.url)),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  item.icon,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: LinkRenderer(
                                      text: item.title,
                                      href: item.url,
                                      child: Text(
                                        item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.infoUrl != null) ...[
                              const VerticalDivider(),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () =>
                                    launchUrl(Uri.parse(item.infoUrl!)),
                                icon: const Icon(Icons.question_mark),
                                iconSize: Theme.of(context).iconTheme.size,
                              ),
                            ] else
                              const SizedBox(
                                width: 40,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
