import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/features/products/presentation/providers/comments_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/post_comment.dart';

import '../../../auth/presentation/providers/providers.dart';

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
        children: [
          ItemComments(commetID: commetID),
          Comment(
            idDest: commetID,
          ),
        ],
      ),
    );
  }
}

class Comment extends ConsumerWidget {
  final String idDest;
  static final TextEditingController commentController =
      TextEditingController();

  const Comment({
    super.key,
    required this.idDest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authProvider);
    final user = authState.user;
    //TextEditingController commentController = TextEditingController();
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
                    controller: commentController,
                    onChanged: (value) {
                      ref
                          .read(commentFormProvider.notifier)
                          .onCommentTextChange(
                            idDest,
                            user!.id,
                            value,
                          );
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe un comentario...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                        )),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (commentController.text.isNotEmpty) {
                      await ref
                          .read(commentFormProvider.notifier)
                          .onFormSubmit();

                      await ref
                          .read(commentsProvider.notifier)
                          .loadComments(idDest);
                      commentController.clear();
                    }
                  },
                  icon: const Icon(Icons.send))
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
    final themeText = Theme.of(context).textTheme;

    final comments = ref.watch(commentsProvider);
    final authState = ref.read(authProvider);
    final user = authState.user;

    final fullName = "${user?.name} ${user?.lastname}";

    return Expanded(
      flex: 6,
      child: ListView.builder(
        itemCount: comments.comment.length,
        itemBuilder: ((context, index) {
          final comment = comments.comment[index];
          return (fullName == comment.idUser)
              ? Dismissible(
                  key: Key(fullName),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(left: 200),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    ref
                        .read(commentFormProvider.notifier)
                        .deleteComment(comment.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorCommnet,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.idUser,
                                style: themeText.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                comment.detail,
                                style: themeText.titleSmall
                                    ?.copyWith(fontSize: 15),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        (comment.idUser == fullName)
                            ? const Icon(
                                Icons.person,
                                color: colorSeed,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorCommnet,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.idUser,
                              style: themeText.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              comment.detail,
                              style:
                                  themeText.titleSmall?.copyWith(fontSize: 15),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      (comment.idUser == fullName)
                          ? const Icon(
                              Icons.person,
                              color: colorSeed,
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
