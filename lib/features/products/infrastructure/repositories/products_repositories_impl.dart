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
  Future<List<Product>> getProducts({int limit = 10, int offset = 1}) {
    return dataSources.getProducts();
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    return dataSources.searchProductByTerm(term);
  }
}
