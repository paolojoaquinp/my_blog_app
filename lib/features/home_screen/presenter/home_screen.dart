import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/presenter/widgets/tab_views.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Material(
                elevation: 6.0,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: 'My feed',
                    ),
                    Tab(text: 'My Favorites'),
                  ],
                ),
              ),
              TabViews(),
            ],
          ),
        ),
      ),
   );
  }
}