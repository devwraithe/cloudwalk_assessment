import 'package:cloudwalk_assessment/app/domain/repositories/repository.dart';

import '../entities/image_entity.dart';

class UpdateLocalDbUsecase {
  final Repository repo;
  UpdateLocalDbUsecase(this.repo);

  Future<void> updateLocalDatabase(List<ImageEntity> images) async {
    return await repo.updateLocalDatabase(images);
  }
}
