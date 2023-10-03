import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsDataSources {
  Future<List<Product>> getProducts({int limit = 10, int offset = 1});
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProductByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
