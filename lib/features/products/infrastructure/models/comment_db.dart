class CommentDb {
  int id;
  int idDest;
  int idUser;
  String detail;

  CommentDb({
    required this.id,
    required this.idDest,
    required this.idUser,
    required this.detail,
  });

  factory CommentDb.fromJson(Map<String, dynamic> json) => CommentDb(
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
