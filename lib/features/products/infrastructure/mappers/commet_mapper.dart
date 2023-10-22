import 'package:teslo_shop/features/products/domain/entities/commet.dart';

class CommetMapper {
  static Commet jsonToEntity(Map<String, dynamic> json) => Commet(
        id: json["id"],
        idDest: json["idDest"],
        idUser: json["idUser"],
        detail: json["detail"],
      );
}
