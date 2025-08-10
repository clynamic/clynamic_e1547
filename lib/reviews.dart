import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewItem {
  const ReviewItem({
    required this.user,
    this.avatar,
    required this.text,
    required this.stars,
    required this.date,
    required this.link,
  });

  final String user;
  final String? avatar;
  final String text;
  final int stars;
  final DateTime date;
  final String link;
}

class ReviewList extends StatelessWidget {
  const ReviewList({super.key, required this.reviews});

  final List<ReviewItem> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: reviews.map((e) => ReviewCard(item: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.item});

  final ReviewItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.avatar != null)
                          CircleAvatar(
                            radius: 16,
                            foregroundImage: NetworkImage(item.avatar!),
                            child: const Icon(Icons.person),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          item.user,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        for (var i = 0; i < item.stars; i++)
                          const Icon(Icons.star, color: Colors.amber),
                        for (var i = item.stars; i < 5; i++)
                          const Icon(Icons.star, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.text),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('d MMM y, HH:mm').format(item.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
