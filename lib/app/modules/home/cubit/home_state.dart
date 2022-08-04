import 'package:dictionary/app/shared/models/word_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String success;
  final String error;
  final List<WordModel> data;

  const HomeState({
    this.isLoading = false,
    this.success = '',
    this.error = '',
    this.data = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? success,
    String? error,
    List<WordModel>? data,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        success,
        error,
        data,
      ];
}
