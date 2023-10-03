import 'dart:async';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';

class ProductsDataSourcesImple implements ProductsDataSources {
  late final Dio dio;
  final String accessToken;

  ProductsDataSourcesImple({
    required this.accessToken,
  }) : dio = Dio(BaseOptions(
          baseUrl: Environment.apiurl,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      // final String? productId = productLike['id'];

      // final String method = (productId == null) ? 'POST' : 'PATCH';
      // final String url = (productId == null)
      //     ? '/api/destination/alldestinations'
      //     : '/api/destination/alldestinations/id=$productId';
      // productLike.remove('id');

      // print(jsonEncode(productLike));

      // final response = await dio.request(
      //   url,
      //   data: productLike,
      //   options: Options(
      //     method: method,
      //   ),
      // );

      // final product = ProductMapper.jsonToEntity(response.data);

      // return product;

      final String? productId = productLike['id'];

      final String url = '/api/destination/alldestinations';
      productLike.remove('id');

      final response = await dio.post(
        url,
        data: productLike,
      );

      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final ids = int.parse(id);
      final response = await dio.get('/api/destination/getdestid?id=$ids');
      print('Response data: ${response.data['result']}');
      final product = ProductMapper.jsonToEntity(response.data['result']);

      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) throw ProductNotFount();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProducts({int offset = 1, int limit = 10}) async {
    final response = await dio.get<List>(
        '/api/destination/destinationpag?pageIndex=$offset&pageSize=$limit');

    final List<Product> products = [];

    for (var productJson in response.data ?? []) {
      if (productJson is Map<String, dynamic>) {
        var product = ProductMapper.jsonToEntity(productJson);

        products.add(product);
      }
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
