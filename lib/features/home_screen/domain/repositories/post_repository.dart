import 'package:dio/dio.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:oxidized/oxidized.dart';

abstract class PostRepository {
  Future<Result<List<PostModel>, DioException>> getAllPosts();
   Future<Result<List<PostModel>, String>> getPaginatedPosts({
    required int page,
    required int limit,
  });
}