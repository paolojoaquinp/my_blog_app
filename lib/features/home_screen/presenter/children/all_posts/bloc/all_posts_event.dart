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
// all_posts_event.dart
class UpdateScrollPositionEvent extends AllPostsEvent {
  final double scrollPosition;
  final double maxScrollExtent;

  const UpdateScrollPositionEvent({
    required this.scrollPosition,
    required this.maxScrollExtent,
  });

  @override
  List<Object> get props => [scrollPosition, maxScrollExtent];
}

class LoadMorePostsEvent extends AllPostsEvent {
  @override
  List<Object?> get props => [];
}