import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldMessage{
  final String userId;
  final String? textFieldMessage;
final String? replayText;
  TextFieldMessage({required this.userId,this.textFieldMessage,this.replayText});

}


final textFieldMessagesListPro = StateProvider<List<TextFieldMessage>>((ref) => []);