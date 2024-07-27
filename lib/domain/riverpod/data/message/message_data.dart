import 'package:asan_yab/data/models/message/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'message.dart';

final messageProvider =
    StateNotifierProvider<MessageProvider, List<MessageModel>>(
        (ref) => MessageProvider([], ref));

class MessageProvider extends StateNotifier<List<MessageModel>> {
  final Ref ref;
  final scrollController = ItemScrollController();
  final listViewController = ScrollController();
  MessageProvider(super.state, this.ref);
  Future<List<MessageModel>> getMessages(String receiverId)async {
    try {
      print('getMessages 1');
      if(ref.watch(activeChatIdProvider)== receiverId || ref.watch(activeChatIdProvider) == '') {
        ref
            .read(messageLoadingProvider.notifier)
            .state = true;
        FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chat')
            .doc(receiverId)
            .collection('messages')
            .orderBy('sentTime', descending: true)
            .snapshots(includeMetadataChanges: true)
            .listen((messages)async {
            print('getMessageeeeeeeeeeeeeeeeeeeeeeeeeee');
              if(mounted) {
                state = messages.docs
                    .map((doc) => MessageModel.fromJson(doc.data()))
                    .toList();
              }
          await ref
               .read(
               localMessagesProvider
                   .notifier)
               .clear();


        });
        print('getMessages 2');
        return state;
      }else{
        return[];
      }
    } catch (e) {
      rethrow;
    } finally {
      ref.read(messageLoadingProvider.notifier).state = false;
      print('final test');
    }
  }




  void clearState() => state.clear();

  void scrollDown(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && scrollController.isAttached) {
        scrollController.scrollTo(
          index: 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }


  final itemPositionsListener = ItemPositionsListener.create();



  void listenToScrollPosition() {
    final targetPositions = {
      1,2,3,4,5,6,7
    };

   itemPositionsListener
        .itemPositions
        .addListener(() async {
      final positions =itemPositionsListener.itemPositions.value.last;
        final itemVisible = positions;
        print('younis item visible ${itemVisible.index}');
        if (targetPositions.contains(itemVisible.index)) {
            if (mounted) {
              ref.read(isToEndProvider.notifier).state = true;
            }
        } else {
          if (mounted) {
            ref.read(isToEndProvider.notifier).state = false;
          }
        }
    });
  }

}

final messageLoadingProvider = StateProvider((ref) => false);

class ReplayScroll extends ChangeNotifier {
  void scrollItem(WidgetRef ref, int index) {
    ref.read(messageProvider.notifier).scrollController.scrollTo(
        index: index,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
    notifyListeners();
  }
  void scrollItemByTime(WidgetRef ref, DateTime sentTime) async{
    final messages = ref.watch(messageProvider);
    final index = messages.indexWhere((message) => message.sentTime == sentTime);
    final colorState = ref.read(replayColor(index).notifier);
    if (index != -1) {
      ref.read(messageProvider.notifier).scrollController.scrollTo(
        index: index,
        alignment: 0.26,
        duration: const Duration(microseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
      colorState.state=true;
      await Future.delayed(
          const Duration(seconds: 1));
      colorState.state=false;
      notifyListeners();
    }
  }
}

final replayPositionProvider =
    ChangeNotifierProvider<ReplayScroll>((ref) => ReplayScroll());

final replayColor = StateProvider.family<bool, int>((ref, index){

  return false;
} );

final isToEndProvider = StateProvider((ref) => false);


final unreadMessageCountProvider =
ChangeNotifierProvider.autoDispose.family<UnreadMessageCountNotifier, String>(
      (ref, chatId) => UnreadMessageCountNotifier(chatId),
);

class UnreadMessageCountNotifier extends ChangeNotifier {
  final String chatId;
  int _unreadMessagesCount = 0;

  UnreadMessageCountNotifier(this.chatId);

  int get unreadMessagesCount => _unreadMessagesCount;

  Future<void> getUnseenMessageCounts(WidgetRef ref,String uid,bool isNotMe) async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final unseenMessagesSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserUid)
          .collection('chat')
          .doc(chatId)
          .collection('messages')
          .where('isSeen', isEqualTo: false)
          .get();

      _unreadMessagesCount = unseenMessagesSnapshot.docs.length;
      notifyListeners();
      final bool hasUnreadMessages = ref.watch(unreadMessageCountProvider(uid).notifier).unreadMessagesCount > 0;
      if(hasUnreadMessages && isNotMe) {
        ref
            .read(isUnreadMessageProvider.notifier)
            .state = true;
      }else{
        ref
            .read(isUnreadMessageProvider.notifier)
            .state = false;

      }
    } catch (e) {
      print('Error fetching unseen messages for chat $chatId: $e');
      // Handle error
    }
  }
}



// List<MessageModel> getMessages(String receiverId,WidgetRef ref) {
//   try {
//     print('getMessages 1');
//     if(ref.watch(activeChatIdProvider) != ''){
//       ref
//           .read(messageLoadingProvider.notifier)
//           .state = true;
//       FirebaseFirestore.instance
//           .collection('User')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('chat')
//           .doc(ref.watch(activeChatIdProvider))
//           .collection('messages')
//           .orderBy('sentTime', descending: true)
//           .snapshots(includeMetadataChanges: true)
//           .listen((messages) {
//         print('getMessageeeeeeeeeeeeeeeeeeeeeeeeeee');
//         state = messages.docs
//             .map((doc) => MessageModel.fromJson(doc.data()))
//             .toList();
//       });
//       print('getMessages 2');
//       return state;
//     }else {
//       ref
//           .read(messageLoadingProvider.notifier)
//           .state = true;
//       FirebaseFirestore.instance
//           .collection('User')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection('chat')
//           .doc(receiverId)
//           .collection('messages')
//           .orderBy('sentTime', descending: true)
//           .snapshots(includeMetadataChanges: true)
//           .listen((messages) {
//         print('getMessageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
//         state = messages.docs
//             .map((doc) => MessageModel.fromJson(doc.data()))
//             .toList();
//       });
//       print('getMessages 2');
//       return state;
//     }
//   } catch (e) {
//     rethrow;
//   } finally {
//     ref.read(messageLoadingProvider.notifier).state = false;
//   }
// }