import 'package:dio/dio.dart';
import 'package:my_blog_app/core/helpers/hive_helper.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';
import 'package:oxidized/oxidized.dart';

class PostRepositoryImpl implements PostRepository {
  final Dio _dio = Dio();
  final HiveHelper hiveHelper = HiveHelper();
  @override
  Future<Result<List<PostModel>, DioException>> getAllPosts() async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final favoriteIds = hiveHelper.getAllFavoriteIds();

        final postsResponse = data.map((post) {
          final element = PostModel.fromJson(post);
          // verify is favorite
          print("$favoriteIds");
          final isFavorite = favoriteIds.contains(element.id.toString());
          return element.copyWith(isFavorite: isFavorite);
        }).toList();
        return Ok(postsResponse);
      }

      return Err(DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Failed to fetch posts: ${response.statusCode}',
      ));
    } on DioException catch (e) {
      return Err(e);
    }
  }

  @override
  Future<Result<List<PostModel>, String>> getPaginatedPosts({
    required int page,
    required int limit,
  }) async {
    try {
      // Calculate start and end indices for pagination
      final startIndex = (page - 1) * limit;

      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
        queryParameters: {
          '_start': startIndex,
          '_limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final favoriteIds = hiveHelper.getAllFavoriteIds();

        final postsResponse = data.map((post) {
          final element = PostModel.fromJson(post);
          final isFavorite = favoriteIds.contains(element.id.toString());
          return element.copyWith(isFavorite: isFavorite);
        }).toList();

        return Ok(postsResponse);
      }

      return Err('Failed to fetch posts: ${response.statusCode}');
    } on DioException catch (e) {
      return Err(e.message ?? 'An error occurred while fetching posts');
    } catch (e) {
      return Err('Unexpected error: $e');
    }
  }
}
