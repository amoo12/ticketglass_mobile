import 'dart:convert';

class TicketType {
  String? name;
  String? description;
  String? price;
  String? quantity;
  String? id;

  TicketType({
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'id': id,
    };
  }

  factory TicketType.fromMap(Map<String, dynamic> map) {
    return TicketType(
      name: map['name'],
      description: map['description'],
      price: map['price'],
      quantity: map['quantity'].toString(),
      id: map['id'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketType.fromJson(String source) =>
      TicketType.fromMap(json.decode(source));
}
