part of 'all_posts_bloc.dart';

sealed class AllPostsEvent extends Equatable {
  const AllPostsEvent();
}


class AllPostsInitialEvent extends AllPostsEvent {
  const AllPostsInitialEvent();
  
  @override
  List<Object> get props => [];
}

class AllPostsLoadDataEvent extends AllPostsEvent {
  const AllPostsLoadDataEvent();
  
  @override
  List<Object> get props => [];
}