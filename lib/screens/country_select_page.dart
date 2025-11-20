import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_profile.dart';
import 'signup_page.dart';

class CountrySelectPage extends StatefulWidget {
    const CountrySelectPage({super.key});

    @override
    State<CountrySelectPage> createState() => _CountrySelectPageState();
}

class _CountrySelectPageState extends State<CountrySelectPage> {
    TravelerCountry? _selectedCountry;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
            child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // 제목
                Text(
                    'Where are you from?',
                    style: AppTextStyles.pageTitle.copyWith(
                    fontSize: 28,
                    ),
                ),
                const SizedBox(height: 8),
                Text(
                    "We'll customize your Seoul experience",
                    style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: AppColors.textMuted,
                    ),
                ),
                const SizedBox(height: 32),

                // 국가 리스트
                _CountryTile(
                    country: TravelerCountry.us,
                    selected: _selectedCountry == TravelerCountry.us,
                    onTap: () => setState(() {
                    _selectedCountry = TravelerCountry.us;
                    }),
                ),
                const SizedBox(height: 16),
                _CountryTile(
                    country: TravelerCountry.uk,
                    selected: _selectedCountry == TravelerCountry.uk,
                    onTap: () => setState(() {
                    _selectedCountry = TravelerCountry.uk;
                    }),
                ),
                const SizedBox(height: 16),
                _CountryTile(
                    country: TravelerCountry.germany,
                    selected: _selectedCountry == TravelerCountry.germany,
                    onTap: () => setState(() {
                    _selectedCountry = TravelerCountry.germany;
                    }),
                ),
                const SizedBox(height: 16),
                _CountryTile(
                    country: TravelerCountry.canada,
                    selected: _selectedCountry == TravelerCountry.canada,
                    onTap: () => setState(() {
                    _selectedCountry = TravelerCountry.canada;
                    }),
                ),

                const Spacer(),

                // Continue 버튼
                SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCountry == null
                            ? AppColors.textMuted.withOpacity(0.2)
                            : AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        ),
                    ),
                    onPressed: _selectedCountry == null
                        ? null
                        : () {
                            // 다음 화면(회원 정보 입력)으로
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                builder: (_) => SignupPage(
                                    country: _selectedCountry!,
                                ),
                                ),
                            );
                            },
                    child: Text(
                        'Continue',
                        style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        ),
                    ),
                    ),
                ),
                ],
            ),
            ),
        ),
        );
    }
}

class _CountryTile extends StatelessWidget {
    final TravelerCountry country;
    final bool selected;
    final VoidCallback onTap;

    const _CountryTile({
        required this.country,
        required this.selected,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
                BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 8),
                ),
            ],
            border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderSoft,
                width: selected ? 1.4 : 1.0,
            ),
            ),
            child: Row(
            children: [
                Text(
                country.flagEmoji,
                style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                child: Text(
                    country.name,
                    style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 18,
                    color: AppColors.textMain,
                    ),
                ),
                ),
                const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                ),
            ],
            ),
        ),
        );
    }
}