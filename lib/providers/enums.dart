import 'package:rutracker_app/models/book.dart';

enum Sort {
  standart,
  author,
  executor,
  title;

  factory Sort.fromValue(String value) {
    return values.firstWhere((element) => element.text == value);
  }
}

extension SortExtention on Sort {
  String get text {
    switch (this) {
      case Sort.standart:
        return 'По умолчанию';
      case Sort.author:
        return 'По автору';
      case Sort.executor:
        return 'По исполнителю';
      case Sort.title:
        return 'По названию';
    }
  }

  String get query {
    switch (this) {
      case Sort.standart:
        return '';
      case Sort.author:
        return 'ORDER BY author';
      case Sort.executor:
        return 'ORDER BY executor';
      case Sort.title:
        return 'ORDER BY title';
    }
  }
}

enum Filter {
  notDownloaded,
  completed,
  notListening;

  factory Filter.fromValue(String value) {
    return values.firstWhere((element) => element.text == value);
  }
}

extension FilterExtension on Filter {
  String get text {
    switch (this) {
      case Filter.notDownloaded:
        return 'Не скачанное';
      case Filter.completed:
        return 'Прослушанное';
      case Filter.notListening:
        return 'Не в процессе прослушивания';
    }
  }
}

extension ListFilterExtension on List<Filter> {
  List<Book> filter(List<Book> book) {
    if (!contains(Filter.completed)) {
      book.removeWhere((element) => element.listeningInfo.isCompleted);
    }
    if (!contains(Filter.notDownloaded)) {
      book.removeWhere((element) => !element.isDownloaded);
    }
    if (!contains(Filter.notListening)) {
      book.removeWhere((element) {
        return element.listeningInfo.position == 0 &&
            element.listeningInfo.index == 0;
      });
    }
    return book;
  }
}
