enum Categories {
  all,
  radioPerformances,
  biography,
  history,
  foreignFantasy,
  russianFantasy,
  novel,
  compilations,
  poetry,
  foreignLiterature,
  russianLiterature,
  modernNovels,
  childrenLiterature,
  foreignDetectives,
  russianDetectives,
  asianLiterature,
  medicine,
  scienceLiterature,
  business,
  different
}

extension CategoriesExt on Categories {
  String get text {
    switch (this) {
      case Categories.all:
        return 'Все';
      case Categories.radioPerformances:
        return 'Радиоспектакли';
      case Categories.biography:
        return 'Биография';
      case Categories.history:
        return 'История';
      case Categories.foreignFantasy:
        return 'Зарубежное фэнтези';
      case Categories.russianFantasy:
        return 'Российское фэнтези';
      case Categories.novel:
        return 'Романы';
      case Categories.compilations:
        return 'Сборники';
      case Categories.poetry:
        return 'Поэзия';
      case Categories.foreignLiterature:
        return 'Зарубежная литература';
      case Categories.russianLiterature:
        return 'Российская литература';
      case Categories.modernNovels:
        return 'Современные романы';
      case Categories.childrenLiterature:
        return 'Детская литература';
      case Categories.foreignDetectives:
        return 'Зарубежные детективы';
      case Categories.russianDetectives:
        return 'Российские детективы';
      case Categories.asianLiterature:
        return 'Азиатская литература';
      case Categories.medicine:
        return 'Медицина';
      case Categories.scienceLiterature:
        return 'Научная литература';
      case Categories.business:
        return 'Бизнес';
      case Categories.different:
        return 'Разное';
    }
  }

  String get code {
    switch (this) {
      case Categories.all:
        return '1036,1279,1350,2127,2137,2152,2165,2324,2325,2327,2328,2342,2348,2387,2388,2389,399,400,401,402,403,467,490,499,530,574,661,695,716';
      case Categories.radioPerformances:
        return '574';
      case Categories.biography:
        return '1036';
      case Categories.history:
        return '400';
      case Categories.foreignFantasy:
        return '2388';
      case Categories.russianFantasy:
        return '2387';
      case Categories.novel:
        return '661';
      case Categories.compilations:
        return '2348';
      case Categories.poetry:
        return '695';
      case Categories.foreignLiterature:
        return '399';
      case Categories.russianLiterature:
        return '402';
      case Categories.modernNovels:
        return '497';
      case Categories.childrenLiterature:
        return '490';
      case Categories.foreignDetectives:
        return '499';
      case Categories.russianDetectives:
        return '2137';
      case Categories.asianLiterature:
        return '2127';
      case Categories.medicine:
        return '1350';
      case Categories.scienceLiterature:
        return '403';
      case Categories.business:
        return '716';
      case Categories.different:
        return '2165';
    }
  }
}
