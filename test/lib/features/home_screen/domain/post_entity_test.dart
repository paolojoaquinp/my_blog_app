import 'package:flutter_test/flutter_test.dart';
import 'package:my_blog_app/features/home_screen/domain/entities/post_entity.dart';

void main() {
  group('PostEntity', () {
    test('should have the correct properties', () {
      const postEntity = PostEntity(
        userId: 1,
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
      );

      expect(postEntity.userId, 1);
      expect(postEntity.id, 1);
      expect(postEntity.title, 'Test Title');
      expect(postEntity.body, 'Test Body');
    });

    test('should support value equality', () {
      const postEntity1 = PostEntity(
        userId: 1,
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
      );
      const postEntity2 = PostEntity(
        userId: 1,
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
      );

      expect(postEntity1, equals(postEntity2));
    });

    test('should not be equal when properties differ', () {
      const postEntity1 = PostEntity(
        userId: 1,
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
      );
      const postEntity2 = PostEntity(
        userId: 2,
        id: 2,
        title: 'Different Title',
        body: 'Different Body',
      );

      expect(postEntity1, isNot(equals(postEntity2)));
    });
  });
}