// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoucherModelImpl _$$VoucherModelImplFromJson(Map<String, dynamic> json) =>
    _$VoucherModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      pointsCost: (json['pointsCost'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      expiresAt: _dateTimeFromTimestampNullable(json['expiresAt']),
    );

Map<String, dynamic> _$$VoucherModelImplToJson(_$VoucherModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'pointsCost': instance.pointsCost,
      'imageUrl': instance.imageUrl,
      'stock': instance.stock,
      'isActive': instance.isActive,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'expiresAt': _dateTimeToTimestampNullable(instance.expiresAt),
    };
