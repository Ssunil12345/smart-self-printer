import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/print_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/price_summary_card.dart';
import '../../widgets/common/error_dialog.dart';

class PrintOptionsScreen extends StatefulWidget {
  const PrintOptionsScreen({super.key});

  @override
  State<PrintOptionsScreen> createState() => _PrintOptionsScreenState();
}

class _PrintOptionsScreenState extends State<PrintOptionsScreen> {
  final _pageRangeController = TextEditingController();

  @override
  void dispose() {
    _pageRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final PlatformFile? file;
    if (args is PlatformFile) {
      file = args;
    } else {
      file = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.printOptions),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PrintProvider>(
        builder: (context, printProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                  child: GlassCard(
                    child: Column(
                      children: [
                        _buildSectionTitle('Color Mode'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildChoiceChip(
                                label: 'Black & White',
                                icon: Icons.invert_colors_off,
                                isSelected: !printProvider.isColor,
                                onTap: () {
                                  if (printProvider.isColor) {
                                    printProvider.toggleColor();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildChoiceChip(
                                label: 'Color',
                                icon: Icons.invert_colors,
                                isSelected: printProvider.isColor,
                                onTap: () {
                                  if (!printProvider.isColor) {
                                    printProvider.toggleColor();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeIn(
                  delay: const Duration(milliseconds: 100),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Pages'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildChoiceChip(
                                label: 'All Pages',
                                icon: Icons.file_copy,
                                isSelected: printProvider.pageOption == 'All',
                                onTap: () => printProvider.setPageOption('All'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildChoiceChip(
                                label: 'Custom',
                                icon: Icons.edit_note,
                                isSelected:
                                    printProvider.pageOption == 'Custom',
                                onTap: () =>
                                    printProvider.setPageOption('Custom'),
                              ),
                            ),
                          ],
                        ),
                        if (printProvider.pageOption == 'Custom') ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: _pageRangeController,
                            decoration: InputDecoration(
                              hintText: 'e.g. 1-5,8,10',
                              labelText: 'Page Range',
                              prefixIcon: const Icon(Icons.numbers, size: 20),
                              helperText:
                                  'Enter page numbers or ranges separated by commas',
                              helperMaxLines: 2,
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (v) => printProvider.setPageRange(v),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Copies'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: printProvider.copies > 1
                                  ? () => printProvider.setCopies(
                                      printProvider.copies - 1,
                                    )
                                  : null,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                '${printProvider.copies}',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: printProvider.copies < 100
                                  ? () => printProvider.setCopies(
                                      printProvider.copies + 1,
                                    )
                                  : null,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 800),
                  child: PriceSummaryCard(
                    isColor: printProvider.isColor,
                    copies: printProvider.copies,
                    totalPages: printProvider.calculatedTotalPages,
                    pricePerPage: printProvider.isColor ? 10 : 3,
                  ),
                ),
                const SizedBox(height: 24),
                FadeIn(
                  delay: const Duration(milliseconds: 900),
                  child: AppButton(
                    text: AppStrings.continueText,
                    isGradient: true,
                    onPressed: () => _handleContinue(context, file!),
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

  void _handleContinue(BuildContext context, PlatformFile file) async {
    final printProvider = context.read<PrintProvider>();

    if (printProvider.pageOption == 'Custom') {
      final range = _pageRangeController.text.trim();
      if (range.isEmpty) {
        ErrorDialog.showSnackBar(
          context: context,
          message: 'Please enter page range',
        );
        return;
      }
    }

    Navigator.pushNamed(context, AppRoutes.loading, arguments: file);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
