import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog_app/core/config/text_theme.dart';
import 'package:my_blog_app/core/constants/app_strings.dart';
import 'package:my_blog_app/core/helpers/hive_helper.dart';
import 'package:my_blog_app/features/home_screen/data/datasources/api/post_repository_impl.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/favorite_posts/bloc/favorites_bloc.dart';
import 'package:my_blog_app/features/home_screen/presenter/widgets/bubble_tab_indicator.dart';
import 'package:my_blog_app/features/home_screen/presenter/widgets/tab_views.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollFactorNotifier = ValueNotifier<double>(0.0);

    return BlocProvider<FavoritesBloc>(
      create: (context) => FavoritesBloc(
        postRepository: PostRepositoryImpl(),
        hivePreferences: HiveHelper(),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: _Body(
            scrollFactorNotifier: scrollFactorNotifier,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.scrollFactorNotifier,
  });

  final ValueNotifier<double> scrollFactorNotifier;

  @override
  Widget build(BuildContext context) {
    const expandedHeight = 120.0;
    final customTextTheme = textTheme;
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification &&
              notification.depth == 0) {
            final newScrollFactor =
                (notification.metrics.pixels / 120.0).clamp(0.0, 1.0);
            scrollFactorNotifier.value = newScrollFactor;
          }
          return true;
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              ValueListenableBuilder<double>(
                valueListenable: scrollFactorNotifier,
                builder: (context, scrollFactor, _) {
                  return SliverAppBar(
                    expandedHeight: expandedHeight,
                    toolbarHeight: 0,
                    collapsedHeight: 0,
                    clipBehavior: Clip.none,
                    title: AnimatedOpacity(
                      opacity: 1.0 - scrollFactor,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        width: double.maxFinite,
                        height: lerpDouble(120.0, 0.0, scrollFactor),
                        color: Colors.transparent,
                        clipBehavior: Clip.none,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.appBarTitle,
                              style: customTextTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: lerpDouble(35.0, 0.0, scrollFactor),
                                  ),
                            ),
                            Transform.translate(
                              offset: Offset(
                                0,
                                lerpDouble(0.0, -20.0, scrollFactor)!,
                              ),
                              child: Opacity(
                                opacity: lerpDouble(1.0, 0.0, scrollFactor)!,
                                child: Text(
                                  AppStrings.appBarSubtitle,
                                  style: customTextTheme
                                      .labelSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
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
                    floating: false,
                    snap: false,
                    primary: true,
                    stretch: true,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48.0),
                      child: Container(
                        height: 48.0,
                        color: Colors.white,
                        child: TabBar(
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          indicator: const BubbleTabIndicator(
                            color: Colors.black,
                            height: 35,
                            radius: 20,
                            padding: EdgeInsets.symmetric(horizontal: 1),
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
                                  const Icon(Icons.newspaper),
                                  const SizedBox(width: 8),
                                  Tab(text: AppStrings.tabBarFeedTitle),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.favorite),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Tab(text: AppStrings.tabBarFavoritesTitle),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ];
          },
          body: const TabViews(),
        ),
      ),
    );
  }
}
