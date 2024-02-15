import 'package:flutter/foundation.dart';

class BookingModel {
  final String id;
  final String requester;
  final String itemId;
  final String itemOwner;
  final String itemName; // New field
  final DateTime bookingStart;
  final DateTime bookingEnd;
  final String bookingStatus;

  BookingModel({
    required this.id,
    required this.requester,
    required this.itemId,
    required this.itemOwner,
    required this.itemName, // Updated constructor
    required this.bookingStart,
    required this.bookingEnd,
    required this.bookingStatus,
  });

  BookingModel copyWith({
    String? id,
    String? requester,
    String? itemId,
    String? itemOwner,
    String? itemName, // Updated copyWith method
    DateTime? bookingStart,
    DateTime? bookingEnd,
    String? bookingStatus,
  }) {
    return BookingModel(
      id: id ?? this.id,
      requester: requester ?? this.requester,
      itemId: itemId ?? this.itemId,
      itemOwner: itemOwner ?? this.itemOwner,
      itemName: itemName ?? this.itemName,
      bookingStart: bookingStart ?? this.bookingStart,
      bookingEnd: bookingEnd ?? this.bookingEnd,
      bookingStatus: bookingStatus ?? this.bookingStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requester': requester,
      'itemId': itemId,
      'itemOwner': itemOwner,
      'itemName': itemName, // Updated toMap method
      'bookingStart': bookingStart.millisecondsSinceEpoch,
      'bookingEnd': bookingEnd.millisecondsSinceEpoch,
      'bookingStatus': bookingStatus,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      requester: map['requester'] ?? '',
      itemId: map['itemId'] ?? '',
      itemOwner: map['itemOwner'] ?? '',
      itemName: map['itemName'] ?? '', // Updated fromMap method
      //datetime needs to be converted back from timestamp firebase
      bookingStart: DateTime.fromMillisecondsSinceEpoch(map['bookingStart']),
      bookingEnd: DateTime.fromMillisecondsSinceEpoch(map['bookingEnd']),
      bookingStatus: map['bookingStatus'] ?? '',
    );
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, requester: $requester, itemId: $itemId, itemOwner: $itemOwner, itemName: $itemName, bookingStart: $bookingStart, bookingEnd: $bookingEnd, bookingStatus: $bookingStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingModel &&
        other.id == id &&
        other.requester == requester &&
        other.itemId == itemId &&
        other.itemOwner == itemOwner &&
        other.itemName == itemName && // Updated equality check
        other.bookingStart == bookingStart &&
        other.bookingEnd == bookingEnd &&
        other.bookingStatus == bookingStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    requester.hashCode ^
    itemId.hashCode ^
    itemOwner.hashCode ^
    itemName.hashCode ^ // Updated hashCode calculation
    bookingStart.hashCode ^
    bookingEnd.hashCode ^
    bookingStatus.hashCode;
  }
}