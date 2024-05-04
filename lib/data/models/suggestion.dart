class SuggestionModel {
  final String userImage;
  final String userName;
  final String userId;
  final String sentTime;
  final String placeName;
  final String location;
  final String locationDescription;
  final String userPhone;
  final String id;

  SuggestionModel({
    required this.userImage,
    required this.userName,
    required this.userId,
    required this.sentTime,
    required this.placeName,
    required this.location,
    required this.locationDescription,
    required this.userPhone,
    required this.id
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
        userImage: json['userImage'] ?? '',
        userName: json['userName'] ?? '',
        userId: json['userId'] ?? '',
        sentTime: json['sentTime'] ?? '',
        placeName: json['placeName'] ?? '',
        location: json['location'] ?? '',
        locationDescription: json['locationDescription'] ?? '',
        userPhone: json['userPhone'] ?? '',
        id: json ['id']??''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userImage': userImage,
      'userName': userName,
      'userId': userId,
      'sentTime': sentTime,
      'placeName': placeName,
      'location': location,
      'locationDescription': locationDescription,
      'userPhone': userPhone,
      'id': id,
    };
  }
}
