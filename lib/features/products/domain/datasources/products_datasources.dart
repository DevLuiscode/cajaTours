import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/domain/entities/like.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsDataSources {
  Future<List<Product>> getProducts({int limit = 10, int offset = 1});
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
