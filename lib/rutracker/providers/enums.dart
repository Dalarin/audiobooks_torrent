// ignore_for_file: camel_case_extensions

extension genres on Genres {
  Object get value {
    switch (this) {
      case Genres.radioAppearances:
        return 574;
      case Genres.biography:
        return 1036;
      case Genres.history:
        return 400;
      case Genres.foreignFantasy:
        return 2388;
      case Genres.russianFantasy:
        return 2387;
      case Genres.foreignLiterature:
        return 399;
      case Genres.foreignDetectives:
        return 499;
      case Genres.russianDetectives:
        return 2137;
      case Genres.educationalLiterature:
        return 403;
      case Genres.all:
        return '1036,1279,1350,2127,2137,2152,2165,2324,2325,2326,2327,2328,2342,2348,2387,2388,2389,399,400,401,402,403,467,490,499,530,574,661,695,716';
    }
  }

  String get name {
    switch (this) {
      case Genres.radioAppearances:
        return "Радио выступления";
      case Genres.biography:
        return "Биография";
      case Genres.history:
        return "История";
      case Genres.foreignFantasy:
        return "Зарубежная фантастика";
      case Genres.russianFantasy:
        return "Русская фантастика";
      case Genres.foreignLiterature:
        return "Зарубежная литература";
      case Genres.foreignDetectives:
        return "Зарубежные детективы";
      case Genres.russianDetectives:
        return "Русские детективы";
      case Genres.educationalLiterature:
        return "Образовательная литература";
      case Genres.all:
        return 'Все';
    }
  }
}

enum Genres {
  radioAppearances,
  biography,
  history,
  foreignFantasy,
  russianFantasy,
  foreignLiterature,
  foreignDetectives,
  russianDetectives,
  educationalLiterature,
  all
}

extension sort on SORT {
  String get text {
    switch (this) {
      case SORT.AUTHOR:
        return 'По автору';
      case SORT.STANDART:
        return 'По умолчанию';
      case SORT.TITLE:
        return 'По названию';
      case SORT.EXECUTOR:
        return 'По исполнителю';
    }
  }
}

enum SORT {
  STANDART,
  AUTHOR,
  TITLE,
  EXECUTOR
}


