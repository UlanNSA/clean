class BodyTypeIconAssets {
  BodyTypeIconAssets._();

  static const String cabriolet = 'assets/cars/icon-convertibles.svg';
  static const String coupe = 'assets/cars/icon-coupes.svg';
  static const String flat = 'assets/cars/flat-svgrepo-com.svg';
  static const String house = 'assets/cars/house-svgrepo-com.svg';
  static const String crossovers = 'assets/cars/icon-crossovers.svg';
  static const String hotel = 'assets/cars/hotel-room-svgrepo-com.svg';
  static const String wagons = 'assets/cars/icon-wagons.svg';
  static const String hatchback = 'assets/cars/icon-electric-vehicles.svg';

  static String getBodyTypeAssetByName(String name) {
    switch (name) {
      case 'House':
        return house;
      case 'Flat':
        return flat;
      case 'Room':
        return hotel;
    }
    return house;
  }
}
