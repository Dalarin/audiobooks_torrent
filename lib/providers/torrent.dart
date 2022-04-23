// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartorrent_common/dartorrent_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torrent_model/torrent_model.dart';
import 'package:torrent_task/torrent_task.dart';

class TorrentClient {
  String torrentFile;
  String link;
  TorrentTask? task;
  TorrentClient({required this.torrentFile, required this.link});
  startDownloading() async {
    try {
      var directory = await initDirectory(link);
      var model = await Torrent.parse(torrentFile);
      task = TorrentTask.newTask(model, directory);
      task!.onTaskComplete(() {
        task!.stop();
        log("Task completed");
      });
      task!.onFileComplete((filepath) => log('$filepath completed!'));
      task!.start();
      findPublicTrackers().listen((event) => event.forEach(
          (element) => task!.startAnnounceUrl(element, model.infoHashBuffer)));
      model.nodes?.forEach((element) => task!.addDHTNode(element));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> initDirectory(String subPath) async {
    final directory = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/books/$subPath/');
    return (await directory.exists())
        ? directory.path
        : (await directory.create(recursive: true)).path;
  }
}
