part of 'all_posts_bloc.dart';

sealed class AllPostsState extends Equatable {
  const AllPostsState();
}

final class AllPostsInitial extends AllPostsState {
  @override
  List<Object> get props => [];
}

class AllPostsLoadingState extends AllPostsState {
  const AllPostsLoadingState();
  
  @override
  List<Object> get props => [];  
}

class AllPostsDataLoadedState extends AllPostsState {
  const AllPostsDataLoadedState({
    required this.postsResponse,
  });

  final List<PostModel> postsResponse;

  @override
  List<Object> get props => [postsResponse];
}

class AllPostsEmptyDataState extends AllPostsState {
  const AllPostsEmptyDataState();

  @override
  List<Object> get props => [];
}

class ErrorState extends AllPostsState {
  const ErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}