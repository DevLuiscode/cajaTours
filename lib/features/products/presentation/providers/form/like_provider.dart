import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/like.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';

import '../products_repository_provider.dart';

final likesProvider = StateNotifierProvider<LikesNotifier, LikesState>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);

    return LikesNotifier(productsRepository: productsRepository);
  },
);

class LikesNotifier extends StateNotifier<LikesState> {
  final ProductsRepository productsRepository;
  LikesNotifier({
    required this.productsRepository,
  }) : super(LikesState()) {
    // Inicialmente, no cargamos ningún comentario
    state = state.copyWith(like: Like(like: ''));
  }

  Future<void> loadLikes(String idDestino) async {
    final likes = await productsRepository.getLikes(idDestino);

    state = state.copyWith(
      like: likes,
    );
  }

  Future<void> postLikes(String idDestino) async {
    final likes = await productsRepository.posLike(idDestino);

    state = state.copyWith(
      postLikeResult: likes,
      button: true,
    );

    // likes.state = false;
  }

  Future<void> deleteLikes(String idLike) async {
    final deleteLike = await productsRepository.deleteLike(idLike);

    state = state.copyWith(
      deleteLikeResponse: deleteLike,
      button: false,
    );
  }
}

class LikesState {
  final Like? like;
  final PostLikeResult? postLikeResult;
  final bool? button;
  final DeleteLikeResponse? deleteLikeResponse;

  LikesState({
    this.like,
    this.postLikeResult,
    this.button = false,
    this.deleteLikeResponse,
  });

  LikesState copyWith({
    Like? like,
    PostLikeResult? postLikeResult,
    bool? button,
    DeleteLikeResponse? deleteLikeResponse,
  }) {
    return LikesState(
      like: like ?? this.like,
      postLikeResult: postLikeResult ?? this.postLikeResult,
      button: button ?? this.button,
      deleteLikeResponse: deleteLikeResponse ?? this.deleteLikeResponse,
    );
  }
}
