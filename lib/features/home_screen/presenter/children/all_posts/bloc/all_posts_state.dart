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
  final List<PostModel> postsResponse;
  final bool isLoadingMore;

  const AllPostsDataLoadedState({
    required this.postsResponse,
    required this.isLoadingMore,
  });

  AllPostsDataLoadedState copyWith({
    List<PostModel>? postsResponse,
    bool? isLoadingMore,
  }) {
    return AllPostsDataLoadedState(
      postsResponse: postsResponse ?? this.postsResponse,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [postsResponse, isLoadingMore];
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