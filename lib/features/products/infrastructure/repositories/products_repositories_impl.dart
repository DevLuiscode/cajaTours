import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/domain/entities/like.dart';

import '../../domain/domain.dart';

class ProductsRepositoriesImpl extends ProductsRepository {
  final ProductsDataSources dataSources;

  ProductsRepositoriesImpl(this.dataSources);
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return dataSources.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return dataSources.getProductById(id);
  }

  @override
  Future<List<Product>> getProducts({int limit = 15, int offset = 1}) {
    return dataSources.getProducts();
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    return dataSources.searchProductByTerm(term);
  }

  @override
  Future<List<Commet>> getComments(String idDest) {
    return dataSources.getComments(idDest);
  }

  @override
  Future<Commet> postComment(String idDest, String idUser, String detail) {
    return dataSources.postComment(idDest, idUser, detail);
  }

  @override
  Future<Commet> deleteComment(String idComment) {
    return dataSources.deleteComment(idComment);
  }

  @override
  Future<Like> getLikes(String idDest) {
    return dataSources.getLikes(idDest);
  }

  @override
  Future<PostLikeResult> posLike(String idDest) {
    return dataSources.posLike(idDest);
  }

  @override
  Future<DeleteLikeResponse> deleteLike(String idLike) {
    return dataSources.deleteLike(idLike);
  }
}
