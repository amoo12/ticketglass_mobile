import 'dart:convert';

import 'package:ticketglass_mobile/src/models/ticketType.dart';

class Event {
  String? id;
  String? organizerId;
  String eventName;
  String? description;
  String? venueName;
  String? address;
  String? city;
  String? area;
  int? numberOfAttendees;
  String startDate;
  String endDate;
  String bookingStartDate;
  String bookingEndDate;
  int? orderTime;
  String? txId;
  int? ticketsSold;
  List<TicketType>? tickets;
  String? maxTickets;
  String? imageUrl;
  Event({
    this.id,
    this.organizerId,
    required this.eventName,
    this.description,
    this.venueName,
    this.address,
    this.city,
    this.area,
    this.numberOfAttendees,
    required this.startDate,
    required this.endDate,
    required this.bookingStartDate,
    required this.bookingEndDate,
    this.orderTime,
    this.txId,
    this.ticketsSold,
    this.tickets,
    this.maxTickets,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organizerId': organizerId,
      'eventName': eventName,
      'description': description,
      'venueName': venueName,
      'address': address,
      'city': city,
      'area': area,
      'numberOfAttendees': numberOfAttendees,
      'startDate': startDate,
      'endDate': endDate,
      'bookingStartDate': bookingStartDate,
      'bookingEndDate': bookingEndDate,
      'orderTime': orderTime,
      'txId': txId,
      'ticketsSold': ticketsSold,
      'tickets': tickets?.map((x) => x.toMap()).toList(),
      'maxTickets': maxTickets,
      'imageUrl': imageUrl,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      organizerId: map['organizerId'],
      eventName: map['eventName'],
      description: map['description'],
      venueName: map['venueName'],
      address: map['address'],
      city: map['city'],
      area: map['area'],
      numberOfAttendees: int.parse(map['numberOfAttendees']),
      startDate: map['startDate'],
      endDate: map['endDate'],
      bookingStartDate: map['bookingStartDate'],
      bookingEndDate: map['bookingEndDate'],
      orderTime: map['orderTime'],
      txId: map['txId'],
      ticketsSold: map['ticketsSold'] ?? 0,
      tickets: map['tickets'] != null
          ? List<TicketType>.from(
              map['tickets']?.map((x) => TicketType.fromMap(x)))
          : null,
      maxTickets: map['maxTickets'].toString(),
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}
