import '../../domain/domain.dart';

class UserMapper {
  static User userJsontoEntity(Map<String, dynamic> json) => User(
        id: json['id'].toString(),
        email: json['email'],
        name: json['name'],
        lastname: json['lastname'],
        roles: json['roles'],
        token: json['token'],
      );
}
