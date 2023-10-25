class DeleteResponse {
  String response;
  DeleteResult result;

  DeleteResponse({
    required this.response,
    required this.result,
  });

  factory DeleteResponse.fromJson(Map<String, dynamic> json) => DeleteResponse(
        response: json["response"],
        result: DeleteResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": result.toJson(),
      };
}

class DeleteResult {
  int id;
  int idDest;
  int idUser;
  String detail;

  DeleteResult({
    required this.id,
    required this.idDest,
    required this.idUser,
    required this.detail,
  });

  factory DeleteResult.fromJson(Map<String, dynamic> json) => DeleteResult(
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
