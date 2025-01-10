import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';

part 'all_posts_event.dart';
part 'all_posts_state.dart';

class AllPostsBloc extends Bloc<AllPostsEvent, AllPostsState> {
  AllPostsBloc({required this.postRepository}) : super(AllPostsInitial()) {
    on<AllPostsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AllPostsInitialEvent>(_onAllPostsInitialEvent);
    on<AllPostsLoadDataEvent>(_onAllPostsLoadDataEvent);
  }

  final PostRepository postRepository;

  Future<void> _onAllPostsInitialEvent(
    AllPostsInitialEvent event,
    Emitter<AllPostsState> emit,
  ) async {
    emit(AllPostsLoadingState());
    final results = await postRepository.getAllPosts();

    results.when(
      ok: (data) {
        if (data.isNotEmpty) {
          emit(AllPostsDataLoadedState(postsResponse: data));
        }
      },
      err: (err) => {emit(ErrorState(error: err.toString()))},
    );
  }

  Future<void> _onAllPostsLoadDataEvent(
      AllPostsLoadDataEvent event, Emitter<AllPostsState> emit) async {
    try {
      final results = await postRepository.getAllPosts();
      results.when(
        ok: (data) {
          if (data.isNotEmpty) {
            emit(AllPostsDataLoadedState(postsResponse: data));
          } else {
            emit(const AllPostsEmptyDataState());
          }
        },
        err: (err) {
          emit(ErrorState(error: err.toString()));
        },
      );
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
