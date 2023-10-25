import 'package:teslo_shop/features/products/domain/entities/like.dart';
import 'package:teslo_shop/features/products/infrastructure/models/get_like_response.dart';

class GetLikeMapper {
  static Like jsonToEntity(GetLikeResponse response) =>
      Like(like: response.result.toString());
}

class PostLikeMapper {
  static PostLikeResult jsonToEntity(Map<String, dynamic> json) =>
      PostLikeResult(
        id: json["id"],
        idUser: json["idUser"],
        idDest: json["idDest"],
      );
}

class DeleteLikeMapper {
  static DeleteLikeResponse jsonToEntity(Map<String, dynamic> json) =>
      DeleteLikeResponse(
        response: json["response"],
        resultDelete: List<String>.from(json["result"].map((x) => x as String)),
      );
}
