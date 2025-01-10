part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class FavoritesInitialEvent extends FavoritesEvent {
  const FavoritesInitialEvent();

  @override
  List<Object> get props => [];
}

class FavoritePostsInitialEvent extends FavoritesEvent {
  const FavoritePostsInitialEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends FavoritesEvent {
  const AddFavoriteEvent({
    required this.idPost,
    required this.onEnd,
  });

  final int idPost;
  final VoidCallback onEnd;

  @override
  List<Object> get props => [idPost, onEnd];
}

class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();

  @override
  List<Object> get props => [];
}
