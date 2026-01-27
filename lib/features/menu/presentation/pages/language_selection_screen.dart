import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/providers/locale_provider.dart';
import 'package:foodora/core/localization/app_localizations.dart';
import 'package:foodora/features/menu/presentation/pages/branch_selection_screen.dart';
import 'package:foodora/core/constants/app_constants.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localizations.translate('select_language'),
          style: TextStyle(
            color: Colors.black,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: Column(
              children: [
                _LanguageOption(
                  languageName: localizations.translate('english'),
                  languageCode: 'en',
                  flag: '🇬🇧',
                  isSelected: localeProvider.locale.languageCode == 'en',
                  onTap: () async {
                    await localeProvider.setLocale(const Locale('en'));
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const BranchSelectionScreen(),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                _LanguageOption(
                  languageName: localizations.translate('swedish'),
                  languageCode: 'sv',
                  flag: '🇸🇪',
                  isSelected: localeProvider.locale.languageCode == 'sv',
                  onTap: () async {
                    await localeProvider.setLocale(const Locale('sv'));
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const BranchSelectionScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String languageName;
  final String languageCode;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageName,
    required this.languageCode,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(
          AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 24),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(
                fontSize: AppDimensions.responsive(context, mobile: 32, tablet: 40),
              ),
            ),
            SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: AppDimensions.getH3Size(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF4CAF50),
                size: AppDimensions.responsiveIconSize(context, mobile: 28, tablet: 32),
              ),
          ],
        ),
      ),
    );
  }
}
