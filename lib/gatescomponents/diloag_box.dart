import 'package:flutter/material.dart';

class DiloagBox {
  static Future<int?> getNumberOfNoders(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter the number of nodes"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter the number",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final String input = controller.text;
                    final int? number = int.tryParse(input);
                    Navigator.of(context).pop(number);
                  },
                  child: const Text("OK")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }
}
