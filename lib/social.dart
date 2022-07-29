import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';

class SocialItem {
  final String title;
  final String url;
  final Widget icon;

  const SocialItem({
    required this.title,
    required this.url,
    required this.icon,
  });
}

class SocialWrap extends StatelessWidget {
  final List<SocialItem> socials;

  const SocialWrap({Key? key, required this.socials}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Wrap(
          children: socials.map((e) => SocialCard(item: e)).toList(),
        ),
      ),
    );
  }
}

class SocialCard extends StatelessWidget {
  final SocialItem item;

  const SocialCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => launchUrl(Uri.parse(item.url)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: dimTextColor(context),
                    fontSize: 18,
                  ),
              child: IconTheme(
                data: Theme.of(context).iconTheme.copyWith(
                      color: dimTextColor(context),
                    ),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
