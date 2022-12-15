part of 'torrent_bloc.dart';

abstract class TorrentEvent extends Equatable {
  const TorrentEvent();

  @override
  List<Object> get props => [];
}

class StartTorrent extends TorrentEvent {
  final Book book;

  const StartTorrent({required this.book});
}

class PauseTorrent extends TorrentEvent {}

class FinishTorrent extends TorrentEvent {}

class CancelTorrent extends TorrentEvent {

}
