// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowModelImpl _$$FollowModelImplFromJson(Map<String, dynamic> json) =>
    _$FollowModelImpl(
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$FollowModelImplToJson(_$FollowModelImpl instance) =>
    <String, dynamic>{
      'followers': instance.followers,
      'following': instance.following,
    };
