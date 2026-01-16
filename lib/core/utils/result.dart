
import '../errors/failure.dart';

class Result<T> {
  final T? data;
  final Failure? error;

  const Result._({this.data, this.error});

  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(Failure error) => Result._(error: error);

  bool get isSuccess => data != null;
  bool get isFailure => error != null;

  R fold<R>(R Function(Failure error) onFailure, R Function(T data) onSuccess) {
    if (isFailure) {
      return onFailure(error!);
    } else {
      return onSuccess(data as T);
    }
  }
}
