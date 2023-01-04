
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
  downloaded,
  completed,
  listening;

  factory Filter.fromValue(String value) {
    return values.firstWhere((element) => element.text == value);
  }
}

extension FilterExtension on Filter {
  String get text {
    switch (this) {
      case Filter.downloaded:
        return 'Скачанное';
      case Filter.completed:
        return 'Прослушанное';
      case Filter.listening:
        return 'В процессе прослушивания';
    }
  }
}
