import 'dart:convert';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/place.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my-database.db');
    return openDatabase(path, version: 12, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
    id TEXT ,
    name TEXT,
    dec TEXT,
    phone TEXT,
    address TEXT,
    image JSON NOT NULL,
    coverImage JSON NOT NULL,
    toggle INTEGER
    )''');
  }

  static Future<int> insertUser(
      Place databaseModel,
      List<String> addressDataList,
      List<String> phoneDataList,
      bool toggle,
      Int8List logo,
      Int8List coverImage) async {
    String dataAddress = jsonEncode(addressDataList);
    String dataPhone = jsonEncode(phoneDataList);
    final db = await _openDatabase();
    final data = {
      'id': databaseModel.id,
      'name': databaseModel.name,
      'dec': databaseModel.description,
      'phone': dataPhone,
      'address': dataAddress,
      'image': logo,
      'coverImage': coverImage,
      'toggle': toggle ? 1 : 0,
    };
    return await db.insert('users', data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('users');
  }

  static Future<int> deleteData(String id) async {
    final db = await _openDatabase();
    return await db.delete('users', where: 'id = ? ', whereArgs: [id]);
  }

  static Future<Map<String, dynamic>?> getSingleData(String id) async {
    final db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateData(String id, Map<String, dynamic> data) async {
    final db = await _openDatabase();
    return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }
}
