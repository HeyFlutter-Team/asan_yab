// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      sentTime: DateTime.parse(json['sentTime'] as String),
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      replayMessage: json['replayMessage'] as String,
      isSeen: json['isSeen'] as bool,
      replayMessageIndex: json['replayMessageIndex'] as int,
      replayIsMine: json['replayIsMine'] as bool,
      isMessageEdited: json['isMessageEdited'] as bool,
      replayMessageTime: json['replayMessageTime'] as String,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'content': instance.content,
      'sentTime': instance.sentTime.toIso8601String(),
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'replayMessage': instance.replayMessage,
      'isSeen': instance.isSeen,
      'replayMessageIndex': instance.replayMessageIndex,
      'replayIsMine': instance.replayIsMine,
      'isMessageEdited': instance.isMessageEdited,
      'replayMessageTime': instance.replayMessageTime,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.sticker: 'sticker',
};
