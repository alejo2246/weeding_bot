import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VirtualControlWidget extends StatefulWidget {
  const VirtualControlWidget({super.key});

  @override
  State<VirtualControlWidget> createState() => _VirtualControlWidgetState();
}

class _VirtualControlWidgetState extends State<VirtualControlWidget> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("main Page"),
    );
  }
}
