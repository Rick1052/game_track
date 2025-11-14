// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redemption_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RedemptionModelImpl _$$RedemptionModelImplFromJson(
  Map<String, dynamic> json,
) => _$RedemptionModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  voucherId: json['voucherId'] as String,
  pointsSpent: (json['pointsSpent'] as num).toInt(),
  redeemedAt: _dateTimeFromTimestamp(json['redeemedAt']),
  isUsed: json['isUsed'] as bool? ?? false,
  usedAt: _dateTimeFromTimestampNullable(json['usedAt']),
);

Map<String, dynamic> _$$RedemptionModelImplToJson(
  _$RedemptionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'voucherId': instance.voucherId,
  'pointsSpent': instance.pointsSpent,
  'redeemedAt': _dateTimeToTimestamp(instance.redeemedAt),
  'isUsed': instance.isUsed,
  'usedAt': _dateTimeToTimestampNullable(instance.usedAt),
};
