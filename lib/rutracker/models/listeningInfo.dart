class listeningInfo {
  int bookID;
  int maxIndex;
  int index = 0;
  int position;
  double speed;
  bool isCompleted = false;

  listeningInfo(
      {required this.bookID,
      required this.maxIndex,
      required this.index,
      required this.position,
      required this.speed,
      required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'bookID': bookID,
      'maxIndex': maxIndex,
      'speed': speed,
      'position': position,
      'index': index,
      'isCompleted': isCompleted ? 1 : 0
    };
  }

  static listeningInfo generateNew(int idBook) {
    return listeningInfo(
        bookID: idBook,
        maxIndex: 0,
        index: 0,
        position: 0,
        speed: 1.0,
        isCompleted: false);
  }

  factory listeningInfo.fromMap(Map<String, dynamic> map) {
    return listeningInfo(
        bookID: map['bookID'],
        maxIndex: map['maxIndex'],
        index: map['index'],
        position: map['position'],
        speed: map['speed'],
        isCompleted: map['isCompleted'] == 1 ? true : false);
  }

  listeningInfo copyWith(
      {required int bookID,
      int? maxIndex,
      int? index,
      bool? isCompleted,
      int? position,
      double? speed}) {
    return listeningInfo(
        bookID: bookID,
        maxIndex: maxIndex ?? this.maxIndex,
        index: index ?? this.index,
        position: position ?? this.position,
        speed: speed ?? this.speed,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}
