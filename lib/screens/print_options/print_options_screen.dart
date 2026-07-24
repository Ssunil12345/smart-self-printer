import 'dart:async';
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
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFile();
    });
  }

  Future<void> _initFile() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PlatformFile && args.path != null) {
      await context.read<PrintProvider>().initFile(args.path!);
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
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
                        _buildSectionTitle('File Info'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.picture_as_pdf,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              file?.name ?? 'Unknown',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        if (printProvider.totalFilePages > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.description,
                                  color: AppColors.textSecondary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Total Pages: ${printProvider.totalFilePages}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeIn(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _fromController,
                                  decoration: const InputDecoration(
                                    labelText: 'From',
                                    prefixIcon: Icon(Icons.first_page,
                                        size: 20),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => _updatePageRange(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _toController,
                                  decoration: const InputDecoration(
                                    labelText: 'To',
                                    prefixIcon:
                                        Icon(Icons.last_page, size: 20),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => _updatePageRange(),
                                ),
                              ),
                            ],
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

  void _updatePageRange() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    if (from.isNotEmpty && to.isNotEmpty) {
      context.read<PrintProvider>().setPageRange('$from-$to');
    } else {
      context.read<PrintProvider>().setPageRange(null);
    }
  }

  void _handleContinue(BuildContext context, PlatformFile file) async {
    final printProvider = context.read<PrintProvider>();

    if (printProvider.pageOption == 'Custom') {
      final from = int.tryParse(_fromController.text.trim());
      final to = int.tryParse(_toController.text.trim());
      if (from == null || to == null || from < 1 || to > printProvider.totalFilePages || from > to) {
        ErrorDialog.showSnackBar(
          context: context,
          message: 'Please enter a valid page range (1-${printProvider.totalFilePages})',
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
