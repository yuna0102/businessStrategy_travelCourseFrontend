import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/user_profile.dart';
import 'find_storage_page.dart';

class SignupPage extends StatefulWidget {
    final TravelerCountry country;

    const SignupPage({
        super.key,
        required this.country,
    });

    @override
    State<SignupPage> createState() => _SignupPageState();
    }

    class _SignupPageState extends State<SignupPage> {
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    int _age = 25;

    @override
    void dispose() {
        _firstNameController.dispose();
        _lastNameController.dispose();
        super.dispose();
    }

    bool get _canContinue =>
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _age > 0;

    void _onContinue() {
        final profile = UserProfile(
        country: widget.country,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        age: _age,
        );

        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            // Provide the user profile to downstream pages (FindStoragePage -> CoursesPage)
            builder: (_) => Provider<UserProfile>.value(
                value: profile,
                child: const FindStoragePage(),
            ),
        ),
        );

        // profile 은 나중에 상위에서 보관 후 CoursesPage 호출 시
        // redditCountryLabel 로 넘겨주기!
    }

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
                    "Let's Signup",
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

                // First name
                Text(
                    'First name',
                    style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    ),
                ),
                const SizedBox(height: 8),
                _RoundedTextField(
                    controller: _firstNameController,
                    hintText: 'Enter Your First Name',
                    onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),

                // Last name
                Text(
                    'Last name',
                    style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    ),
                ),
                const SizedBox(height: 8),
                _RoundedTextField(
                    controller: _lastNameController,
                    hintText: 'Enter Your Last Name',
                    onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),

                // Age
                Text(
                    'Age',
                    style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    ),
                ),
                const SizedBox(height: 8),
                Container(
                    height: 56,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                        BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        ),
                    ],
                    ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        _AgeButton(
                        icon: Icons.remove,
                        onTap: () {
                            if (_age > 1) {
                            setState(() => _age--);
                            }
                        },
                        ),
                        const SizedBox(width: 40),
                        Text(
                        '$_age',
                        style: AppTextStyles.pageTitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(width: 40),
                        _AgeButton(
                        icon: Icons.add,
                        onTap: () {
                            setState(() => _age++);
                        },
                        ),
                    ],
                    ),
                ),

                const Spacer(),
                // Continue 버튼
                SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _canContinue ? AppColors.primary : AppColors.textMuted.withOpacity(0.2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        ),
                    ),
                    onPressed: _canContinue ? _onContinue : null,
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

class _RoundedTextField extends StatelessWidget {
    final TextEditingController controller;
    final String hintText;
    final ValueChanged<String>? onChanged;

    const _RoundedTextField({
        required this.controller,
        required this.hintText,
        this.onChanged,
    });

    @override
    Widget build(BuildContext context) {
        return TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.textMuted.withOpacity(0.6),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.borderSoft),
            ),
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.borderSoft),
            ),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.primary),
            ),
        ),
        );
    }
}

class _AgeButton extends StatelessWidget {
    final IconData icon;
    final VoidCallback onTap;

    const _AgeButton({
        required this.icon,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(
            icon,
            size: 20,
            color: AppColors.textMain,
            ),
        ),
        );
    }
}
