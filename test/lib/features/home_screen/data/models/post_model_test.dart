

import 'package:flutter_test/flutter_test.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';

void main() {
  group('PostModel', () {
    const userId = 1;
    const id = 101;
    const title = 'Test Title';
    const body = 'Test Body';
    const jsonMap = {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };

    test('should return a valid model from JSON', () {
      final result = PostModel.fromJson(jsonMap);

      expect(result, isA<PostModel>());
      expect(result.userId, userId);
      expect(result.id, id);
      expect(result.title, title);
      expect(result.body, body);
    });

    test('should return a JSON map containing the proper data', () {
      const model = PostModel(
        userId: userId,
        id: id,
        title: title,
        body: body,
      );
      final result = model.toJson();
      expect(result, jsonMap);
    });

    test('copyWith should return a new instance with updated values', () {
      const model = PostModel(
        userId: userId,
        id: id,
        title: title,
        body: body,
      );
      final updatedModel = model.copyWith(title: 'Updated Title', isFavorite: true);

      expect(updatedModel.title, 'Updated Title');
      expect(updatedModel.isFavorite, true);
      expect(updatedModel.userId, userId);
      expect(updatedModel.id, id);
      expect(updatedModel.body, body);
    });

       test('should support value equality', () {
      const model1 = PostModel(
        userId: userId,
        id: id,
        title: title,
        body: body,
      );
      const model2 = PostModel(
        userId: userId,
        id: id,
        title: title,
        body: body,
      );

      expect(model1, equals(model2));
    });

    test('should not be equal when properties differ', () {
      const model1 = PostModel(
        userId: userId,
        id: id,
        title: title,
        body: body,
      );
      const model2 = PostModel(
        userId: 2,
        id: 102,
        title: 'Different Title',
        body: 'Different Body',
      );

      expect(model1, isNot(equals(model2)));
    });
  });
}
