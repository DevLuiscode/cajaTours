class PostCommetsResponse {
  String response;
  Result result;

  PostCommetsResponse({
    required this.response,
    required this.result,
  });

  factory PostCommetsResponse.fromJson(Map<String, dynamic> json) =>
      PostCommetsResponse(
        response: json["response"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": result.toJson(),
      };
}

class Result {
  int id;
  int idDest;
  int idUser;
  String detail;

  Result({
    required this.id,
    required this.idDest,
    required this.idUser,
    required this.detail,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        idDest: json["idDest"],
        idUser: json["idUser"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idDest": idDest,
        "idUser": idUser,
        "detail": detail,
      };
}
