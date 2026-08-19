import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/stage_visualizer.dart';
import '../widgets/options_panel.dart';

class ConfiguratorScreen extends StatelessWidget {
  const ConfiguratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;
                  if (isDesktop) {
                    return const Row(
                      children: [
                        Expanded(flex: 6, child: StageVisualizer()),
                        Expanded(flex: 4, child: OptionsPanel()),
                      ],
                    );
                  } else {
                    return const Column(
                      children: [
                        Expanded(flex: 5, child: StageVisualizer()),
                        Expanded(flex: 6, child: OptionsPanel()),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
