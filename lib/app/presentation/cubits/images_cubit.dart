import 'package:cloudwalk_assessment/app/domain/usecases/get_cached_images_usecase.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/update_local_db_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_images_usecase.dart';
import 'images_states.dart';

class ImagesCubit extends Cubit<ImagesStates> {
  final ImagesUsecase _usecase;
  final UpdateLocalDbUsecase _updateLocalDbUsecase;
  final GetCachedImagesUsecase _getCachedImagesUsecase;
  final Connectivity connectivity;

  ImagesCubit(
    this._usecase,
    this._updateLocalDbUsecase,
    this._getCachedImagesUsecase,
    this.connectivity,
  ) : super(ImagesInitial());

  Future<void> getImages() async {
    emit(ImagesLoading());
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      final hasInternet = connectivityResult != ConnectivityResult.none;

      if (hasInternet) {
        final result = await _usecase.getImages();
        debugPrint("[Internet is Available, Access Remote Datasource]");
        emit(
          result.fold(
            (failure) => ImagesError(failure.message),
            (images) {
              _updateLocalDbUsecase.updateLocalDatabase(images);
              return ImagesLoaded(images);
            },
          ),
        );
      } else {
        debugPrint("[Internet is Unavailable, Access Local Datasource]");
        final cachedImages = await _getCachedImagesUsecase.getCachedImages();
        emit(ImagesLoaded(cachedImages));
      }
    } catch (error) {
      emit(ImagesError(error.toString()));
    }
  }
}
