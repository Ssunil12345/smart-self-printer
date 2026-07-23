import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/glass_card.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => _appVersion = '${info.version}+${info.buildNumber}');
    } catch (_) {
      setState(() => _appVersion = '1.0.0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              FadeIn(
                child: GlassCard(
                  child: Column(
                    children: [
                      _buildSettingItem(
                        icon: isDark ? Icons.dark_mode : Icons.light_mode,
                        title: 'Theme',
                        subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                        trailing: Switch(
                          value: settingsProvider.isDarkMode,
                          onChanged: (_) => settingsProvider.toggleDarkMode(),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const Divider(height: 24),
                      _buildSettingItem(
                        icon: Icons.notifications_outlined,
                        title: AppStrings.notifications,
                        subtitle: settingsProvider.notificationsEnabled
                            ? 'Enabled'
                            : 'Disabled',
                        trailing: Switch(
                          value: settingsProvider.notificationsEnabled,
                          onChanged: (_) =>
                              settingsProvider.toggleNotifications(),
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                delay: const Duration(milliseconds: 150),
                child: GlassCard(
                  child: Column(
                    children: [
                      _buildSettingItem(
                        icon: Icons.info_outline,
                        title: AppStrings.about,
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textHint),
                        onTap: () => _showAbout(context),
                      ),
                      const Divider(height: 24),
                      _buildSettingItem(
                        icon: Icons.privacy_tip_outlined,
                        title: AppStrings.privacyPolicy,
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textHint),
                        onTap: () => _showSimpleDialog(
                          context,
                          AppStrings.privacyPolicy,
                          'Your privacy is important to us. We collect only necessary information to process your print orders. We do not share your personal data with third parties.',
                        ),
                      ),
                      const Divider(height: 24),
                      _buildSettingItem(
                        icon: Icons.description_outlined,
                        title: AppStrings.terms,
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textHint),
                        onTap: () => _showSimpleDialog(
                          context,
                          AppStrings.terms,
                          'By using Smart Self Printer, you agree to our terms of service. You are responsible for the content you upload. We reserve the right to refuse service for prohibited content.',
                        ),
                      ),
                      const Divider(height: 24),
                      _buildSettingItem(
                        icon: Icons.info_outline,
                        title: 'App Version',
                        subtitle: _appVersion,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                delay: const Duration(milliseconds: 300),
                child: GlassCard(
                  child: _buildSettingItem(
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  AppStrings.developedBy,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '© ${DateTime.now().year} ${AppStrings.allRightsReserved}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.print, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version $_appVersion',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.developedBy,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Smart Self Printer is a self-service print ordering platform. Upload your documents, configure print settings, make payment, and collect your prints.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK',
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK',
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          AppStrings.logout,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          AppStrings.logoutConfirm,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel,
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Text(AppStrings.logout,
                style: GoogleFonts.poppins(
                    color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
