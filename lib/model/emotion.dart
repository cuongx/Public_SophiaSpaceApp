import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emotion.g.dart';

List<Emotion> emotions = [
  Emotion(id: "1", name: "Công việc", icon: Icons.work_outline_sharp),
  Emotion(id: "2", name: "Bạn bè", icon: Icons.people_outline_sharp),
  Emotion(id: "3", name: "Gia đình", icon: Icons.home_filled),
  Emotion(id: "4", name: "Giấc ngủ", icon: Icons.bed_sharp),
  Emotion(id: "5", name: "Mối quan hệ", icon: Icons.supervisor_account_sharp),
  Emotion(id: "6", name: "Trường học", icon: Icons.school_sharp),
  Emotion(id: "7", name: "Đồ ăn", icon: Icons.emoji_food_beverage_sharp),
  Emotion(id: "8", name: "Sức khỏe", icon: Icons.volunteer_activism_sharp),
  Emotion(id: "9", name: "Sở thích", icon: Icons.piano_sharp),
  Emotion(id: "10", name: "Thời tiết", icon: Icons.wb_sunny_sharp),
];

@JsonSerializable()
class Emotion {
  String id;
  String? name;
  @JsonKey(ignore: true)
  IconData? icon;

  Emotion({
    required this.id,
    this.icon,
    this.name,
  });

  factory Emotion.fromJson(Map<String, dynamic> json) =>
      _$EmotionFromJson(json);

  /// Connect the generated [_$EmotionToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EmotionToJson(this);
}