import 'package:flutter/material.dart';


class FileIcon extends StatelessWidget {
  final String extension;
  final double size;

  const FileIcon({
    super.key,
    required this.extension,
    this.size = 48,
  });

  Color get _color {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFE74C3C);
      case 'doc':
      case 'docx':
        return const Color(0xFF2B579A);
      case 'xls':
      case 'xlsx':
        return const Color(0xFF27AE60);
      case 'ppt':
      case 'pptx':
        return const Color(0xFFD35400);
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'bmp':
      case 'webp':
      case 'heic':
        return const Color(0xFF8E44AD);
      case 'txt':
        return const Color(0xFF7F8C8D);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  IconData get _icon {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'bmp':
      case 'webp':
      case 'heic':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _icon,
        color: _color,
        size: size * 0.5,
      ),
    );
  }
}
