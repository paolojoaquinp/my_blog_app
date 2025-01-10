import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oxidized/oxidized.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';
import 'package:my_blog_app/core/helpers/hive_helper.dart';
import 'package:my_blog_app/features/home_screen/presenter/children/favorite_posts/bloc/favorites_bloc.dart';

class MockPostRepository extends Mock implements PostRepository {}
class MockHiveHelper extends Mock implements HiveHelper {}
class MockDioException extends Mock implements DioException {}

void main() {
  group('FavoritesBloc', () {
    late PostRepository postRepository;
    late HiveHelper hiveHelper;
    late FavoritesBloc favoritesBloc;

    // Mock data
    final mockPosts = [
      const PostModel(
        userId: 1,
        id: 101,
        title: 'Mock Post Title 1',
        body: 'Body 1',
        isFavorite: true,
      ),
      const PostModel(
        userId: 2,
        id: 102,
        title: 'Mock Post Title 2',
        body: 'Body 2',
        isFavorite: false,
      ),
    ];

    setUp(() {
      postRepository = MockPostRepository();
      hiveHelper = MockHiveHelper();
      favoritesBloc = FavoritesBloc(
        postRepository: postRepository,
        hivePreferences: hiveHelper,
      );
    });

    tearDown(() {
      favoritesBloc.close();
    });

    test('initial state should be FavoritesInitial', () {
      expect(favoritesBloc.state, isA<FavoritesInitial>());
    });

    group('FavoritePostsInitialEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [LoadingState, DataLoadedState] when there are favorite posts',
        build: () {
          when(() => postRepository.getAllPosts())
              .thenAnswer((_) async => Result.ok(mockPosts));
          when(() => hiveHelper.getAllFavoriteIds())
              .thenReturn(['101']);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(const FavoritePostsInitialEvent()),
        expect: () => [
          const FavoritePostsLoadingState(),
          isA<FavoritesDataLoaded>()
              .having((state) => state.favoritePosts.length, 'has one favorite', 1)
              .having((state) => state.favoriteIds, 'contains correct id', ['101']),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [LoadingState, EmptyDataState] when there are no favorites',
        build: () {
          when(() => postRepository.getAllPosts())
              .thenAnswer((_) async => Result.ok(mockPosts));
          when(() => hiveHelper.getAllFavoriteIds())
              .thenReturn([]);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(const FavoritePostsInitialEvent()),
        expect: () => [
          const FavoritePostsLoadingState(),
          const FavoritesEmptyDataState(message: 'You don\'t have favorites yet'),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [LoadingState, ErrorState] when fetching posts fails',
        build: () {
        final dioError = MockDioException();
          when(() => postRepository.getAllPosts())
              .thenAnswer((_) async => Result.err(dioError));
          when(() => hiveHelper.getAllFavoriteIds())
              .thenReturn([]);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(const FavoritePostsInitialEvent()),
        expect: () => [
          const FavoritePostsLoadingState(),
          isA<FavoritesError>(),
        ],
      );
    });

    group('LoadFavoritesEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [LoadingState, DataLoadedState] when loading favorites succeeds',
        build: () {
          when(() => postRepository.getAllPosts())
              .thenAnswer((_) async => Result.ok(mockPosts));
          when(() => hiveHelper.getAllFavoriteIds())
              .thenReturn(['101', '102']);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(const LoadFavoritesEvent()),
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesDataLoaded>()
              .having((state) => state.favoritePosts.length, 'has two favorites', 2),
        ],
      );
    });

    group('AddFavoriteEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'adds post to favorites when not in favorites',
        build: () {
          when(() => hiveHelper.getAllFavoriteIds())
              .thenReturn([]);
          when(() => hiveHelper.addFavorite(any()))
              .thenAnswer((_) async => {});
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(AddFavoriteEvent(
          idPost: 101,
          onEnd: () {},
        )),
        verify: (_) {
          verify(() => hiveHelper.addFavorite('101')).called(1);
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'removes post from favorites when already in favorites',
        build: () {
          when(() => hiveHelper.getAllFavoriteIds())
              .thenReturn(['101']);
          when(() => hiveHelper.removeFavorite(any()))
              .thenAnswer((_) async => {});
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(AddFavoriteEvent(
          idPost: 101,
          onEnd: () {},
        )),
        verify: (_) {
          verify(() => hiveHelper.removeFavorite('101')).called(1);
        },
      );
    });
  });
}