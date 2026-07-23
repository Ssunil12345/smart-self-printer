import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String themeMode;

  const SettingsModel({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.themeMode = 'system',
  });

  SettingsModel copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? themeMode,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'notificationsEnabled': notificationsEnabled,
        'themeMode': themeMode,
      };

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        isDarkMode: json['isDarkMode'] as bool? ?? false,
        notificationsEnabled:
            json['notificationsEnabled'] as bool? ?? true,
        themeMode: json['themeMode'] as String? ?? 'system',
      );

  @override
  List<Object?> get props => [isDarkMode, notificationsEnabled, themeMode];
}
