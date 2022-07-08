// ignore_for_file: avoid_print, sized_box_for_whitespace, must_be_immutable, use_key_in_widget_constructors

import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math; // import this

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutracker_app/providers/database.dart';
import 'package:rutracker_app/rutracker/providers/cp1251.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audiotagger/audiotagger.dart';

import 'package:rutracker_app/providers/constants.dart';
import 'package:rutracker_app/rutracker/models/book.dart';

class Playlist extends StatefulWidget {
  Book book;

  Playlist(this.book, {Key? key}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final AudioPlayer _player = AudioPlayer();
  late ConcatenatingAudioSource _playlist;
  late double width;
  late double height;

  Future<List<AudioSource>> createPlaylist() async {
    List<AudioSource> playlist = [];
    int counter = -1;
    final tagger = Audiotagger();
    List<FileSystemEntity> folders = await getDir();
    folders.sort((a, b) => a.toString().compareTo(b.toString()));
    folders.forEach((element) async {
      if (element.path.endsWith('.mp3')) {
        counter++;
        Tag? tag = await tagger.readTags(path: element.path);
        String tagTitle = tag?.title ?? "Глава $counter";
        _playlist.add(
          AudioSource.uri(
            Uri.parse(element.path),
            tag: MediaItem(
              id: '$counter',
              album: widget.book.author,
              title: tagTitle,
              artUri: Uri.parse(widget.book.image),
            ),
          ),
        );
      }
    });
    widget.book.listeningInfo.maxIndex = counter;
    return playlist;
  }

  Future<List<FileSystemEntity>> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final myDir = Directory("${directory.path}/books/${widget.book.id}");
    return myDir.listSync(recursive: true, followLinks: false);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
    );
    _init();
  }

  Future<void> _init() async {
    var songs = await createPlaylist();
    _playlist = ConcatenatingAudioSource(children: [...songs]);
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    try {
      int initialIndex = widget.book.listeningInfo.index;
      int initialPosition = widget.book.listeningInfo.position;
      await _player.setAudioSource(_playlist,
          initialIndex: initialIndex,
          initialPosition: Duration(seconds: initialPosition));
      _player.setSpeed(widget.book.listeningInfo.speed);
    } catch (e, stackTrace) {
      print("Ошибка загрузки плейлиста: $e");
      print(stackTrace);
    }
  }

  @override
  void dispose() {
    widget.book.listeningInfo.index = _player.currentIndex!;
    widget.book.listeningInfo.position = _player.position.inSeconds;
    widget.book.listeningInfo.speed = _player.speed;
    DBHelper.instance.updateBook(widget.book);
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: column(),
      ),
    );
  }

  Widget description() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFF2F80ED).withOpacity(0.35),
            const Color(0xFFB2FFDA).withOpacity(0.35),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      width: width,
      height: height * .65,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.1),
            Container(
              width: width * 0.6,
              height: height * 0.32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: Image(
                  image: CachedNetworkImageProvider(widget.book.image),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.95),
              child: Text(
                widget.book.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: constants.fontFamily,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.book.author,
              style: TextStyle(
                fontFamily: constants.fontFamily,
              ),
            ),
            const SizedBox(height: 15),
            StreamBuilder(
              stream: _player.currentIndexStream,
              builder: (context, AsyncSnapshot snapshot) {
                int currentIndex = snapshot.data ?? 0;
                return Container(
                  constraints: BoxConstraints(maxWidth: width * 0.95),
                  child: Text(
                    _player.audioSource?.sequence[currentIndex].tag.title ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: constants.fontFamily,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget controlBar() {
    return Container(
      width: width,
      height: height * .25,
      child: Column(
        children: [
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  _player.seek(newPosition);
                },
              );
            },
          ),
          ControlButtons(widget.book, _player),
        ],
      ),
    );
  }

  Widget column() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        description(),
        controlBar(),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final Book book;

  const ControlButtons(this.book, this.player, {Key? key}) : super(key: key);

  void dialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      title: Text(
        "Главы",
        style: TextStyle(
            fontFamily: constants.fontFamily, fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: StreamBuilder<SequenceState?>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final sequence = state?.sequence ?? [];

              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
                itemCount: sequence.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    player.seek(Duration.zero, index: index);
                    Navigator.pop(context);
                  },
                  child: listViewItem(sequence[index], context),
                ),
              );
            },
          ),
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget listViewItem(IndexedAudioSource source, BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.95, maxHeight: 100),
        child: Text(source.tag.title,
            style: TextStyle(fontFamily: constants.fontFamily)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => dialog(context),
          icon: const Icon(Icons.library_music_outlined, color: Colors.grey),
        ),
        IconButton(
          onPressed: () {
            player.seek(
              Duration(
                seconds: player.position.inSeconds - 10 >= 0
                    ? player.position.inSeconds - 10
                    : 0,
              ),
            );
          },
          icon: Icon(
            Icons.replay_10_rounded,
            color: Theme.of(context).toggleableActiveColor,
          ),
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(Icons.double_arrow_rounded,
                  color: Theme.of(context).toggleableActiveColor),
            ),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_circle_fill_rounded),
                color: Theme.of(context).toggleableActiveColor,
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle_rounded),
                color: Theme.of(context).toggleableActiveColor,
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              book.listeningInfo.isCompleted = true;
              return IconButton(
                icon: const Icon(Icons.replay_circle_filled),
                color: Theme.of(context).toggleableActiveColor,
                iconSize: 64.0,
                onPressed: () {
                  player.seek(Duration.zero,
                      index: player.effectiveIndices!.first);
                  book.listeningInfo.isCompleted = false;
                },
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.double_arrow_rounded,
                color: Theme.of(context).toggleableActiveColor),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        IconButton(
          onPressed: () => player.seek(
            Duration(
              seconds:
                  player.position.inSeconds + 10 <= player.duration!.inSeconds
                      ? player.position.inSeconds + 10
                      : player.duration!.inSeconds,
            ),
          ),
          icon: Icon(Icons.forward_10_outlined,
              color: Theme.of(context).toggleableActiveColor),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Регулировка скорости",
                divisions: 10,
                min: 0.8,
                max: 2.0,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Theme.of(context).toggleableActiveColor,
            inactiveTrackColor:
                Theme.of(context).toggleableActiveColor.withOpacity(0.25),
          ),
          child: ExcludeSemantics(
            child: Slider(
              activeColor: Theme.of(context).toggleableActiveColor,
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            activeTrackColor: Theme.of(context).toggleableActiveColor,
            thumbColor:
                Theme.of(context).toggleableActiveColor.withOpacity(0.7),
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: constants.fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                thumbColor: Theme.of(context).toggleableActiveColor,
                activeColor: Theme.of(context).toggleableActiveColor,
                inactiveColor:
                    Theme.of(context).toggleableActiveColor.withOpacity(0.3),
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
