import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/presenter/widgets/tab_views.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text('Home'),
                  pinned: true,
                  floating: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        onTap: (index) {
                          // Aquí puedes manejar el cambio de tab si lo necesitas
                        },
                        tabs: const [
                          Tab(text: 'My feed'),
                          Tab(text: 'My Favorites'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: const TabViews(),
          ),
        ),
      ),
    );
  }
}