import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  Future<void> _onFavoritePostsInitialEvent(
      FavoritePostsInitialEvent event, Emitter<FavoritesState> emit) async {
    emit(const FavoritePostsLoadingState());

    final resultsPosts = await postRepository.getAllPosts();
    final ids = hivePreferences.getAllFavoriteIds();

    resultsPosts.when(
      ok: (data) {
        if (ids.isNotEmpty) {
          final favoritePosts =
              data.where((post) => ids.contains(post.id.toString())).toList();

          emit(FavoritesDataLoaded(
            favoriteIds: ids,
            favoritePosts: favoritePosts,
          ));
        } else {
          emit(
            const FavoritesEmptyDataState(
                message: 'You don\'t have favorites yet'),
          );
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

      final favoriteIds = hivePreferences.getAllFavoriteIds();
      final allPostsResult = await postRepository.getAllPosts();

      allPostsResult.when(
        ok: (data) {
          if (favoriteIds.isNotEmpty) {
            final favoritePosts = data
                .where((post) => favoriteIds.contains(post.id.toString()))
                .toList();

            emit(FavoritesDataLoaded(
              favoritePosts: favoritePosts,
              favoriteIds: favoriteIds,
            ));
          } else {
            emit(
              const FavoritesEmptyDataState(
                  message: 'You don\'t have favorites yet'),
            );
          }
        },
        err: (err) => emit(
          FavoritesError(err.response.toString()),
        ),
      );
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

      if (favoriteIds.contains(event.idPost.toString())) {
        // Remover de favoritos
        await hivePreferences.removeFavorite(event.idPost.toString());
      } else {
        // Añadir a favoritos
        await hivePreferences.addFavorite(event.idPost.toString());
      }
      event.onEnd();
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
