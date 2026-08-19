import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vehicle_models.dart';

// Multi-Car Catalog Database
final availableCarsCatalog = [
  // 1. 2020 Ferrari Roma
  CarModel(
    id: 'ferrari_roma',
    name: '2020 Ferrari Roma',
    modelGlbPath: 'models/ferrari_roma.glb',
    basePrice: 222620,
    trims: [
      const TrimOption(
        id: 'roma_base',
        name: 'Ferrari Roma V8',
        hp: 612,
        zeroToSixty: 3.4,
        topSpeed: 199,
        priceDelta: 0,
        description: '3.9L Twin-Turbo V8 with 8-Speed F1 Dual-Clutch.',
      ),
      const TrimOption(
        id: 'roma_carbon',
        name: 'Roma Carbon Spec',
        hp: 625,
        zeroToSixty: 3.2,
        topSpeed: 202,
        priceDelta: 28500,
        description: 'Carbon fiber aero package with tuned sport exhaust.',
      ),
    ],
    paints: [
      const PaintOption(
          id: 'rosso', name: 'Rosso Corsa', colorHex: 0xFFD40000, price: 0),
      const PaintOption(
          id: 'obsidian',
          name: 'Nero Daytona',
          colorHex: 0xFF141414,
          price: 1500),
      const PaintOption(
          id: 'tour_de_france',
          name: 'Blu Tour de France',
          colorHex: 0xFF0F4C81,
          price: 2800),
      const PaintOption(
          id: 'silverstone',
          name: 'Grigio Silverstone',
          colorHex: 0xFF8A9098,
          price: 2400),
      const PaintOption(
          id: 'giallo',
          name: 'Giallo Modena',
          colorHex: 0xFFFFD700,
          price: 3200),
    ],
    wheels: [
      const WheelOption(
          id: 'roma_std',
          name: '20" Standard Forged Silver',
          size: '20-inch',
          price: 0),
      const WheelOption(
          id: 'roma_dark',
          name: '20" Matte Grigio Corsa',
          size: '20-inch',
          price: 3400),
      const WheelOption(
          id: 'roma_carbon',
          name: '20" Diamond Cut Carbon',
          size: '20-inch',
          price: 5800),
    ],
    interiors: [
      const InteriorOption(
          id: 'cuoio',
          name: 'Cuoio Natural Tan',
          colorHex: 0xFF9E5B32,
          material: 'Full Grain Leather',
          price: 0),
      const InteriorOption(
          id: 'nero_alcantara',
          name: 'Nero Alcantara',
          colorHex: 0xFF212121,
          material: 'Alcantara Suede',
          price: 4200),
      const InteriorOption(
          id: 'rosso_interior',
          name: 'Rosso Cockpit',
          colorHex: 0xFF8A0000,
          material: 'Semi-Aniline Leather',
          price: 3800),
    ],
    packages: [
      const AddonPackage(
          id: 'carbon_pack',
          name: 'Carbon Fiber Exterior Kit',
          description: 'Splitter, diffuser, and side skirts in gloss carbon.',
          price: 12500),
      const AddonPackage(
          id: 'passenger_screen',
          name: 'Dual Passenger Touchscreen',
          description: '8.8-inch interactive passenger cockpit display.',
          price: 4500),
      const AddonPackage(
          id: 'magneride',
          name: 'Magneride Dual-Mode Suspension',
          description: 'Real-time adaptive magnetorheological damping.',
          price: 5500),
    ],
  ),

  // 2. 2004 Porsche Carrera GT / GT3 RS
  CarModel(
    id: 'porsche_gt3rs',
    name: '2004 Porsche Carrera GT',
    modelGlbPath: 'models/porsche_carrera.glb',
    basePrice: 241300,
    trims: [
      const TrimOption(
        id: 'gt3rs_base',
        name: '911 GT3 RS Standard',
        hp: 518,
        zeroToSixty: 3.0,
        topSpeed: 184,
        priceDelta: 0,
        description:
            '4.0L Naturally Aspirated Boxer-6 with active DRS aerodynamics.',
      ),
      const TrimOption(
        id: 'gt3rs_weissach',
        name: 'GT3 RS Weissach Package',
        hp: 525,
        zeroToSixty: 2.9,
        topSpeed: 186,
        priceDelta: 33520,
        description:
            'Carbon fiber roof, magnesium lightweight wheels, and anti-roll bars.',
      ),
    ],
    paints: [
      const PaintOption(
          id: 'shark_blue',
          name: 'Shark Blue',
          colorHex: 0xFF005EA6,
          price: 4220),
      const PaintOption(
          id: 'guards_red', name: 'Guards Red', colorHex: 0xFFD81E05, price: 0),
      const PaintOption(
          id: 'python_green',
          name: 'Python Green',
          colorHex: 0xFF35B000,
          price: 4220),
      const PaintOption(
          id: 'gt_silver',
          name: 'GT Silver Metallic',
          colorHex: 0xFFB8B8B8,
          price: 840),
    ],
    wheels: [
      const WheelOption(
          id: 'gt3_std',
          name: '20/21" GT3 RS Forged Lightweight',
          size: '20/21-inch',
          price: 0),
      const WheelOption(
          id: 'gt3_magnesium',
          name: '20/21" Weissach Magnesium',
          size: '20/21-inch',
          price: 12000),
    ],
    interiors: [
      const InteriorOption(
          id: 'race_tex_black',
          name: 'Race-Tex with Guards Red',
          colorHex: 0xFF1C1C1C,
          material: 'Race-Tex Microfiber',
          price: 0),
      const InteriorOption(
          id: 'leather_carbon',
          name: 'Black Leather & Carbon Bucket',
          colorHex: 0xFF111111,
          material: 'Carbon Full Bucket',
          price: 4700),
    ],
    packages: [
      const AddonPackage(
          id: 'pccb',
          name: 'Porsche Ceramic Composite Brakes (PCCB)',
          description: '410mm front ceramic discs with yellow calipers.',
          price: 10110),
      const AddonPackage(
          id: 'front_lift',
          name: 'Front Axle Hydraulic Lift System',
          description: 'Raises nose by 30mm for speedbumps and ramps.',
          price: 3670),
    ],
  ),

  // 3. 2025 BMW M8 Competition Coupe
  CarModel(
    id: 'bmw_m8',
    name: '2025 BMW M8 Competition Coupe',
    modelGlbPath: 'models/bmw_m8.glb',
    basePrice: 138800,
    trims: [
      const TrimOption(
        id: 'm8_competition',
        name: 'M8 Competition Coupe',
        hp: 617,
        zeroToSixty: 2.9,
        topSpeed: 190,
        priceDelta: 0,
        description: '4.4L BMW M TwinPower Turbo V-8 with M xDrive AWD.',
      ),
      const TrimOption(
        id: 'm8_track_spec',
        name: 'M8 M-Driver Performance Spec',
        hp: 625,
        zeroToSixty: 2.8,
        topSpeed: 195,
        priceDelta: 18500,
        description:
            'Includes M Driver Package top speed unlock & carbon intake.',
      ),
    ],
    paints: [
      const PaintOption(
          id: 'isle_of_man',
          name: 'Isle of Man Green',
          colorHex: 0xFF00563B,
          price: 0),
      const PaintOption(
          id: 'marina_bay',
          name: 'Marina Bay Blue Metallic',
          colorHex: 0xFF0047AB,
          price: 650),
      const PaintOption(
          id: 'dravit_grey',
          name: 'Dravit Grey Metallic',
          colorHex: 0xFF4A4E51,
          price: 1950),
      const PaintOption(
          id: 'sao_paulo',
          name: 'Sao Paulo Yellow',
          colorHex: 0xFFDFFF00,
          price: 650),
      const PaintOption(
          id: 'frozen_black',
          name: 'Frozen Black Metallic',
          colorHex: 0xFF121212,
          price: 3600),
      const PaintOption(
          id: 'alpine_white',
          name: 'Alpine White',
          colorHex: 0xFFF8F8F8,
          price: 0),
    ],
    wheels: [
      const WheelOption(
          id: 'm_star_spoke',
          name: '20" M Star-Spoke Bi-Color 813M',
          size: '20-inch',
          price: 0),
      const WheelOption(
          id: 'm_black_forged',
          name: '20" M Forged Black Double-Spoke 810M',
          size: '20-inch',
          price: 1300),
      const WheelOption(
          id: 'm_bronze_carbon',
          name: '20" M Performance Matte Bronze',
          size: '20-inch',
          price: 3800),
    ],
    interiors: [
      const InteriorOption(
          id: 'sakhir_orange',
          name: 'Sakhir Orange / Black Full Merino',
          colorHex: 0xFFC0392B,
          material: 'Full Merino Leather',
          price: 0),
      const InteriorOption(
          id: 'silverstone_leather',
          name: 'Silverstone Full Merino Leather',
          colorHex: 0xFFE0E0E0,
          material: 'Merino Leather',
          price: 0),
      const InteriorOption(
          id: 'taruma_brown',
          name: 'Taruma Brown Extended Merino',
          colorHex: 0xFF6E473B,
          material: 'Extended Leather',
          price: 1500),
      const InteriorOption(
          id: 'carbon_bucket',
          name: 'M Carbon Full Bucket Seats',
          colorHex: 0xFF1C1C1C,
          material: 'Carbon & Alcantara',
          price: 4500),
    ],
    packages: [
      const AddonPackage(
          id: 'm_carbon_exterior',
          name: 'M Carbon Exterior Package',
          description:
              'Carbon mirror caps, rear spoiler, front air curtains, and diffuser.',
          price: 5400),
      const AddonPackage(
          id: 'm_carbon_brakes',
          name: 'M Carbon Ceramic Brakes',
          description:
              'Gold-painted calipers with high-performance fade-free ceramic rotors.',
          price: 8500),
      const AddonPackage(
          id: 'bowers_wilkins',
          name: 'Bowers & Wilkins Diamond Surround',
          description:
              '16 speakers, 1400 watts with illuminated acoustic lenses.',
          price: 3400),
      const AddonPackage(
          id: 'driving_assist',
          name: 'Driving Assistance Professional',
          description:
              'Active cruise control, lane centering, and radar evasive assist.',
          price: 1700),
    ],
  ),

  // 4. 2024 Lamborghini Revuelto
  CarModel(
    id: 'lambo_revuelto',
    name: '2024 Lamborghini Revuelto V12',
    modelGlbPath: 'models/lamborghini_revuelto.glb',
    basePrice: 608358,
    trims: [
      const TrimOption(
        id: 'revuelto_base',
        name: 'Revuelto HPEV Hybrid V12',
        hp: 1001,
        zeroToSixty: 2.5,
        topSpeed: 217,
        priceDelta: 0,
        description:
            '6.5L Naturally Aspirated V12 paired with 3 electric motors.',
      ),
    ],
    paints: [
      const PaintOption(
          id: 'arancio_apodis',
          name: 'Arancio Apodis (Orange)',
          colorHex: 0xFFFF5F00,
          price: 0),
      const PaintOption(
          id: 'verde_mantis',
          name: 'Verde Mantis (Lime)',
          colorHex: 0xFF46C200,
          price: 4900),
      const PaintOption(
          id: 'giallo_auge',
          name: 'Giallo Auge (Yellow)',
          colorHex: 0xFFFFD300,
          price: 3800),
      const PaintOption(
          id: 'nero_nemesis',
          name: 'Nero Nemesis (Matte Black)',
          colorHex: 0xFF111215,
          price: 6200),
    ],
    wheels: [
      const WheelOption(
          id: 'lambo_forged',
          name: '21/22" Forged Monolock Alloy',
          size: '21/22-inch',
          price: 0),
      const WheelOption(
          id: 'lambo_carbon',
          name: '21/22" Matte Bronze Carbon',
          size: '21/22-inch',
          price: 8500),
    ],
    interiors: [
      const InteriorOption(
          id: 'corsa_tex',
          name: 'Corsa Tex & Leather Nero Ade',
          colorHex: 0xFF1A1A1A,
          material: 'Corsa Tex Hybrid',
          price: 0),
    ],
    packages: [
      const AddonPackage(
          id: 'titanium_exhaust',
          name: 'Titanium Lightweight Exhaust System',
          description: 'High-flow exhaust giving maximum acoustic resonance.',
          price: 14200),
    ],
  ),

  // 5. 2019 McLaren 720S Spider
  CarModel(
    id: 'mclaren_720s_spider',
    name: '2019 McLaren 720S Spider',
    modelGlbPath: 'models/mclaren_spider.glb',
    basePrice: 315000,
    trims: [
      const TrimOption(
        id: '720s_spider_base',
        name: '720S Spider Standard',
        hp: 710,
        zeroToSixty: 2.8,
        topSpeed: 212,
        priceDelta: 0,
        description:
            '4.0L M840T Twin-Turbo V8 with Retractable Hardtop & Carbon Monocage II-S.',
      ),
      const TrimOption(
        id: '720s_spider_performance',
        name: '720S Spider Performance Spec',
        hp: 720,
        zeroToSixty: 2.7,
        topSpeed: 215,
        priceDelta: 12130,
        description:
            'Engine bay ambient lighting, dark palladium exterior & sport exhaust.',
      ),
    ],
    paints: [
      const PaintOption(
          id: 'papaya_spark',
          name: 'Papaya Spark Metallic',
          colorHex: 0xFFFF5A00,
          price: 0),
      const PaintOption(
          id: 'belize_blue',
          name: 'Belize Blue',
          colorHex: 0xFF0077BE,
          price: 2450),
      const PaintOption(
          id: 'volcano_yellow',
          name: 'Volcano Yellow',
          colorHex: 0xFFFFCC00,
          price: 2450),
      const PaintOption(
          id: 'saros_grey',
          name: 'Saros Elite Grey',
          colorHex: 0xFF3D434A,
          price: 5270),
      const PaintOption(
          id: 'silica_white',
          name: 'Silica White',
          colorHex: 0xFFF5F5F5,
          price: 0),
    ],
    wheels: [
      const WheelOption(
          id: 'mclaren_5_spoke',
          name: '19/20" 5-Twin Spoke Sport Cast',
          size: '19/20-inch',
          price: 0),
      const WheelOption(
          id: 'mclaren_10_spoke',
          name: '19/20" 10-Spoke Super-Lightweight Forged',
          size: '19/20-inch',
          price: 5490),
      const WheelOption(
          id: 'mclaren_stealth',
          name: '19/20" Stealth Finish Ultra-Lightweight',
          size: '19/20-inch',
          price: 7800),
    ],
    interiors: [
      const InteriorOption(
          id: 'mclaren_carbon_black',
          name: 'Carbon Black Leather & Alcantara',
          colorHex: 0xFF1B1B1B,
          material: 'Alcantara / Nappa',
          price: 0),
      const InteriorOption(
          id: 'scoria_grey_orange',
          name: 'Scoria Grey with McLaren Orange Accents',
          colorHex: 0xFF35393D,
          material: 'Semi-Aniline Leather',
          price: 3600),
      const InteriorOption(
          id: 'vintage_tan',
          name: 'Luxury Vintage Tan Full Leather',
          colorHex: 0xFF8B5A2B,
          material: 'Luxury Grain Leather',
          price: 4400),
    ],
    packages: [
      const AddonPackage(
          id: 'electrochromic_roof',
          name: 'Electrochromic Glazed Glass Roof',
          description:
              'Variable tint roof panel with button-controlled opacity settings.',
          price: 9100),
      const AddonPackage(
          id: 'mclaren_carbon_pack_1',
          name: 'Carbon Fiber Primary Components',
          description:
              'Carbon fiber hood intakes, door mirror casings, and rear fender intakes.',
          price: 11000),
      const AddonPackage(
          id: 'mclaren_track_telemetry',
          name: 'McLaren Track Telemetry with 3 Cameras',
          description:
              'Real-time lap-time analysis and onboard camera HD recording.',
          price: 4300),
      const AddonPackage(
          id: 'mclaren_bowers',
          name: 'Bowers & Wilkins 12-Speaker High-End Audio',
          description:
              '1280W surround sound system tuned specifically for open-top driving.',
          price: 4420),
    ],
  ),

  // 6. 2022 Mercedes-Benz SL63 AMG
  CarModel(
    id: 'mercedes_sl63_amg',
    name: '2022 Mercedes-Benz SL63 AMG',
    modelGlbPath: 'models/mercedes_benz.glb',
    basePrice: 178100,
    trims: [
      const TrimOption(
        id: 'sl63_touring',
        name: 'SL 63 4MATIC+ Touring Spec',
        hp: 577,
        zeroToSixty: 3.3,
        topSpeed: 196,
        priceDelta: 0,
        description:
            'Handcrafted AMG 4.0L Biturbo V8 with AMG Performance 4MATIC+ AWD.',
      ),
      const TrimOption(
        id: 'sl63_performance',
        name: 'SL 63 4MATIC+ Performance Spec',
        hp: 585,
        zeroToSixty: 3.2,
        topSpeed: 198,
        priceDelta: 11500,
        description:
            'Adds AMG ACTIVE RIDE CONTROL hydraulic anti-roll and front axle lift.',
      ),
    ],
    paints: [
      const PaintOption(
          id: 'manufaktur_alpine_grey',
          name: 'MANUFAKTUR Alpine Grey',
          colorHex: 0xFF8E9296,
          price: 1750),
      const PaintOption(
          id: 'obsidian_black_metallic',
          name: 'Obsidian Black Metallic',
          colorHex: 0xFF101010,
          price: 0),
      const PaintOption(
          id: 'hyper_blue_metallic',
          name: 'Hyper Blue Metallic',
          colorHex: 0xFF005BC2,
          price: 750),
      const PaintOption(
          id: 'patagonia_red',
          name: 'MANUFAKTUR Patagonia Red Metallic',
          colorHex: 0xFF9E1B22,
          price: 1750),
      const PaintOption(
          id: 'monza_grey_magno',
          name: 'MANUFAKTUR Monza Grey Magno (Matte)',
          colorHex: 0xFF4A4E53,
          price: 3250),
      const PaintOption(
          id: 'sun_yellow', name: 'Sun Yellow', colorHex: 0xFFFFDF00, price: 0),
    ],
    wheels: [
      const WheelOption(
          id: 'amg_21_multispoke',
          name: '21" AMG Multi-Spoke Y-Design Matte Black',
          size: '21-inch',
          price: 0),
      const WheelOption(
          id: 'amg_21_forged_cross',
          name: '21" AMG Forged Cross-Spoke Bi-Color',
          size: '21-inch',
          price: 3300),
      const WheelOption(
          id: 'amg_21_monoblock',
          name: '21" AMG Monoblock Heritage Edition',
          size: '21-inch',
          price: 4500),
    ],
    interiors: [
      const InteriorOption(
          id: 'sienna_brown_nappa',
          name: 'Sienna Brown / Black Exclusive Nappa',
          colorHex: 0xFF6A3B22,
          material: 'Exclusive Nappa Leather',
          price: 0),
      const InteriorOption(
          id: 'red_pepper_nappa',
          name: 'Red Pepper / Black Exclusive Nappa',
          colorHex: 0xFF8A1C14,
          material: 'AMG Exclusive Nappa',
          price: 0),
      const InteriorOption(
          id: 'macchiato_beige',
          name: 'Macchiato Beige / Titanium Grey',
          colorHex: 0xFFD8C7B5,
          material: 'Diamond Quilted Nappa',
          price: 1500),
      const InteriorOption(
          id: 'amg_performance_seats',
          name: 'AMG Performance Bucket Seats in Black',
          colorHex: 0xFF141414,
          material: 'Nappa Leather & Microfiber',
          price: 2500),
    ],
    packages: [
      const AddonPackage(
          id: 'amg_carbon_package',
          name: 'AMG Carbon Fiber Package Exterior',
          description:
              'Carbon front splitter, side air-intake fins, and rear diffuser inlay.',
          price: 4500),
      const AddonPackage(
          id: 'amg_night_package_ii',
          name: 'AMG Night Package II (Dark Optics)',
          description:
              'Black chrome grille vanes, dark badging, and darkened lamp internals.',
          price: 1300),
      const AddonPackage(
          id: 'burmester_high_end_3d',
          name: 'Burmester High-End 3D Surround Sound',
          description:
              '17 speakers, 1220 watts with illuminated speakers and 3D subwoofers.',
          price: 4550),
      const AddonPackage(
          id: 'amg_ceramic_brakes',
          name: 'AMG High-Performance Ceramic Composite Brakes',
          description:
              'Bronze calipers with massive 402mm composite front carbon discs.',
          price: 8950),
    ],
  ),
];

