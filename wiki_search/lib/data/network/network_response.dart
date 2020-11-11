import 'package:equatable/equatable.dart';

class NetworkResponse<T> extends Equatable {
  final int errorCode;
  final T data;

  NetworkResponse({this.data, this.errorCode});

  @override
  List<Object> get props => [errorCode, data];
}
