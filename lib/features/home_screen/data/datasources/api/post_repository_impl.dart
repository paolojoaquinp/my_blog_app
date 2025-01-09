import 'package:dio/dio.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';
import 'package:my_blog_app/features/home_screen/domain/repositories/post_repository.dart';
import 'package:oxidized/oxidized.dart';

class PostRepositoryImpl implements PostRepository {
  final Dio _dio = Dio();

  @override
  Future<Result<List<PostModel>, DioException>> getAllPosts() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return Ok(data.map((post) => PostModel.fromJson(post)).toList());
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
}