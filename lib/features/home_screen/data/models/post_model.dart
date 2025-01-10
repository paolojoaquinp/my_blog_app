import 'package:my_blog_app/features/home_screen/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
    this.isFavorite,
  });

  final bool? isFavorite;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
  
  PostModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    bool? isFavorite,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