class ConfiguratorState {
  final CarModel selectedCar;
  final String selectedTab;
  final TrimOption selectedTrim;
  final PaintOption selectedPaint;
  final String selectedFinish;
  final WheelOption selectedWheel;
  final InteriorOption selectedInterior;
  final Set<String> selectedPackageIds;
  final String cameraView;

  const ConfiguratorState({
    required this.selectedCar,
    required this.selectedTab,
    required this.selectedTrim,
    required this.selectedPaint,
    required this.selectedFinish,
    required this.selectedWheel,
    required this.selectedInterior,
    required this.selectedPackageIds,
    required this.cameraView,
  });

  int get horsePower => selectedTrim.hp;
  double get zeroToSixty => selectedTrim.zeroToSixty;
  int get topSpeed => selectedTrim.topSpeed;

  double get totalMSRP {
    double pkgTotal = 0;
    for (final pkg in selectedCar.packages) {
      if (selectedPackageIds.contains(pkg.id)) {
        pkgTotal += pkg.price;
      }
    }
    return selectedCar.basePrice +
        selectedTrim.priceDelta +
        selectedPaint.price +
        selectedWheel.price +
        selectedInterior.price +
        pkgTotal;
  }

  double get estFinanceMonthly {
    const double annualRate = 0.049;
    const int termMonths = 60;
    final double principal = totalMSRP * 0.85; // 15% Down Payment
    final double monthlyRate = annualRate / 12;
    final num = monthlyRate * _pow(1 + monthlyRate, termMonths);
    final denom = _pow(1 + monthlyRate, termMonths) - 1;
    return principal * (num / denom);
  }

