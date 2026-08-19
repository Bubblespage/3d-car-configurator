import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../providers/configurator_provider.dart';

class StageVisualizer extends ConsumerStatefulWidget {
  const StageVisualizer({super.key});

  @override
  ConsumerState<StageVisualizer> createState() => _StageVisualizerState();
}

class _StageVisualizerState extends ConsumerState<StageVisualizer> {
  dynamic _webViewController;

  String _getCameraOrbit(String angle) {
    switch (angle) {
      case 'Side':
        return '90deg 80deg auto';
      case 'Rear':
        return '180deg 75deg auto';
      case 'Interior':
        return '0deg 90deg 30%';
      case 'Front 3/4':
      default:
        return '45deg 75deg auto';
    }
  }

  String _buildColorScript(Color color, String finish) {
    final r = (color.red / 255).toStringAsFixed(3);
    final g = (color.green / 255).toStringAsFixed(3);
    final b = (color.blue / 255).toStringAsFixed(3);

    // Calculate PBR values based on finish
    final double roughness =
        finish == 'Matte' ? 0.85 : (finish == 'Metallic' ? 0.20 : 0.08);
    final double metallic =
        finish == 'Matte' ? 0.10 : (finish == 'Metallic' ? 0.95 : 0.40);

    return '''
      (() => {
        const viewer = document.querySelector('model-viewer');
        if (!viewer || !viewer.model) return;
        const materials = viewer.model.materials;
        if (!materials || materials.length === 0) return;

        // 1. Look for targeted body paint material keywords
        let bodyMaterials = materials.filter(m => {
          const n = (m.name || '').toLowerCase();
          return n.includes('body') || 
                 n.includes('paint') || 
                 n.includes('car') || 
                 n.includes('exterior') || 
                 n.includes('roma') || 
                 n.includes('shell') || 
                 n.includes('color') ||
                 n.includes('metal');
        });

        // 2. Fallback: Apply to non-glass/tire/interior materials
        if (bodyMaterials.length === 0) {
          bodyMaterials = materials.filter(m => {
            const n = (m.name || '').toLowerCase();
            return !n.includes('glass') && 
                   !n.includes('tire') && 
                   !n.includes('wheel') && 
                   !n.includes('rim') && 
                   !n.includes('light') &&
                   !n.includes('interior');
          });
        }

        bodyMaterials.forEach(m => {
          if (m.pbrMetallicRoughness) {
            m.pbrMetallicRoughness.setBaseColorFactor([$r, $g, $b, 1.0]);
            m.pbrMetallicRoughness.setRoughnessFactor($roughness);
            m.pbrMetallicRoughness.setMetallicFactor($metallic);
          }
        });
      })();
    ''';
  }

  void _applyMaterialUpdate(ConfiguratorState state) {
    if (_webViewController != null) {
      final script = _buildColorScript(
        Color(state.selectedPaint.colorHex),
        state.selectedFinish,
      );
      try {
        _webViewController.runJavaScript(script);
      } catch (e) {
        debugPrint('JS Material Update Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(configuratorProvider);
    final notifier = ref.read(configuratorProvider.notifier);

    // Watch for color/finish updates and apply instantly
    ref.listen<ConfiguratorState>(configuratorProvider, (previous, next) {
      if (previous?.selectedPaint != next.selectedPaint ||
          previous?.selectedFinish != next.selectedFinish ||
          previous?.selectedCar != next.selectedCar) {
        _applyMaterialUpdate(next);
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, 0.0),
          radius: 0.9,
          colors: [Color(0xFF1A202C), Color(0xFF090B0E)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Glowing Turntable Ring
          Align(
            alignment: const Alignment(0.0, 0.22),
            child: IgnorePointer(
              child: Container(
                width: 480,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(480, 140)),
                  border: Border.all(
                    color: const Color(0xFF00B4D8).withOpacity(0.6),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: const Color(0xFF0070F3).withOpacity(0.2),
                      blurRadius: 70,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. 3D Model Viewer (Reloads when switching car models)
          ModelViewer(
            key: ValueKey(state.selectedCar.id),
            src: state.selectedCar.modelGlbPath,
            alt: '${state.selectedCar.name} 3D Model',
            autoRotate: false,
            cameraControls: true,
            cameraOrbit: _getCameraOrbit(state.cameraView),
            cameraTarget: 'auto auto auto',
            backgroundColor: Colors.transparent,
            shadowIntensity: 1.0,
            exposure: 1.1,
            loading: Loading.eager,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              Future.delayed(const Duration(milliseconds: 600), () {
                _applyMaterialUpdate(state);
              });
            },
          ),

          // 3. Camera View Switcher (Top Left)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F14).withOpacity(0.75),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                spacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Camera View:',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  ...['Front 3/4', 'Side', 'Rear', 'Interior'].map((view) {
                    final isSelected = state.cameraView == view;
                    return InkWell(
                      onTap: () => notifier.setCameraView(view),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0070F3)
                              : const Color(0xFF161A22),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          view,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // 4. Performance Specs HUD (Top Right)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF12151C).withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF0070F3).withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _specBadge('0-60 MPH', '${state.zeroToSixty}s'),
                  _specDivider(),
                  _specBadge('POWER', '${state.horsePower} HP'),
                  _specDivider(),
                  _specBadge('TOP SPEED', '${state.topSpeed} MPH'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specBadge(String title, String val) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 9, color: Colors.white38)),
          Text(
            val,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00B4D8),
            ),
          ),
        ],
      );

  Widget _specDivider() => Container(
        height: 18,
        width: 1,
        color: Colors.white12,
        margin: const EdgeInsets.symmetric(horizontal: 10),
      );
}
