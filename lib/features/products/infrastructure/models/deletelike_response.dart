class DeleteLikeResponse {
  String response;
  List<String> result;

  DeleteLikeResponse({
    required this.response,
    required this.result,
  });

  factory DeleteLikeResponse.fromJson(Map<String, dynamic> json) =>
      DeleteLikeResponse(
        response: json["response"],
        result: List<String>.from(json["result"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": List<dynamic>.from(result.map((x) => x)),
      };
}
