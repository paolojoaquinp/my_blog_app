import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/data/datasources/api/post_repository_impl.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/bloc/all_posts_bloc.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/favorite_posts/bloc/favorites_bloc.dart';
import 'package:my_blog_app/features/shared/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// all_posts_tab.dart
class AllPostsTab extends StatelessWidget {
  const AllPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllPostsBloc>(
      create: (context) => AllPostsBloc(postRepository: PostRepositoryImpl())
        ..add(const AllPostsInitialEvent()),
      child: const Scaffold(
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllPostsBloc, AllPostsState>(
      builder: (context, state) {
        if (state is AllPostsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AllPostsDataLoadedState) {
          return Padding(
            padding: EdgeInsets.symmetric( horizontal: MediaQuery.sizeOf(context).width * 0.05),
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollUpdateNotification) {
                  context.read<AllPostsBloc>().add(
                    UpdateScrollPositionEvent(
                      scrollPosition: scrollInfo.metrics.pixels,
                      maxScrollExtent: scrollInfo.metrics.maxScrollExtent,
                    ),
                  );
                }
                return true;
              },
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.postsResponse.length + (state.isLoadingMore ? 1 : 0),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  if (index == state.postsResponse.length && state.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final post = state.postsResponse[index];
                  final favoritesBloc = context.read<FavoritesBloc>();
                  if (index >= 3) {
                    return SizedBox(
                            height: 510,
                            width: double.maxFinite,
                            child: PostCard(
                              post: post,
                              onPressed: () {
                                favoritesBloc.add(
                                  AddFavoriteEvent(
                                    idPost: post.id,
                                    onEnd: () {
                                      context
                                          .read<AllPostsBloc>()
                                          .add(const AllPostsLoadDataEvent());
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                  }
                  return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 1200 + (index * 200)),
                    builder: (context, animation, child) {
                      return Transform.translate(
                        offset: Offset(0.0, (MediaQuery.sizeOf(context).height*0.7) * (1 - animation)),
                        child: Opacity(
                          opacity: animation,
                          child: SizedBox(
                            height: 510,
                            width: double.maxFinite,
                            child: PostCard(
                              post: post,
                              onPressed: () {
                                favoritesBloc.add(
                                  AddFavoriteEvent(
                                    idPost: post.id,
                                    onEnd: () {
                                      context
                                          .read<AllPostsBloc>()
                                          .add(const AllPostsLoadDataEvent());
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}