import 'dart:core';

import 'package:rutracker_app/models/listening_info.dart';

class Book {
  int id;
  String title;
  String image;
  String author;
  String executor;
  String genre;
  String audio;
  String description;
  String releaseYear;
  String series;
  String bookNumber;
  String bitrate;
  String size;
  ListeningInfo listeningInfo;
  bool isFavorite;
  bool isDownloaded;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Book({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.executor,
    required this.genre,
    required this.audio,
    required this.description,
    required this.releaseYear,
    required this.series,
    required this.bookNumber,
    required this.bitrate,
    required this.size,
    required this.listeningInfo,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'author': author,
      'executor': executor,
      'genre': genre,
      'time': audio,
      'description': description,
      'release_year': releaseYear,
      'series': series,
      'book_number': bookNumber,
      'bitrate': bitrate,
      'size': size,
      'isFavorite': isFavorite ? 1 : 0,
      'isDownloaded': isDownloaded ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'] as String,
      image: map['image'] as String,
      author: map['author'] as String,
      executor: map['executor'] as String,
      genre: map['genre'] as String,
      audio: map['audio'] as String,
      description: map['description'] as String,
      releaseYear: map['optionalInfo']['releaseYear'],
      series: map['optionalInfo']['series'] as String,
      bookNumber: map['optionalInfo']['bookNumber'] as String,
      bitrate: map['optionalInfo']['bitrate'] as String,
      size: map['size'] as String,
      listeningInfo: ListeningInfo.fromJson(map),
      isFavorite: map['isFavorite'] == 1,
      isDownloaded: map['isDownloaded'] == 1,
    );
  }

  factory Book.fromMapDb(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'] as String,
      image: map['image'] as String,
      author: map['author'] as String,
      executor: map['executor'] as String,
      genre: map['genre'] as String,
      audio: map['time'] as String,
      description: map['description'] as String,
      releaseYear: map['release_year'],
      series: map['series'] as String,
      bookNumber: map['book_number'] as String,
      bitrate: map['bitrate'] as String,
      size: map['size'] as String,
      listeningInfo: ListeningInfo.fromJson(map),
      isFavorite: map['isFavorite'] == 1,
      isDownloaded: map['isDownloaded'] == 1,
    );
  }

  Book copyWith({
    int? id,
    String? title,
    String? image,
    String? author,
    String? executor,
    String? genre,
    String? audio,
    String? description,
    String? releaseYear,
    String? series,
    String? bookNumber,
    String? bitrate,
    String? size,
    bool? isFavorite,
    bool? isDownloaded,
    ListeningInfo? listeningInfo,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      author: author ?? this.author,
      executor: executor ?? this.executor,
      genre: genre ?? this.genre,
      audio: audio ?? this.audio,
      description: description ?? this.description,
      releaseYear: releaseYear ?? this.releaseYear,
      series: series ?? this.series,
      bookNumber: bookNumber ?? this.bookNumber,
      bitrate: bitrate ?? this.bitrate,
      size: size ?? this.size,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      listeningInfo: listeningInfo ?? this.listeningInfo,
    );
  }
}

