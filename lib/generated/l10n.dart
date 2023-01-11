// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Audiobooks - Torrent`
  String get title {
    return Intl.message(
      'Audiobooks - Torrent',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Recently listened`
  String get recentlyListened {
    return Intl.message(
      'Recently listened',
      name: 'recentlyListened',
      desc: '',
      args: [],
    );
  }

  /// `There will be books in the listening process here`
  String get emptyListeningList {
    return Intl.message(
      'There will be books in the listening process here',
      name: 'emptyListeningList',
      desc: '',
      args: [],
    );
  }

  /// `Here will be your favorite books`
  String get emptyFavoriteList {
    return Intl.message(
      'Here will be your favorite books',
      name: 'emptyFavoriteList',
      desc: '',
      args: [],
    );
  }

  /// `Enter the book to search for..`
  String get searchHint {
    return Intl.message(
      'Enter the book to search for..',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Nothing was found for your query`
  String get searchNothingFounded {
    return Intl.message(
      'Nothing was found for your query',
      name: 'searchNothingFounded',
      desc: '',
      args: [],
    );
  }

  /// `Lists`
  String get lists {
    return Intl.message(
      'Lists',
      name: 'lists',
      desc: '',
      args: [],
    );
  }

  /// `Sorting`
  String get sort {
    return Intl.message(
      'Sorting',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `There are no created lists`
  String get emptyListList {
    return Intl.message(
      'There are no created lists',
      name: 'emptyListList',
      desc: '',
      args: [],
    );
  }

  /// `Create a new list`
  String get createList {
    return Intl.message(
      'Create a new list',
      name: 'createList',
      desc: '',
      args: [],
    );
  }

  /// `Authorization`
  String get auth {
    return Intl.message(
      'Authorization',
      name: 'auth',
      desc: '',
      args: [],
    );
  }

  /// `The button to go to the application without authorization. It is recommended to click after the input form appears`
  String get authTooltip {
    return Intl.message(
      'The button to go to the application without authorization. It is recommended to click after the input form appears',
      name: 'authTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Changing the list`
  String get changeList {
    return Intl.message(
      'Changing the list',
      name: 'changeList',
      desc: '',
      args: [],
    );
  }

  /// `List Title`
  String get listTitle {
    return Intl.message(
      'List Title',
      name: 'listTitle',
      desc: '',
      args: [],
    );
  }

  /// `List Description`
  String get listDescription {
    return Intl.message(
      'List Description',
      name: 'listDescription',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Delete list`
  String get deleteList {
    return Intl.message(
      'Delete list',
      name: 'deleteList',
      desc: '',
      args: [],
    );
  }

  /// `Deleting a list`
  String get deletingList {
    return Intl.message(
      'Deleting a list',
      name: 'deletingList',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the list `
  String get deleteApproval {
    return Intl.message(
      'Are you sure you want to delete the list ',
      name: 'deleteApproval',
      desc: '',
      args: [],
    );
  }

  /// `Here will be your books added to this list`
  String get emptyBooksInList {
    return Intl.message(
      'Here will be your books added to this list',
      name: 'emptyBooksInList',
      desc: '',
      args: [],
    );
  }

  /// `Action Menu`
  String get actionMenu {
    return Intl.message(
      'Action Menu',
      name: 'actionMenu',
      desc: '',
      args: [],
    );
  }

  /// `Delete from Favorites`
  String get deleteFromFavorites {
    return Intl.message(
      'Delete from Favorites',
      name: 'deleteFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Mark as listened`
  String get markListened {
    return Intl.message(
      'Mark as listened',
      name: 'markListened',
      desc: '',
      args: [],
    );
  }

  /// `Mark as unlistened`
  String get markUnlistened {
    return Intl.message(
      'Mark as unlistened',
      name: 'markUnlistened',
      desc: '',
      args: [],
    );
  }

  /// `Download the book`
  String get downloadBook {
    return Intl.message(
      'Download the book',
      name: 'downloadBook',
      desc: '',
      args: [],
    );
  }

  /// `Selecting lists`
  String get listSelection {
    return Intl.message(
      'Selecting lists',
      name: 'listSelection',
      desc: '',
      args: [],
    );
  }

  /// `Choosing the primary color`
  String get colorSelecting {
    return Intl.message(
      'Choosing the primary color',
      name: 'colorSelecting',
      desc: '',
      args: [],
    );
  }

  /// `Setting up a proxy`
  String get proxySettings {
    return Intl.message(
      'Setting up a proxy',
      name: 'proxySettings',
      desc: '',
      args: [],
    );
  }

  /// `The Username and Password fields are optional.The settings will be applied after the application is restarted`
  String get proxySettingsTooltip {
    return Intl.message(
      'The Username and Password fields are optional.The settings will be applied after the application is restarted',
      name: 'proxySettingsTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Host (ip address)`
  String get ip {
    return Intl.message(
      'Host (ip address)',
      name: 'ip',
      desc: '',
      args: [],
    );
  }

  /// `Port`
  String get port {
    return Intl.message(
      'Port',
      name: 'port',
      desc: '',
      args: [],
    );
  }

  /// `Setting up a primary color`
  String get colorSettings {
    return Intl.message(
      'Setting up a primary color',
      name: 'colorSettings',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get darkTheme {
    return Intl.message(
      'Dark theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Load new`
  String get loadNew {
    return Intl.message(
      'Load new',
      name: 'loadNew',
      desc: '',
      args: [],
    );
  }

  /// `There are no comments`
  String get emptyComments {
    return Intl.message(
      'There are no comments',
      name: 'emptyComments',
      desc: '',
      args: [],
    );
  }

  /// `Editing an audiobook is unlocked when you download it or add it to favorites`
  String get bookSettingsTooltip {
    return Intl.message(
      'Editing an audiobook is unlocked when you download it or add it to favorites',
      name: 'bookSettingsTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Book Settings`
  String get bookSettings {
    return Intl.message(
      'Book Settings',
      name: 'bookSettings',
      desc: '',
      args: [],
    );
  }

  /// `Genre`
  String get genre {
    return Intl.message(
      'Genre',
      name: 'genre',
      desc: '',
      args: [],
    );
  }

  /// `Executor`
  String get executor {
    return Intl.message(
      'Executor',
      name: 'executor',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message(
      'Audio',
      name: 'audio',
      desc: '',
      args: [],
    );
  }

  /// `Detailed information about the book`
  String get detailedInformation {
    return Intl.message(
      'Detailed information about the book',
      name: 'detailedInformation',
      desc: '',
      args: [],
    );
  }

  /// `The year of the book 's release: {releaseYear}`
  String releaseYear(Object releaseYear) {
    return Intl.message(
      'The year of the book \'s release: $releaseYear',
      name: 'releaseYear',
      desc: '',
      args: [releaseYear],
    );
  }

  /// `Series: {series}`
  String series(Object series) {
    return Intl.message(
      'Series: $series',
      name: 'series',
      desc: '',
      args: [series],
    );
  }

  /// `Book number: {bookNumber}`
  String bookNumber(Object bookNumber) {
    return Intl.message(
      'Book number: $bookNumber',
      name: 'bookNumber',
      desc: '',
      args: [bookNumber],
    );
  }

  /// `Bitrate: {bitrate}`
  String bitrate(Object bitrate) {
    return Intl.message(
      'Bitrate: $bitrate',
      name: 'bitrate',
      desc: '',
      args: [bitrate],
    );
  }

  /// `Book Size: {size}`
  String bookSize(Object size) {
    return Intl.message(
      'Book Size: $size',
      name: 'bookSize',
      desc: '',
      args: [size],
    );
  }

  /// `Book Title`
  String get bookTitle {
    return Intl.message(
      'Book Title',
      name: 'bookTitle',
      desc: '',
      args: [],
    );
  }

  /// `Link to the image`
  String get bookLinkImage {
    return Intl.message(
      'Link to the image',
      name: 'bookLinkImage',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get retry {
    return Intl.message(
      'Try again',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get speed {
    return Intl.message(
      'Speed',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `Chapters`
  String get chapters {
    return Intl.message(
      'Chapters',
      name: 'chapters',
      desc: '',
      args: [],
    );
  }

  /// `Timer`
  String get timer {
    return Intl.message(
      'Timer',
      name: 'timer',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get bookMarks {
    return Intl.message(
      'Bookmarks',
      name: 'bookMarks',
      desc: '',
      args: [],
    );
  }

  /// `Speed adjustment`
  String get speedAdjustment {
    return Intl.message(
      'Speed adjustment',
      name: 'speedAdjustment',
      desc: '',
      args: [],
    );
  }

  /// `Deleting a book`
  String get bookDeleting {
    return Intl.message(
      'Deleting a book',
      name: 'bookDeleting',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the book `
  String get confirmDeletingBook {
    return Intl.message(
      'Are you sure you want to delete the book ',
      name: 'confirmDeletingBook',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save the download progress? You can continue downloading later`
  String get exitDialogText {
    return Intl.message(
      'Do you want to save the download progress? You can continue downloading later',
      name: 'exitDialogText',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Аудиокниги - Торрент`
  String get appTitle {
    return Intl.message(
      'Аудиокниги - Торрент',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get listen {
    return Intl.message(
      'Listen',
      name: 'listen',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
