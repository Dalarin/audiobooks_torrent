
class QueryResponse {
  String forum;
  String theme;
  String size;
  String link;

  QueryResponse({
    required this.forum,
    required this.theme,
    required this.size,
    required this.link,
  });

  @override
  String toString() {
    return 'Forum $forum\nTheme $theme\nSize $size\nLink $link';
  }

  static Map<String, dynamic> toMap(QueryResponse book) {
    return {
      'forum': book.forum,
      'theme': book.theme,
      'size': book.size,
      'link': book.link,
    };
  }

  factory QueryResponse.fromMap(Map<String, dynamic> map) {
    return QueryResponse(
      forum: map['forum'] ?? '',
      theme: map['theme'] ?? '',
      size: map['size'] ?? '',
      link: map['link'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QueryResponse && other.link == link;
  }

  @override
  int get hashCode {
    return forum.hashCode ^ theme.hashCode ^ size.hashCode ^ link.hashCode;
  }
}
