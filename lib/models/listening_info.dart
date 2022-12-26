class ListeningInfo {
  int bookID;
  int maxIndex;
  int index = 0;
  int position;
  double speed;
  bool isCompleted = false;

  ListeningInfo({
    required this.bookID,
    required this.maxIndex,
    required this.index,
    required this.position,
    required this.speed,
    required this.isCompleted,
  });

  factory ListeningInfo.fromJson(Map<String, dynamic> json) {
    return ListeningInfo(
      bookID: json["bookID"],
      maxIndex: json["maxIndex"],
      index: json["index"],
      position: json["position"],
      speed: json["speed"],
      isCompleted: json["isCompleted"] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookID": bookID,
      "maxIndex": maxIndex,
      "'index'": index,
      "position": position,
      "speed": speed,
      "isCompleted": isCompleted ? 1 : 0,
    };
  }

  ListeningInfo copyWith({
    required int bookID,
    int? maxIndex,
    int? index,
    bool? isCompleted,
    int? position,
    double? speed,
  }) {
    return ListeningInfo(
      bookID: bookID,
      maxIndex: maxIndex ?? this.maxIndex,
      index: index ?? this.index,
      position: position ?? this.position,
      speed: speed ?? this.speed,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'ListeningInfo{bookID: $bookID, maxIndex: $maxIndex, index: $index, position: $position, speed: $speed, isCompleted: $isCompleted}';
  }
}
