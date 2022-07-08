import 'dart:convert';

class Torrent {
  String forum;
  String theme;
  String size;
  String link;
  Torrent(
      {required this.forum,
      required this.theme,
      required this.size,
      required this.link});

  @override
  String toString() {
    return 'Forum $forum\nTheme $theme\nSize $size\nLink $link';
  }

  static Map<String, dynamic> toMap(Torrent book) {
    return {
      'forum': book.forum,
      'theme': book.theme,
      'size': book.size,
      'link': book.link,
    };
  }

  factory Torrent.fromMap(Map<String, dynamic> map) {
    return Torrent(
      forum: map['forum'] ?? '',
      theme: map['theme'] ?? '',
      size: map['size'] ?? '',
      link: map['link'] ?? '',
    );
  }

  static String encode(List<Torrent> torrents) =>
      json.encode(torrents.map((torrent) => Torrent.toMap(torrent)).toList());

  static List<Torrent> decode(String books) =>
      (json.decode(books) as List<dynamic>)
          .map<Torrent>((item) => Torrent.fromMap(item))
          .toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Torrent && other.link == link;
  }

  @override
  int get hashCode {
    return forum.hashCode ^ theme.hashCode ^ size.hashCode ^ link.hashCode;
  }
}
