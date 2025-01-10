import 'package:flutter/material.dart';
import 'package:my_blog_app/features/home_screen/data/models/post_model.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onPressed,
  });

  final PostModel post;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 20),
        width: double.infinity,
        height: double.infinity,
        child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 6.0,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // chip
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Community",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            IconButton(onPressed: onPressed, icon: Icon(Icons.favorite_outline),),
                          ],
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Text(
                          // 'Somnio Software at Google I/O 2024: AI, Flutter, and the road ahead for App Development ajkdsnfjkadsnfjkads',
                          post.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.1
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          softWrap: true,
                        ),
                        Container(
                          width: double.maxFinite,
                          height: constraints.maxHeight * 0.2,
                          child: Text(
                            post.body,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),Spacer(),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            'Read More',
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      letterSpacing: 0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          icon: Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 28.0,
                            color: Colors.blue,
                          ),
                          iconAlignment: IconAlignment.end,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Elimina todo el padding
                            alignment: Alignment
                                .centerLeft, // Alinea contenido hacia la izquierda
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.35,
                  width: constraints.maxWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.network(
                      'https://picsum.photos/250?image=9',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
