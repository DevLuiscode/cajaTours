class Commet {
  final String id;
  final String idDest;
  String idUser;
  final String detail;

  Commet({
    required this.id,
    required this.idDest,
    this.idUser = '',
    required this.detail,
  });
}
