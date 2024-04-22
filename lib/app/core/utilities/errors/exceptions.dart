import 'dart:io';

import 'package:equatable/equatable.dart';

import 'failure.dart';

class ServerException extends Equatable implements Exception {
  final Failure failure;
  const ServerException(this.failure);
  @override
  List<Object?> get props => [failure];
}

class NetworkException extends Equatable implements IOException {
  final Failure failure;
  const NetworkException(this.failure);
  @override
  List<Object?> get props => [failure];
}

class RequestTimeoutException extends Equatable implements IOException {
  final Failure failure;
  const RequestTimeoutException(this.failure);
  @override
  List<Object?> get props => [failure];
}
