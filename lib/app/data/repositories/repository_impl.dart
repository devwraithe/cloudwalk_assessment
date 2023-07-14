import 'dart:async';
import 'dart:io';

import 'package:cloudwalk_assessment/app/core/utilities/constants.dart';
import 'package:cloudwalk_assessment/app/core/utilities/errors/exceptions.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:cloudwalk_assessment/app/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/utilities/errors/failure.dart';
import '../datasources/datasource.dart';

class RepositoryImpl implements Repository {
  final DataSource dataSource;
  RepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ImageEntity>>> getImagesRepo() async {
    try {
      final images = await dataSource.getImages();
      return Right(images.map((image) => image.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(e.failure);
    } on SocketException {
      return Left(Failure(Constants.lostConnection));
    } on TimeoutException {
      return Left(Failure(Constants.timeout));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
