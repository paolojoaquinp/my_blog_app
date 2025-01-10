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
  });

  final int idPost;
  @override
  List<Object> get props => [idPost];
}

class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();

  @override
  List<Object> get props => [];
}
