import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/core/custome_widget/authi_togg/auth_toggle.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/auth/presentation/otp_screen.dart';
import 'package:hostelops_owner/features/register/cubit/register_cubit.dart';
import 'package:hostelops_owner/features/register/state/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final phone = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEmailHidden = true;
  bool isPhoneHidden = true;

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  late final AnimationController _controller;
  late final Animation<double> fadeAnim;
  late final Animation<Offset> slideAnim;

  String getOtp() => otpControllers.map((e) => e.text).join();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(_controller);

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    phone.dispose();
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Enter phone number";
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) return "Invalid number";
    return null;
  }

  String? validateName(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return "Enter $field";
    }
    if (value.trim().length < 2) {
      return "$field must be at least 2 characters";
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return "$field should contain only letters";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
      return "Invalid email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: BlocListener<RegisterCubit, RegisterState>(
        listenWhen: (prev, curr) =>
            prev.otpSent != curr.otpSent ||
            prev.isVerified != curr.isVerified ||
            prev.error != curr.error,

        listener: (context, state) {
          // 🔁 Restart animation when OTP screen appears
          // if (state.otpSent) {
          //   _controller.reset();
          //   _controller.forward();
          // }
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.otpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OtpScreen(phone: phone.text)),
            );
          }
          // ❌ Show error
          // if (state.error != null) {
          //   ScaffoldMessenger.of(
          //     context,
          //   ).showSnackBar(SnackBar(content: Text(state.error!)));
          // }
          // ✅ Navigate to dashboard
          else if (state.isVerified) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }
        },

        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),

                            Text(
                              state.otpSent
                                  ? "Verification Code"
                                  : "OTP Register",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              state.otpSent
                                  ? "Enter code sent to +91 ${phone.text}"
                                  : "Enter your mobile number",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 40),

                            // ✅ TOGGLE AT TOP
                            AuthToggle(
                              isLogin: false,
                              onLoginTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                              onRegisterTap: () {},
                            ),
                            SizedBox(height: 30),
                            if (!state.otpSent) ...[
                              // First Name
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: firstName,
                                  validator: (v) =>
                                      validateName(v, "First name"),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "First Name",
                                    hintStyle: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Last Name
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: lastName,
                                  validator: (v) =>
                                      validateName(v, "Last name"),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Email
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: email,
                                  validator: validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: isEmailHidden,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(fontSize: 13),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isEmailHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isEmailHidden = !isEmailHidden;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Phone
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: phone,
                                  validator: validatePhone,
                                  keyboardType: TextInputType.phone,
                                  obscureText: isPhoneHidden,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter mobile number",
                                    hintStyle: TextStyle(fontSize: 13),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPhoneHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPhoneHidden = !isPhoneHidden;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // 🔢 OTP INPUT
                            if (state.otpSent) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return SizedBox(
                                    width: 45,
                                    child: TextField(
                                      controller: otpControllers[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        counterText: "",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      onChanged: (v) {
                                        if (v.isNotEmpty && index < 5) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "Resend in ${state.timer}s",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],

                            const SizedBox(height: 40),

                            // 📱 PHONE
                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: GestureDetector(
                                onTap: state.isLoading
                                    ? null
                                    : () {
                                        if (!state.otpSent &&
                                            !_formKey.currentState!.validate())
                                          return;

                                        if (state.otpSent) {
                                          context
                                              .read<RegisterCubit>()
                                              .verifyOtp(getOtp(), phone.text);
                                        } else {
                                          context.read<RegisterCubit>().sendOtp(
                                            phone.text,
                                            firstName.text,
                                            lastName.text,
                                            email.text,
                                          );
                                        }
                                      },
                                child: Opacity(
                                  opacity: state.isLoading ? 0.6 : 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7B5CF1),
                                          Color(0xFF5A3EC8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),

                                      /// 🔥 SHADOW
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF5A3EC8,
                                          ).withOpacity(0.5),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),

                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        /// ✨ TOP SHINE
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(30),
                                                  ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(
                                                    0.25,
                                                  ),
                                                  Colors.transparent,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                        state.isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                state.otpSent
                                                    ? "Confirm"
                                                    : "Continue",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//   Widget _buildInput(String hint) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: TextField(
//         decoration: InputDecoration(border: InputBorder.none, hintText: hint),
//       ),
//     );
//   }
// }
