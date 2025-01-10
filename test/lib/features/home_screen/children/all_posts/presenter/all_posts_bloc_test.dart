import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_blog_app/core/helpers/hive_helper.dart';
import 'package:my_blog_app/features/home_screen/data/datasources/api/post_repository_impl.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/all_posts/bloc/all_posts_bloc.dart';
import 'package:oxidized/oxidized.dart';

class MockDioException extends Mock implements DioException {}

class MockHiveHelper extends Mock implements HiveHelper {}

class MockPostsRepository extends Mock implements PostRepositoryImpl {}

var mockPosts = [
  const PostModel(
    userId: 1,
    id: 101,
    title: 'Mock Post Title 1',
    body: 'This is the body of Mock Post 1.',
    isFavorite: true,
  ),
  const PostModel(
    userId: 2,
    id: 102,
    title: 'Mock Post Title 2',
    body: 'This is the body of Mock Post 2.',
    isFavorite: false,
  ),
  const PostModel(
    userId: 3,
    id: 103,
    title: 'Mock Post Title 3',
    body: 'This is the body of Mock Post 3.',
    isFavorite: true,
  ),
];

void main() {
  group('AllPostsBloc', () {
    late PostRepository postsRepository;
    late AllPostsBloc allPostsBloc;
    late HiveHelper hiveHelper;

    setUp(() {
      postsRepository = MockPostsRepository();
      hiveHelper = MockHiveHelper();
      allPostsBloc = AllPostsBloc(
        postRepository: postsRepository,
      );

      registerFallbackValue(Uri());
    });


    blocTest<AllPostsBloc, AllPostsState>(
        'emits [LoadingState, DataLoadedState] when restaurants are fetched successfully',
        build: () {
          when(() => postsRepository.getPaginatedPosts(page: 1, limit: 3)).thenAnswer((_) async {
            return Result.ok(
              mockPosts
            );
          });
          return allPostsBloc;
        },
        act: (bloc) => bloc.add(
          const AllPostsInitialEvent(),
        ),
        expect: () => [
          const AllPostsLoadingState(),
          isA<AllPostsDataLoadedState>(),
        ]
    );

    blocTest<AllPostsBloc, AllPostsState>(
        'emits [LoadingState, ErrorState] when fetching posts fails',
        build: () {
          when(() => postsRepository.getPaginatedPosts(page: 1, limit: 3)).thenAnswer(
            (_) async => const Result.err("Message"),
          );
          return allPostsBloc;
        },
        act: (bloc) => bloc.add(const AllPostsInitialEvent()),
        expect: () => [
          const AllPostsLoadingState(),
          isA<ErrorState>(),
        ],
      );
  });
}