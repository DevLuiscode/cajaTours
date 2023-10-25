import 'package:teslo_shop/features/products/domain/entities/commet.dart';
import 'package:teslo_shop/features/products/infrastructure/models/delete_response.dart';

class DeleteMapper {
  static Commet jsoToEntity(DeleteResult deleteResult) => Commet(
        id: deleteResult.id.toString(),
        idDest: deleteResult.idDest.toString(),
        detail: deleteResult.detail,
      );
}
