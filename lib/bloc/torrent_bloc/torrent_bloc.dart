import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartorrent_common/dartorrent_common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torrent_model/torrent_model.dart';
import 'package:torrent_task/torrent_task.dart';
import 'package:equatable/equatable.dart';

import '../../rutracker/models/book.dart';
import '../../rutracker/rutracker.dart';

part 'torrent_event.dart';

part 'torrent_state.dart';

class TorrentBloc extends Bloc<TorrentEvent, TorrentState> {
  final RutrackerApi api;
  TorrentTask? _task;

  TorrentBloc({required this.api}) : super(TorrentInitial()) {
    on<StartTorrent>(_startTorrent);
    on<FinishTorrent>((event, emit) {
      emit(TorrentDownloaded());
    });
  }

  @override
  Future<void> close() {
    if (_task != null) {
      _task?.stop();
    }
    return super.close();
  }

  void _startTorrent(StartTorrent event, Emitter<TorrentState> emit) async {
    try {
      var directory = await getApplicationDocumentsDirectory(); // Получаем директорию приложения
      var torrentFile = Directory('${directory.path}/torrents');
      await api.downloadFile(event.book.id, torrentFile.path).then((File file) async {
          var bookDirectory = await _initDirectory(directory, event.book.id.toString()); // Инициализируем директорию аудиокниги
          var model = await Torrent.parse(file.path);
          _task = TorrentTask.newTask(model, bookDirectory);
          var torrentStream = Stream.periodic(const Duration(seconds: 2), (int count) => _task?.progress ?? 0.0);
          _task?.start();
          emit(TorrentDownloading(torrentProgress: torrentStream));
          findPublicTrackers().listen((event) {
            for (var evt in event) {
              _task?.startAnnounceUrl(evt, model.infoHashBuffer);
            }
          });
          for (var element in model.nodes) {
            _task?.addDHTNode(element);
          }
        },
      );
      _task?.onTaskComplete(() {
        _task?.stop();
        add(FinishTorrent());
      });
    } on Exception catch (exception) {
      emit(TorrentError(message: exception.toString()));
    }
  }

  Future<String> _initDirectory(Directory path, String subPath) async {
    var directory = Directory('${path.path}/books/$subPath/');
    if (await directory.exists()) {
      return directory.path;
    } else {
      return (await directory.create(recursive: true)).path;
    }
  }
}
