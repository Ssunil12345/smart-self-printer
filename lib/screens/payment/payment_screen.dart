import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../providers/payment_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/error_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(child: Text('No payment data')),
      );
    }

    final orderNumber = args['orderNumber'] as String;
    final totalPrice = args['totalPrice'] as double;
    final fileName = args['fileName'] as String;
    final copies = args['copies'] as int;
    final isColor = args['isColor'] as bool;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.payment),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FadeIn(
                  child: GlassCard(
                    child: Column(
                      children: [
                        Text(
                          'Amount to Pay',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Helpers.formatCurrency(totalPrice),
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$copies copy${copies > 1 ? 'ies' : 'y'} | ${isColor ? 'Color' : 'B&W'}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 150),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.paymentMethods,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...AppConstants.paymentMethodsList.map((method) {
                  final isSelected =
                      paymentProvider.selectedMethod == method;
                  IconData icon;
                  switch (method) {
                    case 'UPI':
                      icon = Icons.phone_android;
                      break;
                    case 'Card':
                      icon = Icons.credit_card;
                      break;
                    case 'Wallet':
                      icon = Icons.account_balance_wallet;
                      break;
                    case 'Cash':
                      icon = Icons.money;
                      break;
                    default:
                      icon = Icons.payment;
                  }

                  return FadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(4),
                      child: RadioListTile<String>(
                        value: method,
                        groupValue: paymentProvider.selectedMethod,
                        onChanged: (v) {
                          if (v != null) paymentProvider.selectMethod(v);
                        },
                        toggleable: false,
                        title: Text(
                          method,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        secondary: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                            size: 22,
                          ),
                        ),
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 400),
                  child: AppButton(
                    text: paymentProvider.isProcessing
                        ? AppStrings.processing
                        : AppStrings.payNow,
                    isLoading: paymentProvider.isProcessing,
                    isGradient: true,
                    onPressed: paymentProvider.isProcessing
                        ? null
                        : () => _processPayment(
                              context,
                              paymentProvider,
                              orderNumber,
                              totalPrice,
                              fileName,
                              copies,
                              isColor,
                            ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeIn(
                  delay: const Duration(milliseconds: 450),
                  child: AppButton(
                    text: AppStrings.cancelPayment,
                    isOutlined: true,
                    onPressed: paymentProvider.isProcessing
                        ? null
                        : () => _cancelPayment(
                              context,
                              paymentProvider,
                              orderNumber,
                            ),
                  ),
                ),
                if (paymentProvider.isConfirming) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                            errorBuilder: (context, error, stackTrace) =>
                                const CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Confirming payment...',
                          style: GoogleFonts.poppins(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _processPayment(
    BuildContext context,
    PaymentProvider paymentProvider,
    String orderNumber,
    double totalPrice,
    String fileName,
    int copies,
    bool isColor,
  ) async {
    if (paymentProvider.selectedMethod == null) {
      ErrorDialog.showSnackBar(
        context: context,
        message: 'Please select a payment method',
      );
      return;
    }

    final success = await paymentProvider.processPayment(
      orderNumber: orderNumber,
      amount: totalPrice,
      fileName: fileName,
      copies: copies,
      isColor: isColor,
    );

    if (!mounted) return;

    if (success) {
      final confirmSuccess = await paymentProvider.confirmPayment('1');
      if (!mounted) return;

      if (confirmSuccess) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.success,
          arguments: {
            'orderNumber': orderNumber,
          },
        );
      } else {
        ErrorDialog.show(
          context: context,
          title: 'Payment Confirmation Failed',
          message:
              paymentProvider.error ?? 'Failed to confirm payment status',
          retryLabel: 'Retry',
          onRetry: () => _processPayment(
            context,
            paymentProvider,
            orderNumber,
            totalPrice,
            fileName,
            copies,
            isColor,
          ),
        );
      }
    } else {
      ErrorDialog.show(
        context: context,
        title: 'Payment Failed',
        message: paymentProvider.error ?? 'Payment processing failed',
        retryLabel: 'Retry',
        onRetry: () => _processPayment(
          context,
          paymentProvider,
          orderNumber,
          totalPrice,
          fileName,
          copies,
          isColor,
        ),
      );
    }
  }

  Future<void> _cancelPayment(
    BuildContext context,
    PaymentProvider paymentProvider,
    String orderNumber,
  ) async {
    await paymentProvider.confirmPayment('0');
    if (!mounted) return;

    ErrorDialog.show(
      context: context,
      title: 'Payment Failed',
      message: 'Payment was cancelled by the user',
      retryLabel: 'Retry',
      onRetry: () => _cancelPayment(
        context,
        paymentProvider,
        orderNumber,
      ),
    );
  }
}
