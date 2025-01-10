import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/presenter/widgets/bubble_tab_indicator.dart';
import 'package:my_blog_app/features/home_screen/presenter/widgets/tab_views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scrollFactor = 0.0;
  static const double expandedHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.depth == 0) {
                setState(() {
                  _scrollFactor =
                      (notification.metrics.pixels / 120.0).clamp(0.0, 1.0);
                });
              }
              return true;
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: expandedHeight,
                    toolbarHeight: 0,
                    collapsedHeight: 0,
                    clipBehavior: Clip.none,
                    title: AnimatedOpacity(
                      opacity: 1.0 - _scrollFactor,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        width: double.maxFinite,
                        height: lerpDouble(110.0, 0.0, _scrollFactor),
                        color: Colors.transparent,
                        clipBehavior: Clip.none,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blog',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontSize:
                                        lerpDouble(32.0, 0.0, _scrollFactor),
                                  ),
                            ),
                            Transform.translate(
                              offset: Offset(
                                0,
                                lerpDouble(0.0, -20.0, _scrollFactor)!,
                              ),
                              child: Opacity(
                                opacity: lerpDouble(1.0, 0.0, _scrollFactor)!,
                                child: Text(
                                  'My Blog app',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        fontSize: 14.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    centerTitle: false,
                    pinned: true,
                    snap: true,
                    floating: true,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48.0),
                      child: Container(
                        height: 48.0,
                        color: Colors.white,
                        child: TabBar(
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          indicator: BubbleTabIndicator(
                            color: Colors.black,
                            height: 35,
                            radius: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.newspaper),
                                  const SizedBox(width: 8),
                                  Tab(text: 'My feed'),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.favorite),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Tab(text: 'My Favorites'),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