  static double _pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  ConfiguratorState copyWith({
    CarModel? selectedCar,
    String? selectedTab,
    TrimOption? selectedTrim,
    PaintOption? selectedPaint,
    String? selectedFinish,
    WheelOption? selectedWheel,
    InteriorOption? selectedInterior,
    Set<String>? selectedPackageIds,
    String? cameraView,
  }) {
    return ConfiguratorState(
      selectedCar: selectedCar ?? this.selectedCar,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedTrim: selectedTrim ?? this.selectedTrim,
      selectedPaint: selectedPaint ?? this.selectedPaint,
      selectedFinish: selectedFinish ?? this.selectedFinish,
      selectedWheel: selectedWheel ?? this.selectedWheel,
      selectedInterior: selectedInterior ?? this.selectedInterior,
      selectedPackageIds: selectedPackageIds ?? this.selectedPackageIds,
      cameraView: cameraView ?? this.cameraView,
    );
  }
}

class ConfiguratorNotifier extends StateNotifier<ConfiguratorState> {
  ConfiguratorNotifier()
      : super(ConfiguratorState(
          selectedCar: availableCarsCatalog[0], // Defaults to Ferrari Roma
          selectedTab: '2 Paint',
          selectedTrim: availableCarsCatalog[0].trims[0],
          selectedPaint: availableCarsCatalog[0].paints[0],
          selectedFinish: 'Metallic',
          selectedWheel: availableCarsCatalog[0].wheels[0],
          selectedInterior: availableCarsCatalog[0].interiors[0],
          selectedPackageIds: {'carbon_pack'},
          cameraView: 'Front 3/4',
        ));

