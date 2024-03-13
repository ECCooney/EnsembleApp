class BookingModel {
  final String id;
  final String requester;
  final String itemId;
  final String itemOwner;
  final String itemName; // New field
  final String pickupLocation; // New field
  final String pickupTime; // New field
  final String dropoffTime; // New field
  late final DateTime bookingStart;
  late final DateTime bookingEnd;
  final String bookingStatus;

  BookingModel({
    required this.id,
    required this.requester,
    required this.itemId,
    required this.itemOwner,
    required this.itemName, // Updated constructor
    required this.pickupLocation, // New field
    required this.pickupTime, // New field
    required this.dropoffTime, // New field
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
    String? pickupLocation, // New field
    String? pickupTime, // New field
    String? dropoffTime, // New field
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
      pickupLocation: pickupLocation ?? this.pickupLocation, // New field
      pickupTime: pickupTime ?? this.pickupTime, // New field
      dropoffTime: dropoffTime ?? this.dropoffTime, // New field
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
      'pickupLocation': pickupLocation, // New field
      'pickupTime': pickupTime,// New field
      'dropoffTime': dropoffTime, // New field
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
      itemName: map['itemName'] ?? '',
      pickupLocation: map['pickupLocation'] ?? '', // New field
      pickupTime: map['pickupTime'] ?? '',
      dropoffTime: map['dropoffTime'] ?? '', // New field
      //datetime needs to be converted back from timestamp firebase
      bookingStart: DateTime.fromMillisecondsSinceEpoch(map['bookingStart']),
      bookingEnd: DateTime.fromMillisecondsSinceEpoch(map['bookingEnd']),
      bookingStatus: map['bookingStatus'] ?? '',
    );
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, requester: $requester, itemId: $itemId, itemOwner: $itemOwner, itemName: $itemName, pickupLocation: $pickupLocation, pickupTime: $pickupTime, dropoffTime: $dropoffTime, bookingStart: $bookingStart, bookingEnd: $bookingEnd, bookingStatus: $bookingStatus)';
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
        other.pickupLocation == pickupLocation && // New field
        other.pickupTime == pickupTime && // New field
        other.dropoffTime == dropoffTime && // New field
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
    itemName.hashCode ^
    pickupLocation.hashCode ^ // New field
    pickupTime.hashCode ^ // New field
    dropoffTime.hashCode ^ // New field
    bookingStart.hashCode ^
    bookingEnd.hashCode ^
    bookingStatus.hashCode;
  }
}