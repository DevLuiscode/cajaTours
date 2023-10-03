import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({int limit = 10, int offset = 1});
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProductByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
