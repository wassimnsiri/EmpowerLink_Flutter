import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Function? tapFunction;

  const CustomErrorWidget({super.key, this.tapFunction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const Text("Network error"),
          if (tapFunction != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: () => tapFunction!(),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
                child: const Text("Tap here to refresh"),
              ),
            )
        ],
      ),
    );
  }
}
