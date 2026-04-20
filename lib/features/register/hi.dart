// import 'package:flutter/material.dart';
// import 'package:hostelops_owner/core/custome_widget/auth_toggle.dart';
// import 'package:hostelops_owner/core/routes/app_routes.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),

//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               // ✅ TOGGLE AT TOP
//               AuthToggle(
//                 isLogin: false,
//                 onLoginTap: () {
//                   Navigator.pushReplacementNamed(context, AppRoutes.login);
//                 },
//                 onRegisterTap: () {},
//               ),

//               const SizedBox(height: 40),

//               // 📝 TITLE
//               const Text(
//                 "Create Account",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 10),

//               const Text(
//                 "Register to continue",
//                 style: TextStyle(color: Colors.grey),
//               ),

//               const SizedBox(height: 40),

//               // 👤 FIRST NAME
//               _buildInput("First Name"),

//               const SizedBox(height: 15),

//               // 👤 LAST NAME
//               _buildInput("Last Name"),

//               const SizedBox(height: 15),

//               // 📧 EMAIL
//               _buildInput("Email"),

//               const SizedBox(height: 15),

//               // 📱 PHONE
//               _buildInput("Mobile Number"),

//               const SizedBox(height: 30),

//               // 🔘 BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: const Text("Register"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

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
