import 'dart:async';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/commet_mapper.dart';

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
      const String url = '/api/destination/alldestinations';
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
    throw UnimplementedError();
  }

  @override
  Future<List<Commet>> getComments(String idDest) async {
    final response =
        await dio.get<List>('/api/destination/commentsdestinos?idDest=$idDest');
    final List<Commet> comments = [];
    for (var commetJson in response.data ?? []) {
      if (commetJson is Map<String, dynamic>) {
        var comment = CommetMapper.jsonToEntity(commetJson);
        comments.add(comment);
      }
    }

    //response.data!.map((e) => CommetMapper.jsonToEntity(e));
    return comments;
  }
}
