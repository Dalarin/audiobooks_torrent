// ignore_for_file: constant_identifier_names

import 'dart:convert';

const String book_tableName = "Books";

class BookFields {
  static final List<String> values = [
    id,
    title,
    releaseYear,
    author,
    genre,
    executor,
    bitrate,
    image,
    time,
    size,
    series,
    description,
    bookNumber,
    isFavorited,
    isDownloaded,
    listeningInfo
  ];
  static const String id = 'id';
  static const String title = 'title';
  static const String releaseYear = 'releaseYear';
  static const String author = 'author';
  static const String genre = 'genre';
  static const String executor = 'executor';
  static const String bitrate = 'bitrate';
  static const String image = 'image';
  static const String time = 'time';
  static const String size = 'size';
  static const String series = 'series';
  static const String description = 'description';
  static const String bookNumber = 'bookNumber';
  static const String isFavorited = 'isFavorited';
  static const String isDownloaded = 'isDownloaded';
  static const String listeningInfo = 'listeningInfo';
}

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
  bool isFavorited = false;
  bool isDownloaded = false;
  dynamic
      listeningInfo; // { "index": 0, "maxIndex": 0, "position": 0, "speed": 1} (encode to save map) // (decode to receive map)
  Book(
      {required this.id,
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
      required this.isFavorited,
      required this.isDownloaded,
      required this.listeningInfo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'releaseYear': releaseYear,
      'author': author,
      'genre': genre,
      'executor': executor,
      'bitrate': bitrate,
      'image': image,
      'time': time,
      'size': size,
      'series': series,
      'description': description,
      'bookNumber': bookNumber,
      'isFavorited': isFavorited ? 1 : 0,
      'isDownloaded': isDownloaded ? 1 : 0,
      'listeningInfo': json.encode(listeningInfo),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        id: map['id']?.toInt() ?? 0,
        title: map['title'] ?? '',
        releaseYear: map['releaseYear'] ?? '',
        author: map['author'] ?? '',
        genre: map['genre'] ?? '',
        executor: map['executor'] ?? '',
        bitrate: map['bitrate'] ?? '',
        image: map['image'] ?? '',
        time: map['time'] ?? '',
        size: map['size'] ?? '',
        series: map['series'] ?? '',
        description: map['description'] ?? '',
        bookNumber: map['bookNumber'] ?? '',
        isFavorited: map['isFavorited'] == 1 ? true : false,
        isDownloaded: map['isDownloaded'] == 1 ? true : false,
        listeningInfo: json.decode(map['listeningInfo']));
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
    bool? isFavorited,
    bool? isDownloaded,
    dynamic listeningInfo,
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
      isFavorited: isFavorited ?? this.isFavorited,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      listeningInfo: listeningInfo ?? this.listeningInfo,
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, releaseYear: $releaseYear, author: $author, genre: $genre, executor: $executor, bitrate: $bitrate, image: $image, time: $time, size: $size, series: $series, description: $description, bookNumber: $bookNumber, isFavorited: $isFavorited, isDownloaded: $isDownloaded, listeningInfo: $listeningInfo)';
  }
}
