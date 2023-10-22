class AllUserResponse {
  String response;
  String dataFor;
  List<AllUser> result;

  AllUserResponse({
    required this.response,
    required this.dataFor,
    required this.result,
  });

  factory AllUserResponse.fromJson(Map<String, dynamic> json) =>
      AllUserResponse(
        response: json["response"],
        dataFor: json["data_for"],
        result:
            List<AllUser>.from(json["result"].map((x) => AllUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data_for": dataFor,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class AllUser {
  int id;
  String name;
  String lastName;
  String email;
  String password;
  String rol;

  AllUser({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rol,
  });

  factory AllUser.fromJson(Map<String, dynamic> json) => AllUser(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "email": email,
        "password": password,
        "rol": rol,
      };
}
