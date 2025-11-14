import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'redemption_model.freezed.dart';
part 'redemption_model.g.dart';

@freezed
class RedemptionModel with _$RedemptionModel {
  const factory RedemptionModel({
    required String id,
    required String userId,
    required String voucherId,
    required int pointsSpent,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime redeemedAt,
    @Default(false) bool isUsed,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromTimestampNullable, toJson: _dateTimeToTimestampNullable)
    DateTime? usedAt,
  }) = _RedemptionModel;

  factory RedemptionModel.fromJson(Map<String, dynamic> json) =>
      _$RedemptionModelFromJson(json);
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
