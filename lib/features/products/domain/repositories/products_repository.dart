import 'package:teslo_shop/features/products/domain/entities/like.dart';

import '../entities/commet.dart';
import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({int limit = 15, int offset = 1});
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProductByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
  Future<List<Commet>> getComments(String idDest);
  Future<Commet> deleteComment(String idComment);
  Future<Commet> postComment(
    String idDest,
    String idUser,
    String detail,
  );
  Future<Like> getLikes(String idDest);
  Future<PostLikeResult> posLike(String idDest);
  Future<DeleteLikeResponse> deleteLike(String idLike);
}
