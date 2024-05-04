import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldMessage{
  final String userId;
  final String? textFieldMessage;
final String? replayText;
final String? editingMessage;
  TextFieldMessage({required this.userId,this.textFieldMessage,this.replayText,this.editingMessage});

}


final textFieldMessagesListPro = StateProvider<List<TextFieldMessage>>((ref) => []);