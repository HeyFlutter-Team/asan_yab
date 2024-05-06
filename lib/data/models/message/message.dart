import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class MessageModel with _$MessageModel {
  @JsonSerializable(explicitToJson: true)
  factory MessageModel({
    required String senderId,
    required String receiverId,
    required String content,
    required DateTime sentTime,
    required MessageType messageType,
    required String replayMessage,
    required bool isSeen,
    required int replayMessageIndex,
    required bool replayIsMine,
    required bool isMessageEdited,
    required String replayMessageTime

  }) = _MessageModel;

  MessageModel._();
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

enum MessageType {
  text,
  image,
  sticker,
}
