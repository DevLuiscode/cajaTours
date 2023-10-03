class Product {
  final String id;
  final String name;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final List<Img> imgs;
  final List<Video> videos;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imgs,
    required this.videos,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"].toString(),
      name: json["name"],
      description: json["description"],
      location: json["location"],
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      imgs: List<Img>.from(json["imgs"].map((x) => Img.fromJson(x))),
      videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "imgs": List<dynamic>.from(imgs.map((x) => x.toJson())),
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
      };

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return '''
  //   soy product
  //   imgs: $imgs,
  //   videos: $videos,
  // ''';
  // }
}

class Img {
  final int id;
  final int idDest;
  final String filePath;
  final String url;

  Img({
    required this.id,
    required this.idDest,
    required this.filePath,
    required this.url,
  });

  factory Img.fromJson(Map<String, dynamic> json) => Img(
        id: json["id"],
        idDest: json["idDest"],
        filePath: json["filePath"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idDest": idDest,
        "filePath": filePath,
        "url": url,
      };
}

class Video {
  final int id;
  final int idDest;
  final String filePath;
  final String url;

  Video({
    required this.id,
    required this.idDest,
    required this.filePath,
    required this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        idDest: json["idDest"],
        filePath: json["filePath"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idDest": idDest,
        "filePath": filePath,
        "url": url,
      };

  // @override
  // String toString() {
  //   return 'Video{id: $id, idDest: $idDest, filePath: $filePath, url: $url}';
  // }
}
