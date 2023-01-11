import 'dart:async';
import 'dart:io';

import 'package:dartorrent_common/dartorrent_common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutracker_api/rutracker_api.dart';
import 'package:rutracker_app/models/book.dart';
import 'package:torrent_model/torrent_model.dart';
import 'package:torrent_task/torrent_task.dart';
import 'package:equatable/equatable.dart';

part 'torrent_event.dart';

part 'torrent_state.dart';

class TorrentBloc extends Bloc<TorrentEvent, TorrentState> {
  final RutrackerApi api;
  TorrentTask? _task;

  TorrentBloc({required this.api}) : super(TorrentInitial()) {
    on<StartTorrent>((event, emit) => _startTorrent(event, emit));
    on<CancelTorrent>((event, emit) => _cancelTorrent(event, emit));
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

  void _cancelTorrent(CancelTorrent event, emit) async {
    _task?.stop();
    var directory = await getApplicationDocumentsDirectory();
    bool directoryDeleted = await _deleteDirectory(directory, event.book.id);
    if (!directoryDeleted) {
      emit(const TorrentError(message: 'Ошибка удаления скачанных данных'));
    }
  }

  void _startTorrent(StartTorrent event, emit) async {
    try {
      var directory = await getApplicationDocumentsDirectory();
      directory = Directory('${directory.path}/torrents/${event.book.id}.torrent');
      final file = await api.downloadTorrentFile(link: event.book.id, pathDirectory: directory.path);
      final bookDirectory = await _initDirectory(directory, event.book.id.toString());
      final model = await Torrent.parse(file.path);
      final torrentStream = Stream.periodic(const Duration(seconds: 2), (_) {
        return _task?.progress ?? 0.0;
      });
      _task = TorrentTask.newTask(model, bookDirectory);
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
      _task?.onTaskComplete(() {
        _task?.stop();
        add(FinishTorrent());
      });
    } on Exception catch (exception) {
      emit(TorrentError(message: exception.toString()));
      emit(TorrentInitial());
    }
  }

  Future<bool> _deleteDirectory(Directory path, int subPath) async {
    var directory = Directory('${path.path}/books/$subPath/');
    if (await directory.exists()) {
      directory.delete(recursive: true);
      return true;
    } else {
      return false;
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
