import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/comments_provider.dart';

class CommentScreen extends StatelessWidget {
  final String commetID;
  const CommentScreen({super.key, required this.commetID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: Column(
        children: [ItemComments(commetID: commetID), const Comment()],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        top: false,
        child: Container(
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: colorCommnet,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe un comentario...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                        )),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }
}

class ItemComments extends ConsumerStatefulWidget {
  const ItemComments({
    super.key,
    required this.commetID,
  });

  final String commetID;

  @override
  _ItemCommentsState createState() => _ItemCommentsState();
}

class _ItemCommentsState extends ConsumerState<ItemComments> {
  @override
  void initState() {
    super.initState();
    ref.read(commentsProvider.notifier).loadComments(widget.commetID);
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider);
    return Expanded(
      flex: 6,
      child: ListView.builder(
        itemCount: comments.comment.length,
        itemExtent: 100,
        itemBuilder: ((context, index) {
          final comment = comments.comment[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorSeed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.idUser,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  comment.detail,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
