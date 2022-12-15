part of 'torrent_bloc.dart';

abstract class TorrentState extends Equatable {
  const TorrentState();

  @override
  List<Object> get props => [];
}

class TorrentInitial extends TorrentState {}

class TorrentDownloading extends TorrentState {
  final Stream<double> torrentProgress;

  const TorrentDownloading({required this.torrentProgress});
}

class TorrentError extends TorrentState {
  final String message;

  const TorrentError({required this.message});
}

class TorrentDownloaded extends TorrentState {}
