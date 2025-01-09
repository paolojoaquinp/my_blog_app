part of 'all_posts_bloc.dart';

sealed class AllPostsEvent extends Equatable {
  const AllPostsEvent();
}


class AllPostsInitialEvent extends AllPostsEvent {
  const AllPostsInitialEvent();
  
  @override
  List<Object> get props => [];
}