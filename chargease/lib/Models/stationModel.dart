class Station {
  final String name;
  final String ownerName;
  final String ownerId;
  final String Contact;
  final int slots;
  final double price;
  final Map<String, Map<String, int>> availability;
  final double latitude;
  final double longitude;
  final String location;

  Station({
    required this.name,
    required this.ownerName,
    required this.ownerId,
    required this.Contact,
    required this.slots,
    required this.price,
    required this.availability,
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['Name'] ?? '',
      ownerName: json['OwnerName'] ?? '',
      ownerId: json['OwnerId'] ?? '',
      Contact: json['Contact'] ?? '',
      slots: json['Slots'] ?? 0,
      price: json['Price'] ?? 0.0,
      availability: json['Availability'] != null
          ? Map<String, Map<String, int>>.from(json['Availability'])
          : {},
      latitude: json['Latitude'] ?? 0.0,
      longitude: json['Longitude'] ?? 0.0,
      location: json['Location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'OwnerName': ownerName,
      'OwnerId': ownerId,
      'Contact': Contact,
      'Slots': slots,
      'Price': price,
      'Availability': availability,
      'Latitude': latitude,
      'Longitude': longitude,
      'Location': location,
    };
  }
}
