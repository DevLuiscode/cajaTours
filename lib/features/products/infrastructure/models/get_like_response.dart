class GetLikeResponse {
  String response;
  int result;

  GetLikeResponse({
    required this.response,
    required this.result,
  });

  factory GetLikeResponse.fromJson(Map<String, dynamic> json) =>
      GetLikeResponse(
        response: json["response"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "result": result,
      };
}
