import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'voucher_model.freezed.dart';
part 'voucher_model.g.dart';

@freezed
class VoucherModel with _$VoucherModel {
  const factory VoucherModel({
    required String id,
    required String title,
    required String description,
    required String type, // 'accessory', 'discount', 'premium'
    required int pointsCost,
    required String imageUrl,
    @Default(0) int stock,
    @Default(true) bool isActive,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromTimestampNullable, toJson: _dateTimeToTimestampNullable)
    DateTime? expiresAt,
  }) = _VoucherModel;

  factory VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);
}

DateTime _dateTimeFromTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is String) return DateTime.parse(timestamp);
  if (timestamp is Map) {
    final seconds = timestamp['_seconds'] as int?;
    final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
    if (seconds != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + (nanoseconds / 1000000).round(),
      );
    }
  }
  return DateTime.now();
}

DateTime? _dateTimeFromTimestampNullable(dynamic timestamp) {
  if (timestamp == null) return null;
  return _dateTimeFromTimestamp(timestamp);
}

dynamic _dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

dynamic _dateTimeToTimestampNullable(DateTime? dateTime) {
  if (dateTime == null) return null;
  return _dateTimeToTimestamp(dateTime);
}

