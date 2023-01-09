// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(bitrate) => "Bitrate: ${bitrate}";

  static String m1(bookNumber) => "Book number: ${bookNumber}";

  static String m2(size) => "Book Size: ${size}";

  static String m3(releaseYear) =>
      "The year of the book \'s release: ${releaseYear}";

  static String m4(series) => "Series: ${series}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actionMenu": MessageLookupByLibrary.simpleMessage("Action Menu"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("Аудиокниги - Торрент"),
        "audio": MessageLookupByLibrary.simpleMessage("Audio"),
        "auth": MessageLookupByLibrary.simpleMessage("Authorization"),
        "authTooltip": MessageLookupByLibrary.simpleMessage(
            "The button to go to the application without authorization. It is recommended to click after the input form appears"),
        "bitrate": m0,
        "bookDeleting": MessageLookupByLibrary.simpleMessage("Deleting a book"),
        "bookLinkImage":
            MessageLookupByLibrary.simpleMessage("Link to the image"),
        "bookMarks": MessageLookupByLibrary.simpleMessage("Bookmarks"),
        "bookNumber": m1,
        "bookSettings": MessageLookupByLibrary.simpleMessage("Book Settings"),
        "bookSettingsTooltip": MessageLookupByLibrary.simpleMessage(
            "Editing an audiobook is unlocked when you download it or add it to favorites"),
        "bookSize": m2,
        "bookTitle": MessageLookupByLibrary.simpleMessage("Book Title"),
        "changeList": MessageLookupByLibrary.simpleMessage("Changing the list"),
        "chapters": MessageLookupByLibrary.simpleMessage("Chapters"),
        "colorSelecting":
            MessageLookupByLibrary.simpleMessage("Choosing the primary color"),
        "colorSettings":
            MessageLookupByLibrary.simpleMessage("Setting up a primary color"),
        "comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "comments": MessageLookupByLibrary.simpleMessage("Comments"),
        "confirmDeletingBook": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete the book "),
        "createList": MessageLookupByLibrary.simpleMessage("Create a new list"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Dark theme"),
        "deleteApproval": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete the list "),
        "deleteFromFavorites":
            MessageLookupByLibrary.simpleMessage("Delete from Favorites"),
        "deleteList": MessageLookupByLibrary.simpleMessage("Delete list"),
        "deletingList": MessageLookupByLibrary.simpleMessage("Deleting a list"),
        "detailedInformation": MessageLookupByLibrary.simpleMessage(
            "Detailed information about the book"),
        "downloadBook":
            MessageLookupByLibrary.simpleMessage("Download the book"),
        "emptyBooksInList": MessageLookupByLibrary.simpleMessage(
            "Here will be your books added to this list"),
        "emptyComments":
            MessageLookupByLibrary.simpleMessage("There are no comments"),
        "emptyFavoriteList": MessageLookupByLibrary.simpleMessage(
            "Here will be your favorite books"),
        "emptyListList":
            MessageLookupByLibrary.simpleMessage("There are no created lists"),
        "emptyListeningList": MessageLookupByLibrary.simpleMessage(
            "There will be books in the listening process here"),
        "enter": MessageLookupByLibrary.simpleMessage("Enter"),
        "executor": MessageLookupByLibrary.simpleMessage("Executor"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "exitDialogText": MessageLookupByLibrary.simpleMessage(
            "Do you want to save the download progress? You can continue downloading later"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "genre": MessageLookupByLibrary.simpleMessage("Genre"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "ip": MessageLookupByLibrary.simpleMessage("Host (ip address)"),
        "listDescription":
            MessageLookupByLibrary.simpleMessage("List Description"),
        "listSelection":
            MessageLookupByLibrary.simpleMessage("Selecting lists"),
        "listTitle": MessageLookupByLibrary.simpleMessage("List Title"),
        "lists": MessageLookupByLibrary.simpleMessage("Lists"),
        "loadNew": MessageLookupByLibrary.simpleMessage("Load new"),
        "markListened":
            MessageLookupByLibrary.simpleMessage("Mark as listened"),
        "markUnlistened":
            MessageLookupByLibrary.simpleMessage("Mark as unlistened"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "port": MessageLookupByLibrary.simpleMessage("Port"),
        "proxySettings":
            MessageLookupByLibrary.simpleMessage("Setting up a proxy"),
        "proxySettingsTooltip": MessageLookupByLibrary.simpleMessage(
            "The Username and Password fields are optional.The settings will be applied after the application is restarted"),
        "recentlyListened":
            MessageLookupByLibrary.simpleMessage("Recently listened"),
        "releaseYear": m3,
        "retry": MessageLookupByLibrary.simpleMessage("Try again"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "searchHint": MessageLookupByLibrary.simpleMessage(
            "Enter the book to search for.."),
        "searchNothingFounded": MessageLookupByLibrary.simpleMessage(
            "Nothing was found for your query"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "series": m4,
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "sort": MessageLookupByLibrary.simpleMessage("Sorting"),
        "speed": MessageLookupByLibrary.simpleMessage("Speed"),
        "speedAdjustment":
            MessageLookupByLibrary.simpleMessage("Speed adjustment"),
        "timer": MessageLookupByLibrary.simpleMessage("Timer"),
        "title": MessageLookupByLibrary.simpleMessage("Audiobooks - Torrent"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
