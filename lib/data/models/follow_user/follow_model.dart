import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_model.freezed.dart';
part 'follow_model.g.dart';

@freezed
class FollowModel with _$FollowModel {
  @JsonSerializable(explicitToJson: true)
  factory FollowModel({
    final List<String>? followers,
    final List<String>? following,
  }) = _FollowModel;
  FollowModel._();
  factory FollowModel.fromJson(Map<String, dynamic> json) =>
      _$FollowModelFromJson(json);
}
