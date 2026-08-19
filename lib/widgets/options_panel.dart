import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/configurator_provider.dart';

class OptionsPanel extends ConsumerWidget {
  const OptionsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(configuratorProvider);
    final notifier = ref.read(configuratorProvider.notifier);

    final tabs = ['1 Trim', '2 Paint', '3 Wheels', '4 Interior', '5 Packages', '6 Summary'];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131720).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF222836)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Vehicle Model Dropdown Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Configuration Panel',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Car Selector Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2C),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0070F3).withOpacity(0.5)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF1A1F2C),
                    value: state.selectedCar.id,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00B4D8)),
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    items: availableCarsCatalog.map((car) {
                      return DropdownMenuItem<String>(
                        value: car.id,
                        child: Text(car.name),
                      );
                    }).toList(),
                    onChanged: (newCarId) {
                      if (newCarId != null) {
                        final car = availableCarsCatalog.firstWhere((c) => c.id == newCarId);
                        notifier.selectCar(car);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tabs
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tabs.map((tab) {
              final isSelected = state.selectedTab == tab;
              return InkWell(
                onTap: () => notifier.setTab(tab),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0070F3) : const Color(0xFF1A1F2C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Dynamic Tab Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildActiveTabContent(state, notifier),
            ),
          ),

          // Footer
          const Divider(color: Color(0xFF222836)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL MSRP:', style: TextStyle(fontSize: 11, color: Colors.white38)),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: state.totalMSRP),
                    duration: const Duration(milliseconds: 250),
                    builder: (context, value, _) {
                      return Text(
                        '\$${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('EST. FINANCE:', style: TextStyle(fontSize: 11, color: Colors.white38)),
                  Text(
                    '\$${state.estFinanceMonthly.toInt()} / mo',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00B4D8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070F3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF0070F3),
                    content: Text(
                      'Saved build for ${state.selectedCar.name} (${state.selectedTrim.name})!',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              child: Text(
                'Configure Payment / BOOK TEST DRIVE',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent(ConfiguratorState state, ConfiguratorNotifier notifier) {
    switch (state.selectedTab) {
      case '1 Trim':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle Trim & Engine',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 12),
            ...state.selectedCar.trims.map((trim) {
              final isSelected = state.selectedTrim.id == trim.id;
              return InkWell(
                onTap: () => notifier.setTrim(trim),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0070F3) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(trim.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            trim.priceDelta == 0 ? 'Included' : '(+\$${trim.priceDelta.toInt()})',
                            style: TextStyle(color: isSelected ? const Color(0xFF00B4D8) : Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(trim.description, style: const TextStyle(fontSize: 12, color: Colors.white60)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _badge('${trim.hp} HP'),
                          const SizedBox(width: 8),
                          _badge('${trim.zeroToSixty}s 0-60'),
                          const SizedBox(width: 8),
                          _badge('${trim.topSpeed} MPH'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case '2 Paint':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exterior Paint Colors',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 10),
            ...state.selectedCar.paints.map((paint) {
              final isSelected = state.selectedPaint.id == paint.id;
              return InkWell(
                onTap: () => notifier.setPaint(paint),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0070F3) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Color(paint.colorHex),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(paint.name, style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      Text(
                        paint.price == 0 ? '(+\$0)' : '(+\$${paint.price.toInt()})',
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 14),
            Text('Finish Material', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              children: ['Gloss', 'Metallic', 'Matte'].map((finish) {
                final isSelected = state.selectedFinish == finish;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFF0070F3).withOpacity(0.2) : Colors.transparent,
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF0070F3) : const Color(0xFF2E3547),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => notifier.setFinish(finish),
                      child: Text(finish, style: const TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );

      case '3 Wheels':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wheel Styles & Rims',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 12),
            ...state.selectedCar.wheels.map((wheel) {
              final isSelected = state.selectedWheel.id == wheel.id;
              return InkWell(
                onTap: () => notifier.setWheel(wheel),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0070F3) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.radio_button_checked, size: 20, color: Color(0xFF00B4D8)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(wheel.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(wheel.size, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        wheel.price == 0 ? 'Included' : '(+\$${wheel.price.toInt()})',
                        style: TextStyle(color: isSelected ? const Color(0xFF00B4D8) : Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case '4 Interior':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cockpit & Upholstery',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 12),
            ...state.selectedCar.interiors.map((interior) {
              final isSelected = state.selectedInterior.id == interior.id;
              return InkWell(
                onTap: () => notifier.setInterior(interior),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0070F3) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Color(interior.colorHex),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(interior.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(interior.material, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        interior.price == 0 ? 'Included' : '(+\$${interior.price.toInt()})',
                        style: TextStyle(color: isSelected ? const Color(0xFF00B4D8) : Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case '5 Packages':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Packages & Upgrades',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 12),
            if (state.selectedCar.packages.isEmpty)
              const Text('No add-on packages available for this model.', style: TextStyle(color: Colors.white54))
            else
              ...state.selectedCar.packages.map((pkg) {
                final isSelected = state.selectedPackageIds.contains(pkg.id);
                return InkWell(
                  onTap: () => notifier.togglePackage(pkg.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F2C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0070F3) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isSelected,
                          activeColor: const Color(0xFF0070F3),
                          onChanged: (_) => notifier.togglePackage(pkg.id),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pkg.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(pkg.description, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                              const SizedBox(height: 4),
                              Text('(+\$${pkg.price.toInt()})',
                                  style: const TextStyle(
                                      color: Color(0xFF00B4D8), fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );

      case '6 Summary':
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specification Summary',
                style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 12),
            _summaryRow('Model', state.selectedCar.name),
            _summaryRow('Trim', state.selectedTrim.name),
            _summaryRow('Performance', '${state.horsePower} HP | ${state.zeroToSixty}s 0-60'),
            _summaryRow('Exterior Paint', '${state.selectedPaint.name} (${state.selectedFinish})'),
            _summaryRow('Wheels', state.selectedWheel.name),
            _summaryRow('Interior', '${state.selectedInterior.name} (${state.selectedInterior.material})'),
            _summaryRow('Packages', '${state.selectedPackageIds.length} Selected'),
            const Divider(color: Color(0xFF222836), height: 24),
            _summaryRow('Base MSRP', '\$${state.selectedCar.basePrice.toInt()}'),
            _summaryRow('Selected Options', '\$${(state.totalMSRP - state.selectedCar.basePrice).toInt()}'),
            _summaryRow('Total Price (MSRP)', '\$${state.totalMSRP.toInt()}', isHighlight: true),
          ],
        );
    }
  }

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF121620),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF00B4D8), fontWeight: FontWeight.w600)),
      );

  Widget _summaryRow(String label, String value, {bool isHighlight = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: isHighlight ? Colors.white : Colors.white54,
                    fontSize: 13,
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal)),
            Text(value,
                style: TextStyle(
                    color: isHighlight ? const Color(0xFF00B4D8) : Colors.white,
                    fontSize: 13,
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      );
}