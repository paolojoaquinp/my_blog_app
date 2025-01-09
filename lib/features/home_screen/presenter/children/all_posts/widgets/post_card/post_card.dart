import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.grey,
        width: double.infinity,
        height: double.infinity,
        child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 12.0,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Community",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.04,
                        ),
                        Text(
                          'Somnio Software at Google I/O 2024: AI, Flutter, and the road ahead for App Development',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        // descripcion
                        Text(
                          'Unlock the power of AI with generative media models & enhanced search! Google I/O 2024 unveiled a developer-focused future with Gemini & advancements in Flutter.',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                        // button read more
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
