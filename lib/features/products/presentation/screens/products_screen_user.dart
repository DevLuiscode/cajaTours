import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsUserScreen extends StatelessWidget {
  const ProductsUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Destinos'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
          )
        ],
      ),
      body: const _ProductsView(),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemExtent: 350,
        itemCount: productsState.product.length,
        itemBuilder: (context, index) {
          final product = productsState.product[index];
          return GestureDetector(
            onTap: () {
              context.push('/user/product/${product.id}');
            },
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}
