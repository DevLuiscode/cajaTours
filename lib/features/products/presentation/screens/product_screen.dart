import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/form/like_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/form/product_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';

import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:video_player/video_player.dart';

import '../providers/comments_provider.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));
    return Scaffold(
      body: productState.isLoading
          ? const FullScreenLoader()
          : _DestinosView(
              product: productState.product!,
            ),
    );
  }
}

class _DestinosView extends ConsumerStatefulWidget {
  final Product product;

  const _DestinosView({
    required this.product,
  });

  @override
  _DestinosViewState createState() => _DestinosViewState();
}

class _DestinosViewState extends ConsumerState<_DestinosView> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 200);
    ref.read(commentsProvider.notifier).loadComments(widget.product.id);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider);
    final cantidadComments = comments.comment.length;

    return Stack(
      children: [
        CustomScrollView(
          controller: _controller,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: BuilderPersistenDelegate(
                maxExtent: MediaQuery.of(context).size.height,
                minExtent: MediaQuery.of(context).size.height *
                    0.30, // Ajusta este valor según sea necesario
                builder: (porcent) {
                  return AnimatedDetailHeader(
                    product: widget.product,
                    topPorcent: ((1 - porcent) / .7).clamp(0.0, 1.0),
                    bottomPorcent: (porcent / .7).clamp(0.0, 1.0),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.black12,
                        ),
                        Flexible(
                          child: Text(
                            widget.product.location,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.product.description),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemExtent: 200,
                        itemCount: widget.product.videos.length,
                        itemBuilder: (context, index) {
                          final videoUrl = widget.product.videos[index].url;

                          final RegExp exp = RegExp(r'd/([a-zA-Z0-9_-]+)/');
                          final match = exp.firstMatch(videoUrl);
                          String url = '';
                          if (match != null) {
                            final fileId = match.group(1);
                            url =
                                'https://drive.google.com/uc?export=download&id=$fileId';
                          }

                          return VideoReproductor(
                            videoUrl: url,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned.fill(
          top: null,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0),
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await ref
                          .read(commentsProvider.notifier)
                          .loadComments(widget.product.id);
                      await Future.delayed(const Duration(seconds: 1));
                      context.push('/comments/${widget.product.id}');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Comentarios',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            '+$cantidadComments',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      getPermisos();
                      final latitude = widget.product.latitude;
                      final longitude = widget.product.longitude;

                      context.push('/map/$latitude/$longitude');
                    },
                    child: const Icon(Icons.location_on),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class VideoReproductor extends StatefulWidget {
  final String videoUrl;
  const VideoReproductor({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoReproductor> createState() => _VideoReproductorState();
}

class _VideoReproductorState extends State<VideoReproductor> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        // Asegúrate de que el controlador esté inicializado antes de mostrar el video.
        setState(() {});
        _controller.pause();
        _controller.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _controller.value.isInitialized
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        VideoReproductorScreen(video: widget.videoUrl)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

class AnimatedDetailHeader extends StatelessWidget {
  const AnimatedDetailHeader({
    super.key,
    required this.topPorcent,
    required this.product,
    required this.bottomPorcent,
  });

  final Product product;
  final double topPorcent;
  final double bottomPorcent;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final sizeHeih = MediaQuery.of(context).size.height * 0.4;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 200 * (1 - bottomPorcent),
                  top: (20 + topPadding) * (1 - bottomPorcent),
                ),
                child: Transform.scale(
                  scale: lerpDouble(1.5, 1.3, bottomPorcent),
                  child: ImagePlace(product: product),
                ),
              ),
              Positioned(
                top: topPadding + 5,
                left: 100 * (0.05 - bottomPorcent),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  onPressed: () {
                    context.push('/user');
                  },
                ),
              ),
              Positioned(
                top: lerpDouble(sizeHeih * 0.1, 100, topPorcent),
                left: lerpDouble(60, 30, topPorcent)!.clamp(20.0, 50.0),
                right: 20,
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: lerpDouble(
                          20,
                          30,
                          topPorcent,
                        ),
                      ),
                ),
              ),
              Positioned(
                top: lerpDouble(sizeHeih * 0.2, 300, topPorcent),
                left: lerpDouble(60, 30, topPorcent)!.clamp(20.0, 50.0),
                right: 200,
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.orange,
                        Color.fromARGB(255, 250, 214, 167),
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Destino Preferido',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
              child: LikesAndShare(
            id: product.id,
          )),
        ),
      ],
    );
  }
}

