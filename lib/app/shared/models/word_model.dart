import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class WordModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String word;
  @HiveField(2)
  final String translation;
  @HiveField(3)
  final String pronunce;
  @HiveField(4)
  final String note;

  WordModel({
    required this.id,
    required this.word,
    required this.translation,
    required this.pronunce,
    required this.note,
  });
}
