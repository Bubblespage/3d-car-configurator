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
        return '0deg 90deg 10%';
      case 'Front 3/4':
      default:
        return '45deg 75deg auto';
    }
  }

  String _buildShaderScript(Color paintColor, String finish, Color interiorColor) {
    final pr = (paintColor.red / 255.0).toStringAsFixed(4);
    final pg = (paintColor.green / 255.0).toStringAsFixed(4);
    final pb = (paintColor.blue / 255.0).toStringAsFixed(4);

    final ir = (interiorColor.red / 255.0).toStringAsFixed(4);
    final ig = (interiorColor.green / 255.0).toStringAsFixed(4);
    final ib = (interiorColor.blue / 255.0).toStringAsFixed(4);

    final double roughness =
        finish == 'Matte' ? 0.85 : (finish == 'Metallic' ? 0.18 : 0.08);
    final double metallic =
        finish == 'Matte' ? 0.05 : (finish == 'Metallic' ? 0.95 : 0.35);

    return '''
      (() => {
        const updateCarAppearance = () => {
          const viewer = document.querySelector('model-viewer');
          if (!viewer || !viewer.model || !viewer.model.materials) return false;

          const materials = viewer.model.materials;
          console.log('[3D Configurator] Detected Materials:', materials.map(m => m.name));

          const isGlass = n => /glass|window|windshield|lens|headlight|taillight|light|lamp|transparent/.test(n);
          const isWheelOrTire = n => /tire|tyre|wheel|rim|spoke|rubber|caliper|brake|rotor|disc/.test(n);
          const isTrimOrCarbon = n => /carbon|badge|logo|emblem|grille|gril|exhaust|plate|license|chrome|dark_trim|black_trim|shadow|undercarriage|mirror_black/.test(n);
          const isInterior = n => /interior|seat|leather|cockpit|upholstery|cabin|cushion|chair|alcantara|cuoio|merino|stitch|steering|dashboard|carpet|floor|door_inner/.test(n);
          const isExplicitPaint = n => /paint|body|carpaint|car_paint|exterior|chassis|shell|coat|lacquer|kuzov|carrosserie|primary|main_color/.test(n);

          function applyPBR(mat, r, g, b, rough, metal) {
            if (!mat || !mat.pbrMetallicRoughness) return;
            const pbr = mat.pbrMetallicRoughness;

            try {
              if (pbr.baseColorTexture && typeof pbr.baseColorTexture.setTexture === 'function') {
                pbr.baseColorTexture.setTexture(null);
              }
            } catch(e) {}

            try {
              pbr.setBaseColorFactor([r, g, b, 1.0]);
              pbr.setRoughnessFactor(rough);
              pbr.setMetallicFactor(metal);
            } catch(e) {
              console.warn('[3D Configurator] Failed applying PBR to ' + mat.name, e);
            }
          }

          // 1. Update Exterior Body Paint
          let bodyMats = materials.filter(m => {
            const n = (m.name || '').toLowerCase();
            return isExplicitPaint(n) && !isGlass(n) && !isWheelOrTire(n) && !isInterior(n);
          });

          // Fallback: If no explicit 'body/paint' named material, target all non-mechanical/non-glass parts
          if (bodyMats.length === 0) {
            bodyMats = materials.filter(m => {
              const n = (m.name || '').toLowerCase();
              return !isGlass(n) && !isWheelOrTire(n) && !isTrimOrCarbon(n) && !isInterior(n);
            });
          }

          bodyMats.forEach(m => applyPBR(m, $pr, $pg, $pb, $roughness, $metallic));

          // 2. Update Interior Cabin Upholstery
          let interiorMats = materials.filter(m => {
            const n = (m.name || '').toLowerCase();
            return isInterior(n);
          });

          interiorMats.forEach(m => applyPBR(m, $ir, $ig, $ib, 0.85, 0.05));

          return true;
        };

        const viewer = document.querySelector('model-viewer');
        if (viewer) {
          if (!updateCarAppearance()) {
            viewer.addEventListener('load', updateCarAppearance, { once: true });
          }
        }
      })();
    ''';
  }

  void _applyMaterialUpdate(ConfiguratorState state) {
    if (_webViewController != null) {
      final script = _buildShaderScript(
        Color(state.selectedPaint.colorHex),
        state.selectedFinish,
        Color(state.selectedInterior.colorHex),
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

    // Trigger instant shader repaints when Paint, Finish, Interior, or Car changes
    ref.listen<ConfiguratorState>(configuratorProvider, (previous, next) {
      if (previous?.selectedPaint != next.selectedPaint ||
          previous?.selectedFinish != next.selectedFinish ||
          previous?.selectedInterior != next.selectedInterior ||
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
          // 1. Illuminated Turntable Glow
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
          // 2. 3D Model Viewer
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
              // Progressive retries to apply materials as GLB finishes streaming
              for (final delayMs in [200, 600, 1200, 2500]) {
                Future.delayed(Duration(milliseconds: delayMs), () {
                  if (mounted) _applyMaterialUpdate(state);
                });
              }
            },
          ),
          // 3. Camera View Switcher
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
          // 4. Performance Specs Telemetry HUD
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