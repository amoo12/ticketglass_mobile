import 'dart:convert';

import 'package:ticketglass_mobile/src/models/ticketType.dart';

class Order {
  String eventId;
  String? orderId;
  int? orderTime;
  List<int>? quantities;
  List<Item>? items;
  double? totalPrice;
  String? txId;
  String? userId;
  Order({
    required this.eventId,
    this.orderId,
    this.orderTime,
    this.quantities,
    this.items,
    this.totalPrice,
    this.txId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'orderId': orderId,
      'orderTime': orderTime,
      'quantities': quantities,
      'items': items?.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'txId': txId,
      'userId': userId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    // if (map != null) {
    return Order(
      eventId: map['eventId'],
      orderId: map['orderId'],
      orderTime: map['orderTime']?.toInt(),
      quantities: List<int>.from(map['quantities']),
      items: map['items'] != null
          ? List<Item>.from(map['items']?.map((x) => Item.fromMap(x)))
          : null,
      totalPrice: map['totalPrice']?.toDouble(),
      txId: map['txId'],
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

class Item {
  TicketType? ticketType;
  double? price; //* price at the time of order
  String? nftIndex;

  Item({
    this.ticketType,
    this.price,
    this.nftIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'ticketType': ticketType?.toMap(),
      'price': price,
      'nftIndex': nftIndex,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      ticketType: map['ticketType'] != null
          ? TicketType.fromMap(map['ticketType'])
          : null,
      price: double.parse(map['price']),
      nftIndex: map['nftIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}
