import '../../core/constants/firebase_field_names.dart';

class UserSuggestion {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String type;

  const UserSuggestion({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.type,
  });

  factory UserSuggestion.fromJson(Map<String, dynamic> json) => UserSuggestion(
        id: json[FirebaseFieldNames.userSuggestionId],
        name: json[FirebaseFieldNames.userSuggestionName],
        address: json[FirebaseFieldNames.userSuggestionAddress],
        phone: json[FirebaseFieldNames.userSuggestionPhone],
        type: json[FirebaseFieldNames.userSuggestionType],
      );

  Map<String, dynamic> toJson() => {
      FirebaseFieldNames.userSuggestionId: id,
      FirebaseFieldNames.userSuggestionName: name,
      FirebaseFieldNames.userSuggestionAddress: address,
      FirebaseFieldNames.userSuggestionPhone: phone,
      FirebaseFieldNames.userSuggestionType: type,
    };
}
