import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class ChoosePlatform extends StatelessWidget {
  const ChoosePlatform({super.key});

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) return const Text("Web app");

    if(Platform.isAndroid) return const Text("Android app");
    if(Platform.isIOS) return const Text("IOS app");
    if(Platform.isFuchsia) return const Text("Fuchsia app");

    if(Platform.isWindows) return const Text("Windows app");
    if(Platform.isMacOS) return const Text("Mac app");
    if(Platform.isLinux) return const Text("WinLinux app");

    return const Text("Undefined platform");
  }
}