import 'package:cloudwalk_assessment/app/domain/repositories/repository.dart';

import '../entities/image_entity.dart';

class GetCachedImagesUsecase {
  final Repository repo;
  GetCachedImagesUsecase(this.repo);

  Future<List<ImageEntity>> getCachedImages() async {
    return await repo.getCachedImages();
  }
}
