import 'package:asan_yab/data/models/message/message.dart';
import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryMessage {
  final fireStore = FirebaseFirestore.instance;
  List<String> usersId = [];
  List<bool> isNewMessage = [];
  Future<List<String>> getOtherUserId() async {
    List<Users> data = [];
    try {
      final data = await fireStore
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) async => await value.reference
              .collection('chat')
              .orderBy('times', descending: true)
              .get());
      usersId = data.docs.map((e) => e.reference.id).toList();
      // print('not work ${data.size}');
      // print('uuuuuuu ${FirebaseAuth.instance.currentUser!.uid}');

      //
    } catch (e) {
      rethrow;
    } finally {
      // print('hhhhhhh ${usersId[0]} ${usersId[1]} ${usersId[2]}');
    }
    return usersId;
  }

  Future<List<Users>> getUser(List<String> uidList) async {
    try {
      List<Users> data = [];
      for (final uid in uidList) {
        final userDataSnapshot =
            await fireStore.collection('User').doc(uid).get();
        final userData = Users.fromMap(userDataSnapshot.data()!);
        data.add(userData);
      }
      return data;
    } catch (e) {
      print('history message ${e.toString()}');
      rethrow;
    }
  }

  Future<List<MessageModel>> getLastMessage(List<String> uidList) async {
    try {
      List<MessageModel> data = [];
      for (final uid in uidList) {
        if (FirebaseAuth.instance.currentUser != null) {
          final userDataSnapshot = await fireStore
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('chat')
              .doc(uid)
              .collection('messages')
              .orderBy('sentTime', descending: true)
              .limit(1)
              .get();
          final userData =
              MessageModel.fromJson(userDataSnapshot.docs.first.data());
          data.add(userData);
        }
      }
      return data;
    } catch (e) {
      print('history message ${e.toString()}');
      rethrow;
    }
  }
}
