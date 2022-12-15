import 'package:rutracker_app/rutracker/models/listening_info.dart';

class Book {
  int id;
  String title;
  String releaseYear;
  String author;
  String genre;
  String executor;
  String bitrate;
  String image;
  String time;
  String size;
  String series;
  String description;
  String bookNumber;
  bool isFavorite = false;
  bool isDownloaded = false;
  ListeningInfo listeningInfo;

  Book({
    required this.id,
    required this.title,
    required this.releaseYear,
    required this.author,
    required this.genre,
    required this.executor,
    required this.bitrate,
    required this.image,
    required this.time,
    required this.size,
    required this.series,
    required this.description,
    required this.bookNumber,
    required this.isFavorite,
    required this.isDownloaded,
    required this.listeningInfo,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      title: json["title"],
      releaseYear: json["release_year"],
      author: json["author"],
      genre: json["genre"],
      executor: json["executor"],
      bitrate: json["bitrate"],
      image: json["image"],
      time: json["time"],
      size: json["size"],
      series: json["series"],
      description: json["description"],
      bookNumber: json["book_number"],
      isFavorite: json["isFavorite"] == 1,
      isDownloaded: json["isDownloaded"] == 1,
      listeningInfo: ListeningInfo.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "release_year": releaseYear,
      "author": author,
      "genre": genre,
      "executor": executor,
      "bitrate": bitrate,
      "image": image,
      "time": time,
      "size": size,
      "series": series,
      "description": description,
      "book_number": bookNumber,
      "isFavorite": isFavorite ? 1 : 0,
      "isDownloaded": isDownloaded ? 1 : 0,
      "listeningInfo": listeningInfo.toJson(),
    };
  }

  Book copyWith({
    int? id,
    String? title,
    String? releaseYear,
    String? author,
    String? genre,
    String? executor,
    String? bitrate,
    String? image,
    String? time,
    String? size,
    String? series,
    String? description,
    String? bookNumber,
    bool? isFavorite,
    bool? isDownloaded,
    ListeningInfo? listeningInfo,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      releaseYear: releaseYear ?? this.releaseYear,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      executor: executor ?? this.executor,
      bitrate: bitrate ?? this.bitrate,
      image: image ?? this.image,
      time: time ?? this.time,
      size: size ?? this.size,
      series: series ?? this.series,
      description: description ?? this.description,
      bookNumber: bookNumber ?? this.bookNumber,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      listeningInfo: listeningInfo ?? this.listeningInfo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Book(id: $id, title: $title, releaseYear: $releaseYear, author: $author, genre: $genre, executor: $executor, bitrate: $bitrate, image: $image, time: $time, size: $size, series: $series, bookNumber: $bookNumber, isFavorited: $isFavorite, isDownloaded: $isDownloaded, listeningInfo: $listeningInfo)';
  }
}
