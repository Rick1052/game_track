// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'redemption_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RedemptionModel _$RedemptionModelFromJson(Map<String, dynamic> json) {
  return _RedemptionModel.fromJson(json);
}

/// @nodoc
mixin _$RedemptionModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get voucherId => throw _privateConstructorUsedError;
  int get pointsSpent =>
      throw _privateConstructorUsedError; // ignoreinvalid_annotation_target
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get redeemedAt => throw _privateConstructorUsedError;
  bool get isUsed =>
      throw _privateConstructorUsedError; // ignoreinvalid_annotation_target
  @JsonKey(
    fromJson: _dateTimeFromTimestampNullable,
    toJson: _dateTimeToTimestampNullable,
  )
  DateTime? get usedAt => throw _privateConstructorUsedError;

  /// Serializes this RedemptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedemptionModelCopyWith<RedemptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedemptionModelCopyWith<$Res> {
  factory $RedemptionModelCopyWith(
    RedemptionModel value,
    $Res Function(RedemptionModel) then,
  ) = _$RedemptionModelCopyWithImpl<$Res, RedemptionModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String voucherId,
    int pointsSpent,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime redeemedAt,
    bool isUsed,
    @JsonKey(
      fromJson: _dateTimeFromTimestampNullable,
      toJson: _dateTimeToTimestampNullable,
    )
    DateTime? usedAt,
  });
}

/// @nodoc
class _$RedemptionModelCopyWithImpl<$Res, $Val extends RedemptionModel>
    implements $RedemptionModelCopyWith<$Res> {
  _$RedemptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? voucherId = null,
    Object? pointsSpent = null,
    Object? redeemedAt = null,
    Object? isUsed = null,
    Object? usedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            voucherId: null == voucherId
                ? _value.voucherId
                : voucherId // ignore: cast_nullable_to_non_nullable
                      as String,
            pointsSpent: null == pointsSpent
                ? _value.pointsSpent
                : pointsSpent // ignore: cast_nullable_to_non_nullable
                      as int,
            redeemedAt: null == redeemedAt
                ? _value.redeemedAt
                : redeemedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isUsed: null == isUsed
                ? _value.isUsed
                : isUsed // ignore: cast_nullable_to_non_nullable
                      as bool,
            usedAt: freezed == usedAt
                ? _value.usedAt
                : usedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RedemptionModelImplCopyWith<$Res>
    implements $RedemptionModelCopyWith<$Res> {
  factory _$$RedemptionModelImplCopyWith(
    _$RedemptionModelImpl value,
    $Res Function(_$RedemptionModelImpl) then,
  ) = __$$RedemptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String voucherId,
    int pointsSpent,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime redeemedAt,
    bool isUsed,
    @JsonKey(
      fromJson: _dateTimeFromTimestampNullable,
      toJson: _dateTimeToTimestampNullable,
    )
    DateTime? usedAt,
  });
}

/// @nodoc
class __$$RedemptionModelImplCopyWithImpl<$Res>
    extends _$RedemptionModelCopyWithImpl<$Res, _$RedemptionModelImpl>
    implements _$$RedemptionModelImplCopyWith<$Res> {
  __$$RedemptionModelImplCopyWithImpl(
    _$RedemptionModelImpl _value,
    $Res Function(_$RedemptionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? voucherId = null,
    Object? pointsSpent = null,
    Object? redeemedAt = null,
    Object? isUsed = null,
    Object? usedAt = freezed,
  }) {
    return _then(
      _$RedemptionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        voucherId: null == voucherId
            ? _value.voucherId
            : voucherId // ignore: cast_nullable_to_non_nullable
                  as String,
        pointsSpent: null == pointsSpent
            ? _value.pointsSpent
            : pointsSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        redeemedAt: null == redeemedAt
            ? _value.redeemedAt
            : redeemedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isUsed: null == isUsed
            ? _value.isUsed
            : isUsed // ignore: cast_nullable_to_non_nullable
                  as bool,
        usedAt: freezed == usedAt
            ? _value.usedAt
            : usedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RedemptionModelImpl implements _RedemptionModel {
  const _$RedemptionModelImpl({
    required this.id,
    required this.userId,
    required this.voucherId,
    required this.pointsSpent,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required this.redeemedAt,
    this.isUsed = false,
    @JsonKey(
      fromJson: _dateTimeFromTimestampNullable,
      toJson: _dateTimeToTimestampNullable,
    )
    this.usedAt,
  });

  factory _$RedemptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedemptionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String voucherId;
  @override
  final int pointsSpent;
  // ignoreinvalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime redeemedAt;
  @override
  @JsonKey()
  final bool isUsed;
  // ignoreinvalid_annotation_target
  @override
  @JsonKey(
    fromJson: _dateTimeFromTimestampNullable,
    toJson: _dateTimeToTimestampNullable,
  )
  final DateTime? usedAt;

  @override
  String toString() {
    return 'RedemptionModel(id: $id, userId: $userId, voucherId: $voucherId, pointsSpent: $pointsSpent, redeemedAt: $redeemedAt, isUsed: $isUsed, usedAt: $usedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedemptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.voucherId, voucherId) ||
                other.voucherId == voucherId) &&
            (identical(other.pointsSpent, pointsSpent) ||
                other.pointsSpent == pointsSpent) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt) &&
            (identical(other.isUsed, isUsed) || other.isUsed == isUsed) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    voucherId,
    pointsSpent,
    redeemedAt,
    isUsed,
    usedAt,
  );

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedemptionModelImplCopyWith<_$RedemptionModelImpl> get copyWith =>
      __$$RedemptionModelImplCopyWithImpl<_$RedemptionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RedemptionModelImplToJson(this);
  }
}

abstract class _RedemptionModel implements RedemptionModel {
  const factory _RedemptionModel({
    required final String id,
    required final String userId,
    required final String voucherId,
    required final int pointsSpent,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required final DateTime redeemedAt,
    final bool isUsed,
    @JsonKey(
      fromJson: _dateTimeFromTimestampNullable,
      toJson: _dateTimeToTimestampNullable,
    )
    final DateTime? usedAt,
  }) = _$RedemptionModelImpl;

  factory _RedemptionModel.fromJson(Map<String, dynamic> json) =
      _$RedemptionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get voucherId;
  @override
  int get pointsSpent; // ignoreinvalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get redeemedAt;
  @override
  bool get isUsed; // ignoreinvalid_annotation_target
  @override
  @JsonKey(
    fromJson: _dateTimeFromTimestampNullable,
    toJson: _dateTimeToTimestampNullable,
  )
  DateTime? get usedAt;

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedemptionModelImplCopyWith<_$RedemptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
