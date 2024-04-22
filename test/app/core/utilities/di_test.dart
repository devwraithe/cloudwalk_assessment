import 'package:cloudwalk_assessment/app/core/utilities/dependency_injector.dart'
    as di;
import 'package:cloudwalk_assessment/app/data/datasources/local_datasource.dart';
import 'package:cloudwalk_assessment/app/data/datasources/remote_datasource.dart';
import 'package:cloudwalk_assessment/app/domain/repositories/repository.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/get_images_usecase.dart';
import 'package:cloudwalk_assessment/app/presentation/cubits/images_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

void main() {
  // create an instance of GetIt for dependency injection
  late GetIt sl;

  // set up the GetIt instance before each test
  setUp(() => sl = GetIt.instance);

  // test case: Should register the necessary dependencies
  test('Should register the necessary dependencies', () {
    // call the init() method to register the dependencies
    di.init();

    // verify that the dependencies are registered correctly
    expect(sl.isRegistered<ImagesCubit>(), isTrue);
    expect(sl.isRegistered<Connectivity>(), isTrue);
    expect(sl.isRegistered<ImagesUsecase>(), isTrue);
    expect(sl.isRegistered<Repository>(), isTrue);
    expect(sl.isRegistered<RemoteDataSource>(), isTrue);
    expect(sl.isRegistered<LocalDataSource>(), isTrue);
    expect(sl.isRegistered<HiveInterface>(), isTrue);
    expect(sl.isRegistered<http.Client>(), isTrue);

    // verify the types of the registered dependencies
    expect(sl<ImagesCubit>(), isA<ImagesCubit>());
    expect(sl<Connectivity>(), isA<Connectivity>());
    expect(sl<ImagesUsecase>(), isA<ImagesUsecase>());
    expect(sl<Repository>(), isA<Repository>());
    expect(sl<RemoteDataSource>(), isA<RemoteDataSource>());
    expect(sl<LocalDataSource>(), isA<LocalDataSource>());
    expect(sl<HiveInterface>(), isA<HiveInterface>());
    expect(sl<http.Client>(), isA<http.Client>());
  });
}
