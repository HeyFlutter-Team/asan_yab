// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FollowModel _$FollowModelFromJson(Map<String, dynamic> json) {
  return _FollowModel.fromJson(json);
}

/// @nodoc
mixin _$FollowModel {
  List<String>? get followers => throw _privateConstructorUsedError;
  List<String>? get following => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowModelCopyWith<FollowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowModelCopyWith<$Res> {
  factory $FollowModelCopyWith(
          FollowModel value, $Res Function(FollowModel) then) =
      _$FollowModelCopyWithImpl<$Res, FollowModel>;
  @useResult
  $Res call({List<String>? followers, List<String>? following});
}

/// @nodoc
class _$FollowModelCopyWithImpl<$Res, $Val extends FollowModel>
    implements $FollowModelCopyWith<$Res> {
  _$FollowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followers = freezed,
    Object? following = freezed,
  }) {
    return _then(_value.copyWith(
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      following: freezed == following
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowModelImplCopyWith<$Res>
    implements $FollowModelCopyWith<$Res> {
  factory _$$FollowModelImplCopyWith(
          _$FollowModelImpl value, $Res Function(_$FollowModelImpl) then) =
      __$$FollowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String>? followers, List<String>? following});
}

/// @nodoc
class __$$FollowModelImplCopyWithImpl<$Res>
    extends _$FollowModelCopyWithImpl<$Res, _$FollowModelImpl>
    implements _$$FollowModelImplCopyWith<$Res> {
  __$$FollowModelImplCopyWithImpl(
      _$FollowModelImpl _value, $Res Function(_$FollowModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followers = freezed,
    Object? following = freezed,
  }) {
    return _then(_$FollowModelImpl(
      followers: freezed == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      following: freezed == following
          ? _value._following
          : following // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$FollowModelImpl extends _FollowModel {
  _$FollowModelImpl(
      {final List<String>? followers, final List<String>? following})
      : _followers = followers,
        _following = following,
        super._();

  factory _$FollowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowModelImplFromJson(json);

  final List<String>? _followers;
  @override
  List<String>? get followers {
    final value = _followers;
    if (value == null) return null;
    if (_followers is EqualUnmodifiableListView) return _followers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _following;
  @override
  List<String>? get following {
    final value = _following;
    if (value == null) return null;
    if (_following is EqualUnmodifiableListView) return _following;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FollowModel(followers: $followers, following: $following)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowModelImpl &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality()
                .equals(other._following, _following));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_followers),
      const DeepCollectionEquality().hash(_following));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowModelImplCopyWith<_$FollowModelImpl> get copyWith =>
      __$$FollowModelImplCopyWithImpl<_$FollowModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowModelImplToJson(
      this,
    );
  }
}

abstract class _FollowModel extends FollowModel {
  factory _FollowModel(
      {final List<String>? followers,
      final List<String>? following}) = _$FollowModelImpl;
  _FollowModel._() : super._();

  factory _FollowModel.fromJson(Map<String, dynamic> json) =
      _$FollowModelImpl.fromJson;

  @override
  List<String>? get followers;
  @override
  List<String>? get following;
  @override
  @JsonKey(ignore: true)
  _$$FollowModelImplCopyWith<_$FollowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
