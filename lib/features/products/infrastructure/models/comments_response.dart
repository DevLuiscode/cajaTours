import 'package:teslo_shop/features/products/infrastructure/models/comment_db.dart';

class CommetsResponse {
  String response;
  List<CommentDb> result;

  CommetsResponse({
    required this.response,
    required this.result,
  });

  factory CommetsResponse.fromJson(Map<String, dynamic> json) =>
      CommetsResponse(
        response: json["response"],
        result: List<CommentDb>.from(
            json["result"].map((x) => CommentDb.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}
