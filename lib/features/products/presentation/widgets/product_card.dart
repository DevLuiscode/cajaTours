import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageVier(
          img: product.imgs.first.url,
          title: product.name,
          location: product.location,
        ),

        // Text(product.name),
      ],
    );
  }
}

class _ImageVier extends StatelessWidget {
  final String img;
  final String title;
  final String location;
  const _ImageVier(
      {Key? key,
      required this.img,
      required this.title,
      required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegExp exp = RegExp(r'd/([a-zA-Z0-9_-]+)/');
    final match = exp.firstMatch(img);
    String imgurl = '';
    if (match != null) {
      // Construye y retorna la nueva URL usando el ID del archivo
      final fileId = match.group(1);

      imgurl = 'https://drive.google.com/uc?export=view&id=$fileId';
    }

    return Container(
      height: 320,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.red,
        image: DecorationImage(
          image: NetworkImage(imgurl),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Color.fromARGB(255, 156, 191, 251),
                ],
              ),
            ),
            child: Text(
              location,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
