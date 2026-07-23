import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String method;
  final double amount;
  final String orderNumber;
  final bool isSuccess;
  final DateTime? date;

  const PaymentModel({
    required this.method,
    required this.amount,
    required this.orderNumber,
    this.isSuccess = false,
    this.date,
  });

  PaymentModel copyWith({
    String? method,
    double? amount,
    String? orderNumber,
    bool? isSuccess,
    DateTime? date,
  }) {
    return PaymentModel(
      method: method ?? this.method,
      amount: amount ?? this.amount,
      orderNumber: orderNumber ?? this.orderNumber,
      isSuccess: isSuccess ?? this.isSuccess,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method,
        'amount': amount,
        'orderNumber': orderNumber,
        'isSuccess': isSuccess,
        'date': date?.toIso8601String(),
      };

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        method: json['method'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        orderNumber: json['orderNumber'] as String? ?? '',
        isSuccess: json['isSuccess'] as bool? ?? false,
        date: DateTime.tryParse(json['date'] as String? ?? ''),
      );

  @override
  List<Object?> get props => [method, amount, orderNumber, isSuccess, date];
}