class TranslateAnimation extends StatelessWidget {
  const TranslateAnimation({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: 0),
      curve: Curves.easeInOutBack,
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100.0 * value),
          child: child,
        );
      },
      child: child,
    );
  }
}

class LikesAndShare extends ConsumerStatefulWidget {
  final String id;
  const LikesAndShare({
    required this.id,
    super.key,
  });

  @override
  _LikesAndShareState createState() => _LikesAndShareState();
}

class _LikesAndShareState extends ConsumerState<LikesAndShare> {
  @override
  void initState() {
    ref.read(likesProvider.notifier).loadLikes(widget.id);
    ref.read(likesProvider).postLikeResult?.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final likes = ref.watch(likesProvider);

    final countLikes = likes.like?.like;
    final buttonLike = likes.button;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () async {
              if (buttonLike == false) {
                await ref.read(likesProvider.notifier).postLikes(widget.id);
              }
              final delete = ref.read(likesProvider).postLikeResult?.id;

              if (buttonLike == true) {
                await ref
                    .read(likesProvider.notifier)
                    .deleteLikes(delete.toString());
              }

              await ref.read(likesProvider.notifier).loadLikes(widget.id);
            },
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: Theme.of(context).textTheme.titleSmall),
            icon: ref.watch(likesProvider).postLikeResult?.idDest ==
                        int.parse(widget.id) &&
                    buttonLike == true
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                  ),
            label: Text('$countLikes'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ImagePlace extends StatelessWidget {
  const ImagePlace({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: PageController(viewportFraction: .9),
            itemCount: product.imgs.length,
            itemBuilder: (context, index) {
              final imageUrl = product.imgs[index].url;

              final RegExp exp = RegExp(r'd/([a-zA-Z0-9_-]+)/');
              final match = exp.firstMatch(imageUrl);
              String imgurl = '';
              if (match != null) {
                // Construye y retorna la nueva URL usando el ID del archivo
                final fileId = match.group(1);

                imgurl = 'https://drive.google.com/uc?export=view&id=$fileId';
              }

              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage(
                      'assets/loaders/bottle-loader.gif',
                    ),
                    image: NetworkImage(
                      imgurl,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            product.imgs.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              color: Colors.black,
              height: 4,
              width: 10,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class BuilderPersistenDelegate extends SliverPersistentHeaderDelegate {
  BuilderPersistenDelegate({
    required double maxExtent,
    required double minExtent,
    required this.builder,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent;

  final double _maxExtent;
  final double _minExtent;
  final Widget Function(double porcent) builder;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(shrinkOffset / _maxExtent);
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;

    final productForm = ref.watch(productFormProvider(product));

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: product.imgs),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(productForm.name.value, style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.name.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onNameChange,
            errorMessage: productForm.name.errorMessage,
          ),
          CustomProductField(
            isBottomField: false,
            label: 'ubicacion',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.ubicacion.value,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onUbicacionChange,
            errorMessage: productForm.ubicacion.errorMessage,
          ),
          CustomProductField(
            isBottomField: false,
            label: 'Longitude',
            initialValue: productForm.longitude.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onLongitudeChange(value),
            errorMessage: productForm.longitude.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Latitud',
            initialValue: productForm.latitude.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onLatitudeChange(value),
            errorMessage: productForm.latitude.errorMessage,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description.value,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChange,
            errorMessage: productForm.description.errorMessage,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<Img> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset('assets/images/no-image.jpg',
                      fit: BoxFit.cover))
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  e.url,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
    );
  }
}

getPermisos() async {
  final status = await Permission.location.request();

  switch (status) {
    case PermissionStatus.granted:
    case PermissionStatus.denied:
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.provisional:
    case PermissionStatus.permanentlyDenied:
  }
}
