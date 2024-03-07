import 'package:flutter/foundation.dart';

class MessageModel {
  final String senderName;
  final String senderId;
  final String groupId;
  final String id;
  final String text;
  final String subject;
  final bool isRead;
  final String? response; // New field
  final DateTime sentAt; // New field

  MessageModel({
    required this.senderName,
    required this.senderId,
    required this.groupId,
    required this.id,
    required this.text,
    required this.subject,
    this.isRead = false,
    this.response, // Added response field
    required this.sentAt, // Added sentAt field
  });

  MessageModel copyWith({
    String? senderName,
    String? senderId,
    String? groupId,
    String? id,
    String? text,
    String? subject,
    bool? isRead,
    String? response, // Added response parameter
    DateTime? sentAt, // Added sentAt parameter
  }) {
    return MessageModel(
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      groupId: groupId ?? this.groupId,
      id: id ?? this.id,
      text: text ?? this.text,
      subject: subject ?? this.subject,
      isRead: isRead ?? this.isRead,
      response: response ?? this.response, // Updated copyWith
      sentAt: sentAt ?? this.sentAt, // Updated copyWith
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderId': senderId,
      'groupId': groupId,
      'id': id,
      'text': text,
      'subject': subject,
      'isRead': isRead,
      'response': response, // Added response to the map
      'sentAt': sentAt.toIso8601String(), // Added sentAt to the map
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderName: map['senderName'] ?? '',
      senderId: map['senderId'] ?? '',
      groupId: map['groupId'] ?? '',
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      subject: map['subject'] ?? '',
      isRead: map['isRead'] ?? false,
      response: map['response'], // Added response from map
      sentAt: DateTime.parse(map['sentAt']), // Added sentAt from map
    );
  }

  @override
  String toString() {
    return 'MessageModel(senderName: $senderName, senderId: $senderId, groupId: $groupId, id: $id, text: $text, subject: $subject, isRead: $isRead, response: $response, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.senderName == senderName &&
        other.senderId == senderId &&
        other.groupId == groupId &&
        other.id == id &&
        other.text == text &&
        other.subject == subject &&
        other.isRead == isRead &&
        other.response == response &&
        other.sentAt == sentAt; // Added sentAt comparison
  }

  @override
  int get hashCode {
    return senderName.hashCode ^
    senderId.hashCode ^
    groupId.hashCode ^
    id.hashCode ^
    text.hashCode ^
    subject.hashCode ^
    isRead.hashCode ^
    response.hashCode ^
    sentAt.hashCode; // Added sentAt hashCode
  }
}