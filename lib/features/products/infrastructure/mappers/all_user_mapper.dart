import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/models/all_user_response.dart';

class AllUserMapper {
  static User allUserToEntity(AllUser userdb) => User(
        id: userdb.id.toString(),
        email: userdb.email,
        name: userdb.name,
        lastname: userdb.lastName,
        roles: userdb.rol,
        token: '',
      );
}
