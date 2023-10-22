import 'package:flutter/material.dart';

import 'package:teslo_shop/config/config.dart';

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

class ItemComments extends StatelessWidget {
  const ItemComments({
    super.key,
    required this.commetID,
  });

  final String commetID;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: ListView.builder(
        itemCount: 10,
        itemExtent: 100,
        itemBuilder: ((context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorSeed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              commetID,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }),
      ),
    );
  }
}
