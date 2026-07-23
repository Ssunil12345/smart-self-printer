import 'package:equatable/equatable.dart';

class PrintOptionsModel extends Equatable {
  final bool isColor;
  final String pageOption;
  final String? pageRange;
  final int copies;
  final int totalPages;
  final double totalPrice;
  final String fileName;
  final String filePath;
  final String fileExtension;
  final int fileSize;

  const PrintOptionsModel({
    required this.isColor,
    this.pageOption = 'All',
    this.pageRange,
    required this.copies,
    required this.totalPages,
    required this.totalPrice,
    required this.fileName,
    required this.filePath,
    required this.fileExtension,
    required this.fileSize,
  });

  PrintOptionsModel copyWith({
    bool? isColor,
    String? pageOption,
    String? pageRange,
    int? copies,
    int? totalPages,
    double? totalPrice,
    String? fileName,
    String? filePath,
    String? fileExtension,
    int? fileSize,
  }) {
    return PrintOptionsModel(
      isColor: isColor ?? this.isColor,
      pageOption: pageOption ?? this.pageOption,
      pageRange: pageRange ?? this.pageRange,
      copies: copies ?? this.copies,
      totalPages: totalPages ?? this.totalPages,
      totalPrice: totalPrice ?? this.totalPrice,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  Map<String, dynamic> toApiFields() => {
        'pages': pageOption == 'Custom' && pageRange != null
            ? pageRange!
            : 'all',
        'colour': isColor ? 'Color' : 'Black & White',
        'counts': copies.toString(),
      };

  @override
  List<Object?> get props => [
        isColor,
        pageOption,
        pageRange,
        copies,
        totalPages,
        totalPrice,
        fileName,
        filePath,
        fileExtension,
        fileSize,
      ];
}
