import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/page/all_posts_tab.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/favorite_posts/page/favorite_posts_tab.dart';

class TabViews extends StatelessWidget {
  const TabViews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: TabBarView(
        children: [
          AllPostsTab(),
          FavoritesTab(),
        ],
      ),
    );
  }
}