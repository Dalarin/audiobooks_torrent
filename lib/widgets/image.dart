import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rutracker_app/models/book.dart';

class CustomImage extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  final double borderRadius;

  const CustomImage({
    Key? key,
    required this.book,
    required this.width,
    required this.height,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      child: book.isDownloaded ? _cachedImage(book, width, height) : _networkImage(book, width, height),
    );
  }

  Widget _cachedImage(Book book, double width, double height) {
    return Image(
      image: CachedNetworkImageProvider(book.image),
      errorBuilder: (context, error, stackTrace) => _errorImage(width, height),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      filterQuality: FilterQuality.high,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget _networkImage(Book book, double width, double height) {
    return Image.network(
      book.image,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => _errorImage(width, height),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      height: height,
      width: width,
    );
  }

  Widget _errorImage(double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        width: width,
        height: width,
        child: Image.asset(
          'assets/cover.jpg',
          repeat: ImageRepeat.repeat,
        ),
      ),
    );
  }
}
