import 'dart:async';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/domain/entities/like.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/all_user_mapper.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/commet_mapper.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/delete_mapper.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/get_like_mapper.dart';
import 'package:teslo_shop/features/products/infrastructure/models/all_user_response.dart';
import 'package:teslo_shop/features/products/infrastructure/models/comments_response.dart';
import 'package:teslo_shop/features/products/infrastructure/models/delete_response.dart';
import 'package:teslo_shop/features/products/infrastructure/models/get_like_response.dart';
import 'package:teslo_shop/features/products/infrastructure/models/post_comments_response.dart';
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
  Future<List<Product>> getProducts({int offset = 1, int limit = 15}) async {
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
        await dio.get('/api/destination/commentsdestinos?idDest=$idDest');
    final responseAllUser = await dio.get('/auth/allusers');
    final commentDb = CommetsResponse.fromJson(response.data);
    final allUserDb = AllUserResponse.fromJson(responseAllUser.data);

    final List<User> allUser =
        allUserDb.result.map((e) => AllUserMapper.allUserToEntity(e)).toList();

    final List<Commet> comments = commentDb.result.map((commentdb) {
      final comment = CommetMapper.jsonToEntity(commentdb);
      final userId = comment.idUser;

      final user = allUser.firstWhere((user) => user.id == userId);

      comment.idUser = "${user.name} ${user.lastname}";

      return comment;
    }).toList();

    return comments;
  }

  @override
  Future<Commet> postComment(
      String detail, String idDest, String idUser) async {
    final response = await dio.post(
      '/api/destination/addcomment/$idDest',
      data: {
        "idDest": idDest,
        "idUser": idUser,
        "detail": detail,
      },
    );

    final comm = PostCommetsResponse.fromJson(response.data);

    final comment = PostCommetMapper.jsonToEntity(comm.result);
    return comment;
  }

  @override
  Future<Commet> deleteComment(String idComment) async {
    final response =
        await dio.delete('/api/destination/deletecomment/$idComment');
    final commetData = DeleteResponse.fromJson(response.data);
    final commentResult = DeleteMapper.jsoToEntity(commetData.result);
    return commentResult;
  }

  @override
  Future<Like> getLikes(String idDest) async {
    final response = await dio.get('/api/destination/listlikeforid/$idDest');

    final likeResponse = GetLikeResponse.fromJson(response.data);
    final Like like = GetLikeMapper.jsonToEntity(likeResponse);

    return like;
  }

  @override
  Future<PostLikeResult> posLike(String idDest) async {
    final response = await dio.post('/api/destination/likedest/$idDest');
    final postResponse = PostLikeResponse.fromJson(response.data);

    final PostLikeResult result =
        PostLikeMapper.jsonToEntity(postResponse.postlikeresult.toJson());

    return result;
  }

  @override
  Future<DeleteLikeResponse> deleteLike(String idLike) async {
    final response =
        await dio.delete('/api/destination/dislikedest?id=$idLike');

    final deleteResponse = DeleteLikeResponse.fromJson(response.data);

    final DeleteLikeResponse result =
        DeleteLikeMapper.jsonToEntity(deleteResponse.toJson());

    return result;
  }
}
