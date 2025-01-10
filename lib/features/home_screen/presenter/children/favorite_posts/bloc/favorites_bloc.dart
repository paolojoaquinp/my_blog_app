import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_blog_app/core/helpers/hive_helper.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required this.postRepository,
    required this.hivePreferences,
  }) : super(FavoritesInitial()) {
    on<FavoritePostsInitialEvent>(_onFavoritePostsInitialEvent);
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavoriteEvent);
  }

  final PostRepository postRepository;
  final HiveHelper hivePreferences;
Future<void> _onFavoritePostsInitialEvent(FavoritePostsInitialEvent event, Emitter<FavoritesState> emit) async {
  emit(FavoritePostsLoadingState());

  final resultsPosts = await postRepository.getAllPosts();
  final ids = hivePreferences.getAllFavoriteIds();

  resultsPosts.when(
    ok: (data) {
      if (data.isNotEmpty) {
        // Filtrar los posts que coincidan con los IDs favoritos
        final favoritePosts = data.where((post) => ids.contains(post.id.toString())).toList();

        emit(FavoritesDataLoaded(
          favoriteIds: ids,
          favoritePosts: favoritePosts,
        ));
      } else {
        // Emitir estado vacío si no hay datos
        emit(const FavoritesDataLoaded(
          favoriteIds: [],
          favoritePosts: [],
        ));
      }
    },
    err: (err) => emit(FavoritesError(err.toString())),
  );
}


  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());

      // Obtener los IDs de favoritos guardados
      final favoriteIds = hivePreferences.getAllFavoriteIds();

      // Obtener todos los posts
      final allPostsResult = await postRepository.getAllPosts();

      allPostsResult.when(
        ok: (data) {          
          final favoritePosts =
              data.where((post) => favoriteIds.contains(post.id)).toList();

          emit(FavoritesDataLoaded(
            favoritePosts: favoritePosts,
            favoriteIds: favoriteIds,
          ));
        },
        err: (err) => emit(
          FavoritesError(err.response.toString()),
        ),
      );
      // Filtrar solo los posts favoritos
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onAddFavoriteEvent(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favoriteIds = hivePreferences.getAllFavoriteIds();

      if(favoriteIds.contains(event.idPost.toString())) {
          // Remover de favoritos
          await hivePreferences.removeFavorite(event.idPost.toString());
        } else {
          // Añadir a favoritos
          await hivePreferences.addFavorite(event.idPost.toString());
        
      }

    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
