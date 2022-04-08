import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadItem {
  final String title;
  final String url;
  final Widget icon;

  const DownloadItem({
    required this.title,
    required this.url,
    required this.icon,
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
                  color: Colors.grey[900]!,
                  child: InkWell(
                    onTap: () => launch(item.url),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          item.icon,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.headline6!,
                            ),
                          ),
                        ],
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
