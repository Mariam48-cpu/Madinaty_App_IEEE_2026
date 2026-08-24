import 'package:latlong2/latlong.dart';
import 'known_location.dart';

class InitialLocationSeedData {
  final String id;
  final String name;
  final LatLng center;
  final double radiusInMeters;
  final List<SeedCafeData> cafes;

  const InitialLocationSeedData({
    required this.id,
    required this.name,
    required this.center,
    required this.radiusInMeters,
    required this.cafes,
  });
}

class SeedCafeData {
  final String id;
  final String name;
  final String address;
  final double latitudeOffset;
  final double longitudeOffset;
  final double rating;
  final int reviewsCount;
  final bool isOpen;
  final String description;
  final String openingHours;
  final List<String> attributes;
  final String imageUrl;
  final List<SeedMenuCategoryData> menuCategories;

  const SeedCafeData({
    required this.id,
    required this.name,
    required this.address,
    required this.latitudeOffset,
    required this.longitudeOffset,
    required this.rating,
    required this.reviewsCount,
    required this.isOpen,
    required this.description,
    required this.openingHours,
    required this.attributes,
    required this.imageUrl,
    required this.menuCategories,
  });
}

class SeedMenuCategoryData {
  final String id;
  final String name;
  final List<SeedProductData> products;

  const SeedMenuCategoryData({
    required this.id,
    required this.name,
    required this.products,
  });
}

class SeedProductData {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> options;

  const SeedProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.options = const [],
  });
}

String cafeImageUrl(int globalCafeIndex) {
  return 'https://loremflickr.com/1200/800/cafe,coffee-shop?lock=$globalCafeIndex';
}

const hotCoffeeImages = <String>[
  'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1512568400610-62da28bc8a13?auto=format&fit=crop&w=800&q=80',
];

const coldDrinkImages = <String>[
  'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1521305916504-4a1121188589?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=800&q=80',
];

const foodImages = <String>[
  'https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1547573854-74d3a0e7e5a5?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=80',
];

const dessertImages = <String>[
  'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1606313564200-e75d5e30476e?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=800&q=80',
  'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=800&q=80',
];

const hotCoffeeNames = <String>[
  'Classic Latte',
  'Spanish Latte',
  'Caramel Macchiato',
  'Cappuccino',
  'Flat White',
  'Mocha',
];

const coldDrinkNames = <String>[
  'Iced Latte',
  'Iced Spanish Latte',
  'Iced Mocha',
  'Vanilla Cold Brew',
  'Iced Caramel Macchiato',
  'Classic Frappuccino',
];

const foodNames = <String>[
  'Chicken Croissant',
  'Turkey Sandwich',
  'Chicken Wrap',
  'Club Sandwich',
  'Beef Burger',
  'Pasta Alfredo',
];

const dessertNames = <String>[
  'Lotus Cheesecake',
  'Chocolate Cake',
  'Brownie',
  'Tiramisu',
  'Cinnamon Roll',
  'Waffle',
];

SeedProductData createProduct({
  required String cafeId,
  required String categoryId,
  required int productIndex,
  required String name,
  required double price,
  required String imageUrl,
  required String description,
  List<String> options = const ['Regular', 'Large'],
}) {
  return SeedProductData(
    id: '${cafeId}_${categoryId}_${(productIndex + 1).toString().padLeft(2, '0')}',
    name: name,
    description: description,
    price: price,
    imageUrl: imageUrl,
    options: options,
  );
}

