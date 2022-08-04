import 'dart:developer' as dev;
import 'dart:math';

import 'package:dictionary/app/shared/models/notification_model.dart';
import 'package:dictionary/app/shared/models/word_model.dart';
import 'package:dictionary/app/shared/repository/dictionary_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/exceptions/hive_exception.dart';
import '../../../shared/notifications/notification_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this.repository,
    this._notificationService,
  ) : super(const HomeState());

  final DictionaryRepository repository;
  final NotificationService _notificationService;

  List<WordModel> _fullListWords = [];

  Future<void> getWords() async {
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      List<WordModel> response = await repository.getWords();
      List<WordModel> reversedList = response.reversed.toList();
      if (response.isNotEmpty) {
        emit(state.copyWith(
          isLoading: false,
          data: reversedList,
        ));
      } else {
        emit(state.copyWith(isLoading: false, data: []));
      }
      _fullListWords = reversedList;
    } on HiveException catch (e, s) {
      dev.log('Falha ao buscar histórico', error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> saveWord({required WordModel word}) async {
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      await repository.saveWord(word: word);
      await getWords();
      _scheduleNotification(state.data);
      emit(state.copyWith(
        isLoading: false,
        success: 'Palavra cadasatrada com sucesso!',
      ));
    } on HiveException catch (e, s) {
      dev.log('Falha ao buscar histórico', error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> deleteWord({required WordModel word}) async {
    emit(state.copyWith(isLoading: true, error: '', success: ''));
    try {
      await repository.deleteWord(wordModel: word);
      await getWords();
      emit(state.copyWith(
        isLoading: false,
        success: 'Palavra deletada com sucesso!',
      ));
    } on HiveException catch (e, s) {
      dev.log('Falha ao buscar histórico', error: e, stackTrace: s);
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  void filterWordsByName(String word) {
    emit(state.copyWith(error: '', success: ''));
    List<WordModel> newList = [];

    if (word.isNotEmpty) {
      var filter = _fullListWords.where((element) {
        return element.word.toLowerCase().contains(word.toLowerCase());
      });
      newList.addAll(filter);
      emit(state.copyWith(data: newList));
    } else {
      emit(state.copyWith(data: _fullListWords));
    }
  }

  void _scheduleNotification(List<WordModel> words) {
    _notificationService.cancelAllNotifications();
    DateTime dateTime = DateTime.now();
    Random random = Random();
    if (words.isNotEmpty) {
      for (var i = 0; i < words.length; i++) {
        if (dateTime.hour >= 7 && dateTime.hour <= 21) {
          dateTime = dateTime.add(const Duration(hours: 1));
        } else {
          dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            7,
            1,
            0,
          ).add(const Duration(days: 1));
        }

        int index = random.nextInt(words.length);
        _notificationService.scheduleNotification(
          notification: NotificationModel(
            id: i,
            title: words[index].word,
            body: 'Quer dizer: ${words[index].translation}',
            payload: '/home/',
          ),
          dateTime: dateTime,
        );
      }
    }
  }
}
