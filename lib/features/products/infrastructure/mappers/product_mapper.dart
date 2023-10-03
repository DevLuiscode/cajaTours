import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductMapper {
  static Product jsonToEntity(Map<String, dynamic> json) => Product(
        id: json["id"].toString(),
        name: json["name"],
        description: json["description"],
        location: json["location"],
        latitude: json["latitude"] == null ? 0.0 : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? 0.0 : json["longitude"].toDouble(),
        imgs: List<Img>.from(json["imgs"].map((x) => Img.fromJson(x))),
        videos: json["videos"] == null
            ? []
            : List<Video>.from(
                json["videos"].map(
                  (x) {
                    Video video = Video.fromJson(x);

                    return video;
                  },
                ),
              ),
      );
}