List<SeedMenuCategoryData> buildMenu({
  required String cafeId,
  required int cafeIndex,
}) {
  final menuVariation = cafeIndex % 6;

  final hotCoffee = <SeedProductData>[
    createProduct(
      cafeId: cafeId,
      categoryId: 'hot_coffee',
      productIndex: 0,
      name: hotCoffeeNames[menuVariation],
      price: 70 + (cafeIndex % 4) * 5,
      imageUrl: hotCoffeeImages[menuVariation],
      description: 'Rich and freshly prepared coffee.',
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'hot_coffee',
      productIndex: 1,
      name: hotCoffeeNames[(menuVariation + 1) % 6],
      price: 80 + (cafeIndex % 4) * 5,
      imageUrl: hotCoffeeImages[(menuVariation + 1) % 6],
      description: 'Smooth coffee with a creamy finish.',
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'hot_coffee',
      productIndex: 2,
      name: hotCoffeeNames[(menuVariation + 2) % 6],
      price: 85 + (cafeIndex % 3) * 5,
      imageUrl: hotCoffeeImages[(menuVariation + 2) % 6],
      description: 'A signature cafe favorite.',
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'hot_coffee',
      productIndex: 3,
      name: hotCoffeeNames[(menuVariation + 3) % 6],
      price: 75 + (cafeIndex % 4) * 5,
      imageUrl: hotCoffeeImages[(menuVariation + 3) % 6],
      description: 'Freshly brewed and served warm.',
    ),
  ];

  final coldDrinks = <SeedProductData>[
    createProduct(
      cafeId: cafeId,
      categoryId: 'cold_drinks',
      productIndex: 0,
      name: coldDrinkNames[menuVariation],
      price: 85 + (cafeIndex % 4) * 5,
      imageUrl: coldDrinkImages[menuVariation],
      description: 'Chilled, refreshing and freshly prepared.',
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'cold_drinks',
      productIndex: 1,
      name: coldDrinkNames[(menuVariation + 1) % 6],
      price: 90 + (cafeIndex % 3) * 5,
      imageUrl: coldDrinkImages[(menuVariation + 1) % 6],
      description: 'A refreshing cold coffee favorite.',
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'cold_drinks',
      productIndex: 2,
      name: coldDrinkNames[(menuVariation + 2) % 6],
      price: 95 + (cafeIndex % 4) * 5,
      imageUrl: coldDrinkImages[(menuVariation + 2) % 6],
      description: 'Cold and creamy with a balanced flavor.',
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'cold_drinks',
      productIndex: 3,
      name: coldDrinkNames[(menuVariation + 3) % 6],
      price: 100 + (cafeIndex % 3) * 5,
      imageUrl: coldDrinkImages[(menuVariation + 3) % 6],
      description: 'Perfect for a refreshing break.',
    ),
  ];

  final food = <SeedProductData>[
    createProduct(
      cafeId: cafeId,
      categoryId: 'food',
      productIndex: 0,
      name: foodNames[menuVariation],
      price: 120 + (cafeIndex % 5) * 10,
      imageUrl: foodImages[menuVariation],
      description: 'Freshly prepared and served warm.',
      options: const [],
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'food',
      productIndex: 1,
      name: foodNames[(menuVariation + 1) % 6],
      price: 135 + (cafeIndex % 4) * 10,
      imageUrl: foodImages[(menuVariation + 1) % 6],
      description: 'A delicious cafe meal prepared fresh.',
      options: const [],
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'food',
      productIndex: 2,
      name: foodNames[(menuVariation + 2) % 6],
      price: 145 + (cafeIndex % 4) * 10,
      imageUrl: foodImages[(menuVariation + 2) % 6],
      description: 'Fresh ingredients with a satisfying taste.',
      options: const [],
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'food',
      productIndex: 3,
      name: foodNames[(menuVariation + 3) % 6],
      price: 155 + (cafeIndex % 5) * 10,
      imageUrl: foodImages[(menuVariation + 3) % 6],
      description: 'A hearty choice for any time of day.',
      options: const [],
    ),
  ];

  final desserts = <SeedProductData>[
    createProduct(
      cafeId: cafeId,
      categoryId: 'desserts',
      productIndex: 0,
      name: dessertNames[menuVariation],
      price: 85 + (cafeIndex % 4) * 5,
      imageUrl: dessertImages[menuVariation],
      description: 'A sweet treat prepared with care.',
      options: const [],
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'desserts',
      productIndex: 1,
      name: dessertNames[(menuVariation + 1) % 6],
      price: 90 + (cafeIndex % 3) * 5,
      imageUrl: dessertImages[(menuVariation + 1) % 6],
      description: 'Rich, delicious and perfect with coffee.',
      options: const [],
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'desserts',
      productIndex: 2,
      name: dessertNames[(menuVariation + 2) % 6],
      price: 80 + (cafeIndex % 4) * 5,
      imageUrl: dessertImages[(menuVariation + 2) % 6],
      description: 'A freshly prepared sweet specialty.',
      options: const [],
    ),
    createProduct(
      cafeId: cafeId,
      categoryId: 'desserts',
      productIndex: 3,
      name: dessertNames[(menuVariation + 3) % 6],
      price: 95 + (cafeIndex % 3) * 5,
      imageUrl: dessertImages[(menuVariation + 3) % 6],
      description: 'A perfect sweet ending to your visit.',
      options: const [],
    ),
  ];

  return [
    SeedMenuCategoryData(
      id: 'hot_coffee',
      name: 'Hot Coffee',
      products: hotCoffee,
    ),
    SeedMenuCategoryData(
      id: 'cold_drinks',
      name: 'Cold Drinks',
      products: coldDrinks,
    ),
    SeedMenuCategoryData(id: 'food', name: 'Food', products: food),
    SeedMenuCategoryData(id: 'desserts', name: 'Desserts', products: desserts),
  ];
}

