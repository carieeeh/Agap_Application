import 'package:agap_mobile_v01/layout/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> webViewLauncher({
  required String url,
  String? errorMessage,
  required BuildContext context,
}) async {
  if (!await launchUrl(Uri.parse(url))) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GetDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: errorMessage ?? "Something went wrong!",
          type: "error",
          buttonNumber: 0,
        );
      },
    );
  }
}
