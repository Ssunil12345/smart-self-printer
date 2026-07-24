import 'package:equatable/equatable.dart';
import '../core/utils/helpers.dart';

class PrintOptionsModel extends Equatable {
  final bool isColor;
  final String pageOption;
  final String? pageRange;
  final int copies;
  final int totalPages;
  final int totalFilePages;
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
    required this.totalFilePages,
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
    int? totalFilePages,
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
      totalFilePages: totalFilePages ?? this.totalFilePages,
      totalPrice: totalPrice ?? this.totalPrice,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  int get calculatedPageCount {
    if (pageOption == 'All') return totalFilePages;
    return Helpers.parseCustomRange(pageRange, totalFilePages);
  }

  Map<String, dynamic> toApiFields() => {
        'pages': calculatedPageCount.toString(),
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
        totalFilePages,
        totalPrice,
        fileName,
        filePath,
        fileExtension,
        fileSize,
      ];
}
