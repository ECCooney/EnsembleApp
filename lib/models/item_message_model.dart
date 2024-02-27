import 'package:flutter/foundation.dart';

class ItemMessageModel {
  final String senderName;
  final String senderId; // New field
  final String itemId;
  final String id;
  final String text;
  final String subject;
  final String bookingID;

  ItemMessageModel({
    required this.senderName,
    required this.senderId, // Updated constructor
    required this.itemId,
    required this.id,
    required this.text,
    required this.subject,
    required this.bookingID,
  });

  ItemMessageModel copyWith({
    String? senderName,
    String? senderId,
    String? itemId,
    String? id,
    String? text,
    String? subject,
    String? bookingID,
  }) {
    return ItemMessageModel(
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      itemId: itemId ?? this.itemId,
      id: id ?? this.id,
      text: text ?? this.text,
      subject: subject ?? this.subject,
      bookingID: bookingID ?? this.bookingID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderId': senderId, // Added toMap
      'itemId': itemId,
      'id': id,
      'text': text,
      'subject': subject,
      'bookingID': bookingID,
    };
  }

  factory ItemMessageModel.fromMap(Map<String, dynamic> map) {
    return ItemMessageModel(
      senderName: map['senderName'] ?? '',
      senderId: map['senderId'] ?? '', // Added fromMap
      itemId: map['itemId'] ?? '',
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      subject: map['subject'] ?? '',
      bookingID: map['bookingID'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ItemMessageModel(senderName: $senderName, senderId: $senderId, itemId: $itemId, id: $id, text: $text, subject: $subject, bookingID: $bookingID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemMessageModel &&
        other.senderName == senderName &&
        other.senderId == senderId &&
        other.itemId == itemId &&
        other.id == id &&
        other.text == text &&
        other.subject == subject &&
        other.bookingID == bookingID;
  }

  @override
  int get hashCode {
    return senderName.hashCode ^
    senderId.hashCode ^
    itemId.hashCode ^
    id.hashCode ^
    text.hashCode ^
    subject.hashCode ^
    bookingID.hashCode;
  }
}