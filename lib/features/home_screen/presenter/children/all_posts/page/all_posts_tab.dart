import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/data/datasources/api/post_repository_impl.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/bloc/all_posts_bloc.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/favorite_posts/bloc/favorites_bloc.dart';
import 'package:my_blog_app/features/shared/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPostsTab extends StatelessWidget {
  const AllPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllPostsBloc>(
      create: (context) => AllPostsBloc(postRepository: PostRepositoryImpl())..add(const AllPostsInitialEvent()),
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
    return BlocBuilder<AllPostsBloc, AllPostsState>(
      builder: (context, state) {
        if (state is AllPostsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AllPostsDataLoadedState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.05),
            child: ListView.builder(
              itemCount: state.postsResponse.length,
              itemBuilder: (context, index) {
                final post = state.postsResponse[index];
                final favoritesBloc = context.read<FavoritesBloc>();
                return SizedBox(
                  height: 510,
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
