import 'package:flutter/material.dart';
import 'package:my_blog_app/core/helpers/hive_helper.dart';
import 'package:my_blog_app/features/home_screen/data/datasources/api/post_repository_impl.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/bloc/all_posts_bloc.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/favorite_posts/bloc/favorites_bloc.dart';
import 'package:my_blog_app/features/shared/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesBloc>(
      create: (context) => FavoritesBloc(
        postRepository: PostRepositoryImpl(),
        hivePreferences: HiveHelper(),
      )..add(const FavoritePostsInitialEvent()),
      child: Scaffold(
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is AllPostsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FavoritesDataLoaded) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05),
            child: ListView.builder(
              itemCount: state.favoritePosts.length ,
              itemBuilder: (context, index) {
                final post = state.favoritePosts[index];
                final favoritesBloc = context.read<FavoritesBloc>();
                return SizedBox(
                  height: 500,
                  width: double.maxFinite,
                  child: PostCard(
                    post: post,
                    onPressed: () {
                      favoritesBloc.add(AddFavoriteEvent(idPost: post.id));
                    },
                  ),
                );
              },
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
