import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/page/all_posts_tab.dart';

class TabViews extends StatelessWidget {
  const TabViews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TabBarView(
        children: [
          AllPostsTab(),
          Center(
            child: Text('data 2'),
          )
        ],
      ),
    );
  }
}