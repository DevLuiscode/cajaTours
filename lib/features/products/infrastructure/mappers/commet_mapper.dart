import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/infrastructure/models/comment_db.dart';
import 'package:teslo_shop/features/products/infrastructure/models/post_comments_response.dart';

class CommetMapper {
  static Commet jsonToEntity(CommentDb commentDb) => Commet(
        id: commentDb.id.toString(),
        idDest: commentDb.idDest.toString(),
        idUser: commentDb.idUser.toString(),
        detail: commentDb.detail,
      );
}

class PostCommetMapper {
  static Commet jsonToEntity(Result resultdb) => Commet(
        id: resultdb.id.toString(),
        idDest: resultdb.idDest.toString(),
        idUser: resultdb.idUser.toString(),
        detail: resultdb.detail,
      );
}
