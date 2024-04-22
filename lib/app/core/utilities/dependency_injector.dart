import 'package:cloudwalk_assessment/app/data/datasources/local_datasource.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/get_cached_images_usecase.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/update_local_db_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/remote_datasource.dart';
import '../../data/repositories/repository_impl.dart';
import '../../domain/repositories/repository.dart';
import '../../domain/usecases/get_images_usecase.dart';
import '../../presentation/cubits/images_cubit.dart';

final sl = GetIt.instance; // the service locator(sl)

void regFactory<T extends Object>(T Function() factFunc) {
  sl.registerFactory(factFunc);
}

void regSingleton<T extends Object>(T Function() factFunc) {
  sl.registerLazySingleton(factFunc);
}

void init() {
  // can have a separate method as app scales
  regSingleton(() => ImagesCubit(sl(), sl(), sl(), sl()));
  regSingleton<Connectivity>(() => Connectivity());
  regSingleton(() => ImagesUsecase(sl()));
  regSingleton(() => UpdateLocalDbUsecase(sl()));
  regSingleton(() => GetCachedImagesUsecase(sl()));
  regSingleton<Repository>(() => RepositoryImpl(sl(), sl()));
  regSingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl()));

  // local data source
  regSingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));

  regSingleton<HiveInterface>(() => Hive);

  regSingleton(() => http.Client());
}
