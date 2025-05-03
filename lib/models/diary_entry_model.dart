import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  String id;
  String userId;
  DateTime date;
  String description;
  int rating;
  List<String> imageUrls; 

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.description,
    required this.rating,
    this.imageUrls = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'description': description,
      'rating': rating,
      'imageUrls': imageUrls,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map, String docId) {
    return DiaryEntry(
      id: docId,
      userId: map['userId'],
      date: (map['date'] as Timestamp).toDate(),
      description: map['description'],
      rating: map['rating'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}
