import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String orderNumber;
  final String fileName;
  final int copies;
  final bool isColor;
  final double amount;
  final String status;
  final DateTime date;
  final String orderId;

  const OrderModel({
    required this.orderNumber,
    required this.fileName,
    required this.copies,
    required this.isColor,
    required this.amount,
    required this.status,
    required this.date,
    required this.orderId,
  });

  OrderModel copyWith({
    String? orderNumber,
    String? fileName,
    int? copies,
    bool? isColor,
    double? amount,
    String? status,
    DateTime? date,
    String? orderId,
  }) {
    return OrderModel(
      orderNumber: orderNumber ?? this.orderNumber,
      fileName: fileName ?? this.fileName,
      copies: copies ?? this.copies,
      isColor: isColor ?? this.isColor,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      date: date ?? this.date,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toJson() => {
        'orderNumber': orderNumber,
        'fileName': fileName,
        'copies': copies,
        'isColor': isColor,
        'amount': amount,
        'status': status,
        'date': date.toIso8601String(),
        'orderId': orderId,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderNumber: json['orderNumber'] as String? ?? '',
        fileName: json['fileName'] as String? ?? '',
        copies: json['copies'] as int? ?? 1,
        isColor: json['isColor'] as bool? ?? false,
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        status: json['status'] as String? ?? 'Queued',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        orderId: json['orderId'] as String? ?? '',
      );

  @override
  List<Object?> get props =>
      [orderNumber, fileName, copies, isColor, amount, status, date, orderId];
}
