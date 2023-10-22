import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

final commentsProvider = StateNotifierProvider<CommentsNotifier, CommentsState>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);

    return CommentsNotifier(productsRepository: productsRepository);
  },
);

class CommentsNotifier extends StateNotifier<CommentsState> {
  final ProductsRepository productsRepository;
  CommentsNotifier({
    required this.productsRepository,
  }) : super(CommentsState()) {
    // Inicialmente, no cargamos ningún comentario
    state = state.copyWith(comment: []);
  }

  Future loadComments(String idDestino) async {
    final comments = await productsRepository.getComments(idDestino);

    state = state.copyWith(
      comment: [...comments],
    );
  }
}

class CommentsState {
  final List<Commet> comment;

  CommentsState({this.comment = const []});

  CommentsState copyWith({
    List<Commet>? comment,
  }) {
    return CommentsState(
      comment: comment ?? this.comment,
    );
  }
}
