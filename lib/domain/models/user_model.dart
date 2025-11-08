import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    required String displayName,
    String? avatarUrl,
    @Default(0) int score,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int videosCount,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestampNullable, toJson: _dateTimeToTimestampNullable)
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
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

