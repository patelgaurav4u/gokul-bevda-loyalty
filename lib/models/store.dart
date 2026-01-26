// lib/models/store.dart
class Store {
  final String id;
  final String name;
  final String address;
  final String hours;
  final String phone;
  final String stock;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.hours,
    required this.phone,
    required this.stock,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: (json['id'] ?? json['StoreId']) as String? ?? '',
      name: (json['name'] ?? json['Storename']) as String? ?? '',
      address: (json['address'] ?? json['Storeaddress']) as String? ?? '',
      hours: (json['hours'] ?? json['Storetime']) as String? ?? '',
      phone: (json['phone'] ?? json['Storephone']) as String? ?? '',
      stock: (json['stock'] ?? '') as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'hours': hours,
      'phone': phone,
      'stock': stock,
    };
  }
}
