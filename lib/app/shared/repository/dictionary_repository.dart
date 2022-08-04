import 'dart:developer';

import 'package:dictionary/app/shared/models/word_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../exceptions/hive_exception.dart';

class DictionaryRepository {
  Future<void> saveWord({required WordModel word}) async {
    var box = await Hive.openBox('word');
    try {
      await box.add(word);
    } on HiveError catch (e, s) {
      log('Falha ao salvar palavra', error: e, stackTrace: s);
      throw HiveException(message: e.message);
    } finally {
      await box.close();
    }
  }

  Future<List<WordModel>> getWords() async {
    var box = await Hive.openBox('word');
    try {
      List<WordModel> words = [];
      for (var i = 0; i < box.keys.length; i++) {
        WordModel? word = await box.get(i);
        if (word != null) {
          words.add(word);
        }
      }

      return words;
    } on HiveError catch (e, s) {
      log('Falha ao carregar palavras', error: e, stackTrace: s);
      throw HiveException(message: e.message);
    } finally {
      await box.close();
    }
  }

  Future<void> deleteWord({required WordModel wordModel}) async {
    var box = await Hive.openBox('word');
    try {
      List<WordModel> words = [];
      for (var i = 0; i < box.keys.length; i++) {
        WordModel? word = await box.get(i);
        if (word?.id != wordModel.id) {
          words.add(word!);
        }
      }
      await box.clear();
      await box.addAll(words);
    } on HiveError catch (e, s) {
      log('Falha ao deletar palavra', error: e, stackTrace: s);
      throw HiveException(message: e.message);
    } finally {
      await box.close();
    }
  }
}
