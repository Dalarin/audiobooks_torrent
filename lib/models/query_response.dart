class QueryResponse {
  String link;
  String forum;
  String author;
  String theme;
  String size;
  String date;

  QueryResponse({
    required this.link,
    required this.forum,
    required this.author,
    required this.theme,
    required this.size,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'link': link,
      'forum': forum,
      'author': author,
      'size': size,
      'theme': theme,
      'date': date,
    };
  }

  factory QueryResponse.fromMap(Map<String, dynamic> map) {
    return QueryResponse(
      link: map['link'] as String,
      forum: map['forum'] as String,
      author: map['author'] as String,
      theme: map['theme'],
      size: map['size'] as String,
      date: map['date'] as String,
    );
  }
}
