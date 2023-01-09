// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(bitrate) => "Битрейт: ${bitrate}";

  static String m1(bookNumber) => "Номер книги: ${bookNumber}";

  static String m2(size) => "Размер книги: ${size}";

  static String m3(releaseYear) => "Год выпуска книги: ${releaseYear}";

  static String m4(series) => "Серия: ${series}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actionMenu": MessageLookupByLibrary.simpleMessage("Меню действий"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("Аудиокниги - Торрент"),
        "audio": MessageLookupByLibrary.simpleMessage("Аудио"),
        "auth": MessageLookupByLibrary.simpleMessage("Авторизация"),
        "authTooltip": MessageLookupByLibrary.simpleMessage(
            "Кнопка перехода в приложение без авторизации. Рекомендуется нажимать после появления формы ввода"),
        "bitrate": m0,
        "bookDeleting": MessageLookupByLibrary.simpleMessage("Удаление книги"),
        "bookLinkImage":
            MessageLookupByLibrary.simpleMessage("Ссылка на изображение"),
        "bookMarks": MessageLookupByLibrary.simpleMessage("Закладки"),
        "bookNumber": m1,
        "bookSettings": MessageLookupByLibrary.simpleMessage("Настройки книги"),
        "bookSettingsTooltip": MessageLookupByLibrary.simpleMessage(
            "Редактирование аудиокниги разблокируется при ее скачивании или добавлении в избранное"),
        "bookSize": m2,
        "bookTitle": MessageLookupByLibrary.simpleMessage("Название книги"),
        "changeList": MessageLookupByLibrary.simpleMessage("Изменение списка"),
        "chapters": MessageLookupByLibrary.simpleMessage("Главы"),
        "colorSelecting":
            MessageLookupByLibrary.simpleMessage("Выбор основного цвета"),
        "colorSettings":
            MessageLookupByLibrary.simpleMessage("Настройка основного цвета"),
        "comment": MessageLookupByLibrary.simpleMessage("Комментарий"),
        "comments": MessageLookupByLibrary.simpleMessage("Комментарии"),
        "confirmDeletingBook": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить книгу "),
        "createList":
            MessageLookupByLibrary.simpleMessage("Создать новый список"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Темная тема"),
        "deleteApproval": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить список "),
        "deleteFromFavorites":
            MessageLookupByLibrary.simpleMessage("Удалить из избранного"),
        "deleteList": MessageLookupByLibrary.simpleMessage("Удалить список"),
        "deletingList": MessageLookupByLibrary.simpleMessage("Удаление списка"),
        "detailedInformation": MessageLookupByLibrary.simpleMessage(
            "Подробная информация о книге"),
        "downloadBook": MessageLookupByLibrary.simpleMessage("Скачать книгу"),
        "emptyBooksInList": MessageLookupByLibrary.simpleMessage(
            "Здесь будут находиться ваши книги, добавленные в данный список"),
        "emptyComments":
            MessageLookupByLibrary.simpleMessage("Комментарии отсутствуют"),
        "emptyFavoriteList": MessageLookupByLibrary.simpleMessage(
            "Здесь будут находиться ваши избранные книги"),
        "emptyListList": MessageLookupByLibrary.simpleMessage(
            "Отсутствуют созданные списки"),
        "emptyListeningList": MessageLookupByLibrary.simpleMessage(
            "Здесь будут находиться книги в процессе прослушивания"),
        "enter": MessageLookupByLibrary.simpleMessage("Войти"),
        "executor": MessageLookupByLibrary.simpleMessage("Исполнитель"),
        "exit": MessageLookupByLibrary.simpleMessage("Выход"),
        "exitDialogText": MessageLookupByLibrary.simpleMessage(
            "Вы хотите сохранить прогресс скачивания? Вы сможете продолжить скачивание позже"),
        "favorite": MessageLookupByLibrary.simpleMessage("Избранное"),
        "filter": MessageLookupByLibrary.simpleMessage("Фильтр"),
        "genre": MessageLookupByLibrary.simpleMessage("Жанр"),
        "home": MessageLookupByLibrary.simpleMessage("Дом"),
        "ip": MessageLookupByLibrary.simpleMessage("Хост (ip-адрес)"),
        "listDescription":
            MessageLookupByLibrary.simpleMessage("Описание списка"),
        "listSelection": MessageLookupByLibrary.simpleMessage("Выбор списков"),
        "listTitle": MessageLookupByLibrary.simpleMessage("Название списка"),
        "lists": MessageLookupByLibrary.simpleMessage("Списки"),
        "loadNew": MessageLookupByLibrary.simpleMessage("Загрузить новые"),
        "markListened":
            MessageLookupByLibrary.simpleMessage("Отметить прослушанным"),
        "markUnlistened":
            MessageLookupByLibrary.simpleMessage("Отметить непрослушанным"),
        "no": MessageLookupByLibrary.simpleMessage("Нет"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "port": MessageLookupByLibrary.simpleMessage("Порт"),
        "proxySettings":
            MessageLookupByLibrary.simpleMessage("Настройка прокси"),
        "proxySettingsTooltip": MessageLookupByLibrary.simpleMessage(
            "Поля Имя пользователя и Пароль являются опциональными.Настройки будут применены после перезагрузки приложения"),
        "recentlyListened":
            MessageLookupByLibrary.simpleMessage("Недавно прослушанное"),
        "releaseYear": m3,
        "retry": MessageLookupByLibrary.simpleMessage("Повторить попытку"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "search": MessageLookupByLibrary.simpleMessage("Поиск"),
        "searchHint":
            MessageLookupByLibrary.simpleMessage("Введите книгу для поиска.."),
        "searchNothingFounded": MessageLookupByLibrary.simpleMessage(
            "Ничего не найдено по Вашему запросу"),
        "send": MessageLookupByLibrary.simpleMessage("Отправить"),
        "series": m4,
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
        "speed": MessageLookupByLibrary.simpleMessage("Скорость"),
        "speedAdjustment":
            MessageLookupByLibrary.simpleMessage("Регулировка скорости"),
        "timer": MessageLookupByLibrary.simpleMessage("Таймер"),
        "title": MessageLookupByLibrary.simpleMessage("Аудиокниги - Торрент"),
        "username": MessageLookupByLibrary.simpleMessage("Логин"),
        "yes": MessageLookupByLibrary.simpleMessage("Да")
      };
}
