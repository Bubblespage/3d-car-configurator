class CarModel {
  final String id;
  final String name;
  final String modelGlbPath;
  final double basePrice;
  final List<TrimOption> trims;
  final List<PaintOption> paints;
  final List<WheelOption> wheels;
  final List<InteriorOption> interiors;
  final List<AddonPackage> packages;

  const CarModel({
    required this.id,
    required this.name,
    required this.modelGlbPath,
    required this.basePrice,
    required this.trims,
    required this.paints,
    required this.wheels,
    required this.interiors,
    required this.packages,
  });
}

class TrimOption {
  final String id;
  final String name;
  final int hp;
  final double zeroToSixty;
  final int topSpeed;
  final double priceDelta;
  final String description;

  const TrimOption({
    required this.id,
    required this.name,
    required this.hp,
    required this.zeroToSixty,
    required this.topSpeed,
    required this.priceDelta,
    required this.description,
  });
}

class PaintOption {
  final String id;
  final String name;
  final int colorHex;
  final double price;

  const PaintOption({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.price,
  });
}

class WheelOption {
  final String id;
  final String name;
  final double price;
  final String size;

  const WheelOption({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
  });
}

class InteriorOption {
  final String id;
  final String name;
  final int colorHex;
  final String material;
  final double price;

  const InteriorOption({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.material,
    required this.price,
  });
}

class AddonPackage {
  final String id;
  final String name;
  final String description;
  final double price;

  const AddonPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}