  void selectCar(CarModel car) {
    state = ConfiguratorState(
      selectedCar: car,
      selectedTab: state.selectedTab,
      selectedTrim: car.trims[0],
      selectedPaint: car.paints[0],
      selectedFinish: state.selectedFinish,
      selectedWheel: car.wheels[0],
      selectedInterior: car.interiors[0],
      selectedPackageIds: {},
      cameraView: state.cameraView,
    );
  }

  void setTab(String tab) => state = state.copyWith(selectedTab: tab);
  void setTrim(TrimOption trim) => state = state.copyWith(selectedTrim: trim);
  void setPaint(PaintOption paint) =>
      state = state.copyWith(selectedPaint: paint);
  void setFinish(String finish) =>
      state = state.copyWith(selectedFinish: finish);
  void setWheel(WheelOption wheel) =>
      state = state.copyWith(selectedWheel: wheel);
  void setInterior(InteriorOption interior) =>
      state = state.copyWith(selectedInterior: interior);

  void togglePackage(String pkgId) {
    final current = Set<String>.from(state.selectedPackageIds);
    if (current.contains(pkgId)) {
      current.remove(pkgId);
    } else {
      current.add(pkgId);
    }
    state = state.copyWith(selectedPackageIds: current);
  }

  void setCameraView(String view) => state = state.copyWith(cameraView: view);
}

final configuratorProvider =
    StateNotifierProvider<ConfiguratorNotifier, ConfiguratorState>((ref) {
  return ConfiguratorNotifier();
});
