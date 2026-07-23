import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';

class PriceSummaryCard extends StatelessWidget {
  final bool isColor;
  final int copies;
  final int totalPages;
  final double pricePerPage;

  const PriceSummaryCard({
    super.key,
    required this.isColor,
    required this.copies,
    required this.totalPages,
    required this.pricePerPage,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = Helpers.calculatePrice(
      isColor: isColor,
      copies: copies,
      totalPages: totalPages,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildRow('Print Type', isColor ? 'Color' : 'B&W'),
          const SizedBox(height: 8),
          _buildRow('Pages', '$totalPages pages'),
          const SizedBox(height: 8),
          _buildRow('Copies', '$copies copy${copies > 1 ? 'ies' : 'y'}'),
          const SizedBox(height: 8),
          _buildRow('Price/Page', Helpers.formatCurrency(pricePerPage)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                Helpers.formatCurrency(totalPrice),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
