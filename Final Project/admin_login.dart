import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/custom_text_field.dart';
import 'admin_home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() {
    if (_emailController.text == 'admin123@gmail.com' &&
        _passwordController.text == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive breakpoints
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1200;

    // Responsive sizing
    final double maxWidth = isMobile ? screenWidth * 0.9 : isTablet ? 500 : 600;
    final double titleFontSize = isMobile ? screenWidth * 0.08 : isTablet ? 40 : 48;
    final double buttonWidth = isMobile ? screenWidth * 0.6 : isTablet ? 300 : 350;
    final double buttonHeight = isMobile ? screenHeight * 0.06 : 50;
    final double padding = isMobile ? screenWidth * 0.04 : 32;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: screenHeight * 0.05),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Text(
                    'Admin Login',
                    style: AppTextStyles.headline1.copyWith(
                      fontSize: titleFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    obscureText: true,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyText2.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: Size(buttonWidth, buttonHeight),
                    ),
                    child: Container(
                      width: buttonWidth,
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: AppTextStyles.button.copyWith(
                            fontSize: isMobile ? screenWidth * 0.04 : 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.08),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}