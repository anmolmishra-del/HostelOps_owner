import 'package:flutter/material.dart';

class PaymentTile extends StatelessWidget {
  final String name;
  final String room;
  final String amount;

  const PaymentTile(this.name, this.room, this.amount, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(name),
      subtitle: Text(room),
      trailing: Text(
        amount,
        style: const TextStyle(color: Colors.green),
      ),
    );
  }
}