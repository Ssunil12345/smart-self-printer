import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../providers/print_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/glass_card.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderNumber = Helpers.generateOrderNumber();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.preview),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PrintProvider>(
        builder: (context, printProvider, _) {
          final options = printProvider.currentOptions;
          if (options == null) {
            return const Center(child: Text('No print options available'));
          }

          final totalPrice = Helpers.calculatePrice(
            isColor: options.isColor,
            copies: options.copies,
            totalPages: options.totalPages,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                  child: GlassCard(
                    child: Column(
                      children: [
                        _buildPreviewRow(
                            Icons.description, 'File', options.fileName),
                        const SizedBox(height: 12),
                        _buildPreviewRow(Icons.palette, 'Color',
                            options.isColor ? 'Color' : 'Black & White'),
                        const SizedBox(height: 12),
                        _buildPreviewRow(Icons.file_copy, 'Pages',
                            options.pageOption == 'All'
                                ? 'All Pages'
                                : 'Custom: ${options.pageRange ?? "N/A"}'),
                        const SizedBox(height: 12),
                        _buildPreviewRow(Icons.content_copy, 'Copies',
                            '${options.copies}'),
                        const SizedBox(height: 12),
                        _buildPreviewRow(Icons.attach_money, 'Total Cost',
                            Helpers.formatCurrency(totalPrice)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: GlassCard(
                    child: Column(
                      children: [
                        Text(
                          AppStrings.orderNumber,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orderNumber,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: AppStrings.back,
                          isOutlined: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: AppStrings.proceedPayment,
                          isGradient: true,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.payment,
                            arguments: {
                              'orderNumber': orderNumber,
                              'totalPrice': totalPrice,
                              'fileName': options.fileName,
                              'copies': options.copies,
                              'isColor': options.isColor,
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
