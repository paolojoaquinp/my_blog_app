import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';

part 'all_posts_event.dart';
part 'all_posts_state.dart';

class AllPostsBloc extends Bloc<AllPostsEvent, AllPostsState> {
  AllPostsBloc({required this.postRepository}) : super(AllPostsInitial()) {
    on<AllPostsInitialEvent>(_onAllPostsInitialEvent);
    on<LoadMorePostsEvent>(_onLoadMorePostsEvent);
    on<UpdateScrollPositionEvent>(_onUpdateScrollPosition);
    on<AllPostsLoadDataEvent>(_onAllPostsLoadDataEvent);
  }

  final PostRepository postRepository;
  int _currentPage = 1;
  static const int _postsPerPage = 3;
  bool _isLoadingMore = false;

  Future<void> _onAllPostsInitialEvent(
    AllPostsInitialEvent event,
    Emitter<AllPostsState> emit,
  ) async {
    emit(const AllPostsLoadingState());
    _currentPage = 1;
    final results = await postRepository.getPaginatedPosts(
      page: _currentPage,
      limit: _postsPerPage,
    );

    results.when(
      ok: (data) {
        if (data.isNotEmpty) {
          emit(AllPostsDataLoadedState(
            postsResponse: data,
            isLoadingMore: false,
          ));
        } else {
          emit(const AllPostsEmptyDataState());
        }
      },
      err: (err) => emit(ErrorState(error: err)),
    );
  }

  Future<void> _onLoadMorePostsEvent(
    LoadMorePostsEvent event,
    Emitter<AllPostsState> emit,
  ) async {
    if (state is! AllPostsDataLoadedState || _isLoadingMore) return;

    final currentState = state as AllPostsDataLoadedState;
    
    try {
      _isLoadingMore = true;
      emit(currentState.copyWith(isLoadingMore: true));
      
      _currentPage++;
      final results = await postRepository.getPaginatedPosts(
        page: _currentPage,
        limit: _postsPerPage,
      );

      results.when(
        ok: (newPosts) async {
          if (newPosts.isEmpty) {
            // No más posts disponibles
            emit(currentState.copyWith(isLoadingMore: false));
            return;
          }
          emit(AllPostsDataLoadedState(
            postsResponse: [...currentState.postsResponse, ...newPosts],
            isLoadingMore: false,
          ));
        },
        err: (err) {
          _currentPage--; // Revertir el incremento de página en caso de error
          emit(currentState.copyWith(isLoadingMore: false));
          // Opcionalmente emitir un estado de error temporal
          emit(ErrorState(error: err));
          emit(currentState); // Volver al estado anterior
        },
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  void _onUpdateScrollPosition(
    UpdateScrollPositionEvent event,
    Emitter<AllPostsState> emit,
  ) {
    if (event.scrollPosition >= event.maxScrollExtent * 0.8) {
      add(LoadMorePostsEvent());
    }
  }

  Future<void> _onAllPostsLoadDataEvent(
      AllPostsLoadDataEvent event, Emitter<AllPostsState> emit) async {
    try {
      final results = await postRepository.getAllPosts();
      results.when(
        ok: (data) {
          if (data.isNotEmpty) {
            emit(AllPostsDataLoadedState(
              postsResponse: data,
              isLoadingMore: false,
            ));
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