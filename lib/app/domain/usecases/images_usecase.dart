import 'package:cloudwalk_assessment/app/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/utilities/errors/failure.dart';
import '../entities/image_entity.dart';

class NasaImagesUsecase {
  final Repository repo;
  NasaImagesUsecase(this.repo);

  Future<Either<Failure, List<ImageEntity>>> execute() async {
    final result = await repo.getImagesRepo();
    return result.fold(
      (failure) => Left(failure),
      (images) => Right(images),
    );
  }

  // local data
  Future<void> storeImage(List<ImageEntity> images) async {
    return await repo.updateLocalDatabase(images);
  }

  Future<List<ImageEntity>> getCachedImages() async {
    return await repo.getCachedImages();
  }
}
