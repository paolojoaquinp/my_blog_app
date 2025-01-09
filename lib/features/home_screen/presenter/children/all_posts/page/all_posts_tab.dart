import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/widgets/post_card/post_card.dart';

class AllPostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: List.generate(
          7,
          (index) => SizedBox(
            height: 520,
            width: double.maxFinite,
            child: PostCard(index: index),
          ),
        ),
      ),
    );
  }
}
