import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, bool error) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: AppPallete.onSurfaceColor, fontSize: 16)),
        backgroundColor: error ? AppPallete.brightRed : AppPallete.brightGreen,
      ),
    );
}
