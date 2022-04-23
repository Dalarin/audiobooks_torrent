// ignore_for_file: camel_case_extensions

extension genres on Genres {
  int get value {
    switch (this) {
      case Genres.radioPerfomances:
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
    }
  }

  String get name {
    switch (this) {
      case Genres.radioPerfomances:
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
    }
  }
}

enum Genres {
  radioPerfomances,
  biography,
  history,
  foreignFantasy,
  russianFantasy,
  foreignLiterature,
  foreignDetectives,
  russianDetectives,
  educationalLiterature,
}