const cafeNames = <String>[
  'Moonlight Cafe',
  'Velvet Coffee',
  'Roastery House',
  'The Cozy Cup',
  'Bean & Bloom',
  'Luna Cafe',
  'Urban Brew',
  'Golden Mug',
  'Mellow Coffee',
  'The Coffee Room',
  'Daily Brew',
  'Cloud Cafe',
  'Oak Coffee',
  'Amber Cafe',
  'Garden Cup',
  'Canvas Coffee',
  'Ritual Cafe',
  'Palm Brew',
  'Haven Coffee',
  'Dawn Cafe',
  'Mosaic Coffee',
  'Terrace Cafe',
  'Corner Brew',
  'Vista Coffee',
  'Nook Cafe',
  'Sips Cafe',
  'Cedar Coffee',
  'Bloom Cafe',
  'Route Coffee',
  'Cozy Corner',
];

SeedCafeData buildCafe({
  required String locationId,
  required String locationName,
  required int index,
  required int globalCafeIndex,
}) {
  final number = index + 1;

  final cafeId = '${locationId}_cafe_${number.toString().padLeft(2, '0')}';

  final baseName = cafeNames[index % cafeNames.length];

  final areaTag = locationId == 'bagour_menoufia'
      ? 'Bagour'
      : locationId == 'banha_qalyubia'
      ? 'Banha'
      : locationId == 'cairo'
      ? 'Cairo'
      : 'Giza';

  final name = '$baseName $areaTag';

  final latOffset = ((index % 6) - 2.5) * 0.004;
  final lngOffset = (((index * 2) % 7) - 3) * 0.004;

  return SeedCafeData(
    id: cafeId,
    name: name,
    address: '$locationName - Street $number',
    latitudeOffset: latOffset,
    longitudeOffset: lngOffset,

    rating: 4.0 + ((index % 10) / 10),
    reviewsCount: 80 + (index * 37),

    isOpen: index % 7 != 0,

    description:
        '$name is a cozy local cafe offering freshly prepared coffee, cold drinks, food and desserts.',

    openingHours: 'Every day 09:00 AM - 12:00 AM',

    attributes: <String>[
      'Wi-Fi',
      if (index % 2 == 0) 'Outdoor Seating',
      if (index % 3 == 0) 'Family Friendly',
      if (index % 4 == 0) 'Quiet',
    ],

    imageUrl: cafeImageUrl(globalCafeIndex),
    menuCategories: buildMenu(cafeId: cafeId, cafeIndex: globalCafeIndex - 1),
  );
}

List<InitialLocationSeedData> buildInitialLocationSeedData() {
  return knownLocations
      .asMap()
      .entries
      .map((entry) {
        final locationIndex = entry.key;
        final location = entry.value;
        return InitialLocationSeedData(
          id: location.id,
          name: location.name,
          center: location.center,
          radiusInMeters: location.radiusInMeters,
          cafes: List.generate(30, (index) {
            return buildCafe(
              locationId: location.id,
              locationName: location.name,
              index: index,
              globalCafeIndex: (locationIndex * 30) + index + 1,
            );
          }),
        );
      })
      .toList(growable: false);
}
