class DatabaseModel {
  final int? id;
  final String name;
  final String dec;
  final String phone;
  final String address;

  DatabaseModel(
      {this.id,
      required this.name,
      required this.dec,
      required this.phone,
      required this.address});
}
