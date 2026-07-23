import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/print_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/error_dialog.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String _currentStatus = 'Uploading...';
  int _statusIndex = 0;
  final List<String> _statuses = [
    AppStrings.uploading,
    AppStrings.checkingFile,
    AppStrings.preparingPrint,
    AppStrings.almostDone,
  ];

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  Future<void> _startUpload() async {
    final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! PlatformFile) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
      return;
    }

    final file = args;
    final printProvider = context.read<PrintProvider>();

    _animateStatus();

    final success = await printProvider.uploadFile(
      filePath: file.path ?? '',
      fileName: file.name,
      fileExtension: file.extension ?? '',
      fileSize: file.size,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.preview);
    } else {
      ErrorDialog.show(
        context: context,
        title: 'Upload Failed',
        message: printProvider.error ?? 'Failed to upload file',
        retryLabel: 'Retry',
        onRetry: () {
          printProvider.clearError();
          _startUpload();
        },
      );
    }
  }

  void _animateStatus() async {
    while (mounted && _statusIndex < _statuses.length - 1) {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (!mounted) return;
      setState(() {
        _statusIndex++;
        _currentStatus = _statuses[_statusIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [AppColors.background, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                'assets/animations/loading.json',
                errorBuilder: (context, error, stackTrace) =>
                    CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Consumer<PrintProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    Text(
                      _currentStatus,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ).animate().fadeIn().shake(),
                    if (provider.uploadProgress > 0) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: provider.uploadProgress,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.1)
                                : AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(provider.uploadProgress * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
