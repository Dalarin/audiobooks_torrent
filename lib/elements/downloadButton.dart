// // ignore_for_file: must_be_immutable, file_names
//
// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:rutracker_app/pages/audio_page.dart';
// import 'package:rutracker_app/providers/database.dart';
// import 'package:rutracker_app/providers/query_response.dart';
// import 'package:rutracker_app/rutracker/models/book_page.dart';
// import 'package:rutracker_app/rutracker/rutracker.dart';
//
// class DownloadButton extends StatefulWidget {
//   Book book;
//   RutrackerApi api;
//
//   DownloadButton(this.api, {Key? key, required this.book}) : super(key: key);
//
//   @override
//   _DownloadButtonState createState() => _DownloadButtonState();
// }
//
// class _DownloadButtonState extends State<DownloadButton> {
//   TorrentClient? torrentClient;
//   bool paused = false;
//   bool canceled = false;
//   bool downloading = false;
//   bool isWrited = false;
//   Timer? timer;
//   double percent = 1.0;
//
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   void init() async {
//     List<Book> book = await DBHelper.instance.readBook(widget.book.id);
//     if (book.isNotEmpty) {
//       widget.book = book.first;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onLongPress: () =>
//           widget.book.isDownloaded ? deletingDialog(context) : null,
//       child: LinearPercentIndicator(
//         lineHeight: 55,
//         width: MediaQuery.of(context).size.width * .65,
//         animation: true,
//         center: !downloading
//             ? widget.book.isDownloaded
//                 ? listenAudioRow()
//                 : downloadRow()
//             : downloadingRow(),
//         animationDuration: 0,
//         percent: percent,
//         barRadius: const Radius.circular(20),
//         progressColor: Theme.of(context).toggleableActiveColor,
//       ),
//       onTap: () => !downloading
//           ? widget.book.isDownloaded
//               ? _openAudioplayer()
//               : _requestDownload(widget.book.id)
//           : null,
//     );
//   }
//
//   @override
//   void dispose() {
//     if (torrentClient != null && downloading) {
//       canceled = true;
//       torrentClient!.task!.stop();
//       timer!.cancel();
//       deleteBook();
//     }
//     super.dispose();
//   }
//
//   void _openAudioplayer() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Playlist(widget.book),
//       ),
//     );
//   }
//
//   Widget downloadingRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: () => downloading ? cancelInstallation() : null,
//           icon: const Icon(Icons.cancel_outlined),
//         ),
//         IconButton(
//             icon: paused
//                 ? const Icon(Icons.arrow_right)
//                 : const Icon(Icons.pause),
//             onPressed: () {
//               setState(() {
//                 if (paused) {
//                   torrentClient!.task!.resume();
//                 } else {
//                   torrentClient!.task!.pause();
//                 }
//                 paused = !paused;
//               });
//             }),
//         Text(
//           "${(percent * 100).toStringAsFixed(2)}%",
//           style: const TextStyle(
//             fontSize: 17,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget listenAudioRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: const [
//         Text('Слушать', style: TextStyle(fontSize: 17, color: Colors.white)),
//         SizedBox(width: 5),
//         Icon(Icons.headphones, color: Colors.white)
//       ],
//     );
//   }
//
//   Widget downloadRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: const [
//         Text('Скачать', style: TextStyle(fontSize: 20, color: Colors.white)),
//         SizedBox(width: 5),
//         Icon(
//           Icons.download,
//           size: 25.0,
//           color: Colors.white,
//         ),
//       ],
//     );
//   }
//
//   void _requestDownload(int link) async {
//     percent = 0.0; // обнуляем процент
//     downloading = true; // начинаем скачивание
//     setState(() => canceled = false);
//     var applicationDirectory = await getApplicationDocumentsDirectory();
//     final directory = Directory('${applicationDirectory.path}/torrents/');
//     var installation = widget.api.downloadFile(link, directory.path);
//     torrentClient = TorrentClient(
//       torrentFile: "${directory.path}$link.torrent",
//       link: link.toString(),
//     );
//     installation.whenComplete(() {
//       Future.delayed(
//         const Duration(seconds: 2),
//         () {
//           torrentClient!.startDownloading();
//           _periodicalPercentGetter();
//         },
//       );
//     });
//   }
//
//   void cancelInstallation() async {
//     if (torrentClient != null) {
//       var dir = await getApplicationDocumentsDirectory();
//       final directory = Directory('${dir.path}/books/${widget.book.id}/');
//       canceled = true;
//       torrentClient!.task!.stop();
//       timer!.cancel();
//       percent = 1.0;
//       directory.deleteSync(recursive: true);
//       setState(() => downloading = false);
//     }
//   }
//
//   void deleteBook() async {
//     final directory = (await getApplicationDocumentsDirectory()).path;
//     Directory bookDirectory = Directory('$directory/books/${widget.book.id}/');
//     bookDirectory.deleteSync(recursive: true);
//     setState(() => widget.book.isDownloaded = false);
//     DBHelper.instance.updateBook(widget.book);
//     Navigator.pop(context);
//   }
//
//   Widget deleatingDialogContent() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * .09,
//       child: Center(
//         child: RichText(
//           text: TextSpan(
//             text: 'Вы уверены, что хотите удалить книгу ',
//             style: const TextStyle(fontSize: 17),
//             children: [
//               TextSpan(
//                 text: '${widget.book.title}?',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void deletingDialog(BuildContext context) {
//     Widget confirmButton = TextButton(
//       onPressed: () => deleteBook(),
//       child: const Text("Да"),
//     );
//     AlertDialog alert = AlertDialog(
//       actions: [confirmButton],
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(32.0),
//         ),
//       ),
//       title: const Text(
//         "Удаление",
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       content: deleatingDialogContent(),
//     );
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   void _periodicalPercentGetter() async {
//     timer = Timer.periodic(const Duration(seconds: 1), (timers) async {
//       if (torrentClient!.task != null) {
//         // если торрент клиент инициализирован (зависает, нужно время)
//         setState(() => percent = torrentClient!.task!.progress);
//         torrentClient!.task!.onStop(() {
//           if (!canceled) {
//             // если процесс не отменен
//             timers.cancel(); // отключаем таймер
//             setState(() {
//               percent = 1.0;
//               if (!isWrited) {
//                 widget.book.isDownloaded = true;
//                 downloading = false;
//                 DBHelper.instance.updateBook(widget.book);
//                 isWrited = true;
//               }
//             });
//           }
//         });
//       } else {
//         log("Клиент не инициализирован");
//       }
//     });
//   }
//
// }
