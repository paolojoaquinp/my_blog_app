part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesDataLoaded extends FavoritesState {
  final List<PostModel> favoritePosts;
  final List<String> favoriteIds;

  const FavoritesDataLoaded({
    required this.favoritePosts,
    required this.favoriteIds,
  });

  @override
  List<Object> get props => [favoritePosts, favoriteIds];
}

class FavoritePostsLoadingState extends FavoritesState {
  const FavoritePostsLoadingState();
  
  @override
  List<Object> get props => []; 
}


class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}
