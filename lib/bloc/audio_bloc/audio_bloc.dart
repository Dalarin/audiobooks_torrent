import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutracker_app/rutracker/models/book.dart';

import '../book_bloc/book_bloc.dart';

part 'audio_event.dart';

part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final BookBloc bookBloc;
  final Book book;
  AudioPlayer? audioPlayer;

  AudioBloc({required this.bookBloc, required this.book}) : super(AudioInitial()) {
    on<InitializeAudio>(_initializeAudio);
    on<SkipSeconds>(_skipSeconds);
  }

  void _skipSeconds(SkipSeconds event, emit) async {
    if (audioPlayer != null) {
      final int duration = audioPlayer!.duration!.inSeconds;
      // min for forward max for backward
      final int position = event.seconds > 0
          ? math.min(duration, audioPlayer!.position.inSeconds + event.seconds)
          : math.max(0, audioPlayer!.position.inSeconds + event.seconds);
      audioPlayer!.seek(Duration(seconds: position));
    }
  }

  @override
  Future<void> close() {
    if (audioPlayer != null) {
      bookBloc.add(
        UpdateBook(
          book: book.copyWith(
            listeningInfo: book.listeningInfo.copyWith(
              bookID: book.id,
              index: audioPlayer!.currentIndex,
              position: audioPlayer!.position.inSeconds,
              speed: audioPlayer!.speed,
            ),
          ),
          books: [],
        ),
      );
      audioPlayer?.stop();
    }
    return super.close();
  }

  void _initializeAudio(InitializeAudio event, emit) async {
    try {
      emit(AudioLoading());
      List<AudioSource>? mp3Files = await _initializePlaylist(book);
      if (mp3Files != null) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: mp3Files);
        audioPlayer = AudioPlayer();
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.speech());
        if (audioPlayer != null) {
          audioPlayer!.setAudioSource(
            playlist,
            initialIndex: book.listeningInfo.index,
            initialPosition: Duration(seconds: book.listeningInfo.position),
          );
          audioPlayer!.setSpeed(book.listeningInfo.speed);
          emit(AudioInitialized(audioPlayer: audioPlayer!));
        } else {
          emit(const AudioError(message: 'Ошибка инициализации аудиоплеера'));
        }
      } else {
        emit(const AudioError(message: 'Ошибка инициализации плейлиста'));
      }
    } on Exception catch (exception) {
      emit(AudioError(message: exception.toString()));
    }
  }

  Future<List<AudioSource>?> _initializePlaylist(Book book) async {
    List<AudioSource> playlist = [];
    try {
      final Audiotagger audioTagger = Audiotagger();
      final List<FileSystemEntity> musicFiles = await _getAudioFiles(book.id);
      book.listeningInfo.maxIndex = musicFiles.length;
      for (FileSystemEntity file in musicFiles) {
        Tag? tag = await audioTagger.readTags(path: file.path);
        int fileIndex = musicFiles.indexOf(file);
        AudioSource source = AudioSource.uri(
          Uri.parse(file.path),
          tag: MediaItem(
            id: fileIndex.toString(),
            title: tag?.title ?? 'Глава ${fileIndex + 1}',
            album: book.author,
            artUri: Uri.parse(book.image),
          ),
        );
        playlist.add(source);
      }
      return playlist;
    } on Exception catch (exception) {
      log('PLAYLIST INITIALIZE ERROR $exception');
      throw Exception('Ошибка инициализации плейлиста');
    }
  }

  Future<List<FileSystemEntity>> _getAudioFiles(int bookId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final myDir = Directory("${directory.path}/books/$bookId");
      final fileEntityList = myDir.listSync(recursive: true, followLinks: false).where((element) => element.path.endsWith('.mp3')).toList();
      fileEntityList.sort((a, b) => a.path.toString().compareTo(b.path.toString()));
      return fileEntityList;
    } on Exception catch (exception) {
      log('FETCHING AUDIO FILES ERROR $exception');
      throw Exception('Ошибка получения аудиофайлов');
    }
  }
}
