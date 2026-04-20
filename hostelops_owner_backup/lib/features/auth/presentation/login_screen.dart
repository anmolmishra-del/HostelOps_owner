import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/auth/state/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

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
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    phone.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: BlocListener<LoginCubit, LoginState>(
        listenWhen: (prev, curr) =>
            prev.otpSent != curr.otpSent ||
            prev.isVerified != curr.isVerified ||
            prev.error != curr.error,

        listener: (context, state) {

          // 🔁 Restart animation when OTP screen appears
          if (state.otpSent) {
            _controller.reset();
            _controller.forward();
          }

          // ❌ Show error
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }

          // ✅ Navigate to dashboard
          if (state.isVerified) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }
        },

        child: BlocBuilder<LoginCubit, LoginState>(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 40),

                          Text(
                            state.otpSent
                                ? "Verification Code"
                                : "OTP Login",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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

                          // 📱 PHONE INPUT
                          if (!state.otpSent)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: TextFormField(
                                controller: phone,
                                validator: validatePhone,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter mobile number",
                                ),
                              ),
                            ),

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
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: AppColors.primary),
                                      ),
                                    ),
                                    onChanged: (v) {
                                      if (v.isNotEmpty && index < 5) {
                                        FocusScope.of(context)
                                            .nextFocus();
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              "Resend in ${state.timer}s",
                              style:
                                  const TextStyle(color: Colors.grey),
                            ),
                          ],

                          const SizedBox(height: 40),

                          // 🔘 BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (!state.otpSent &&
                                          !_formKey.currentState!
                                              .validate()) return;

                                      if (state.otpSent) {
                                        context
                                            .read<LoginCubit>()
                                            .verifyOtp(getOtp(),phone.text);
                                      } else {
                                        context
                                            .read<LoginCubit>()
                                            .sendOtp(phone.text);
                                      }
                                    },
                              child: state.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      state.otpSent
                                          ? "Confirm"
                                          : "Continue",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
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
            );
          },
        ),
      ),
    );
  }
}