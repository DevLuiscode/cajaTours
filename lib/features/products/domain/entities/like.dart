class Like {
  final String like;

  Like({
    required this.like,
  });
}

class PostLikeResponse {
  String response;
  PostLikeResult postlikeresult;

  PostLikeResponse({
    required this.response,
    required this.postlikeresult,
  });

  factory PostLikeResponse.fromJson(Map<String, dynamic> json) =>
      PostLikeResponse(
        response: json["response"],
        postlikeresult: PostLikeResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "postlikeresult": postlikeresult.toJson(),
      };
}

class PostLikeResult {
  int id;
  int idUser;
  int idDest;
  bool state;

  PostLikeResult(
      {required this.id,
      required this.idUser,
      required this.idDest,
      this.state = false});

  factory PostLikeResult.fromJson(Map<String, dynamic> json) => PostLikeResult(
        id: json["id"],
        idUser: json["idUser"],
        idDest: json["idDest"],
        state: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idUser": idUser,
        "idDest": idDest,
        "estado": state,
      };
}

class DeleteLikeResponse {
  String response;
  List<String> resultDelete;

  DeleteLikeResponse({
    required this.response,
    required this.resultDelete,
  });

  factory DeleteLikeResponse.fromJson(Map<String, dynamic> json) =>
      DeleteLikeResponse(
        response: json["response"],
        resultDelete: List<String>.from(json["result"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": List<dynamic>.from(resultDelete.map((x) => x)),
      };
}
