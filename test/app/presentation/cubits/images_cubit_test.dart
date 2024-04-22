import 'package:bloc_test/bloc_test.dart';
import 'package:cloudwalk_assessment/app/core/utilities/errors/failure.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/get_cached_images_usecase.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/update_local_db_usecase.dart';
import 'package:cloudwalk_assessment/app/presentation/cubits/images_cubit.dart';
import 'package:cloudwalk_assessment/app/presentation/cubits/images_states.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../core/utilities/test_helper.mocks.dart';

class MockGetCachedImagesUsecase extends Mock
    implements GetCachedImagesUsecase {}

class MockUpdateLocalDBUsecase extends Mock implements UpdateLocalDbUsecase {}

void main() {
  // create instances of necessary dependencies and the cubit under test
  late ImagesCubit imagesCubit;
  late MockImagesUsecase mockImagesUsecase;
  late MockGetCachedImagesUsecase mockGetCachedImagesUsecase;
  late MockUpdateLocalDBUsecase mockUpdateLocalDBUsecase;
  late MockConnectivity mockConnectivity;

  setUp(() {
    // set up the necessary dependencies and the cubit instance
    mockImagesUsecase = MockImagesUsecase();
    mockGetCachedImagesUsecase = MockGetCachedImagesUsecase();
    mockUpdateLocalDBUsecase = MockUpdateLocalDBUsecase();
    mockConnectivity = MockConnectivity();
    imagesCubit = ImagesCubit(
      mockImagesUsecase,
      mockUpdateLocalDBUsecase,
      mockGetCachedImagesUsecase,
      mockConnectivity,
    );
  });

  tearDown(() {
    // close the cubit after each test
    imagesCubit.close();
  });

  // create a test image entity for reuse
  const testImage = ImageEntity(
    title: 'Test Movie 1',
    date: '01 June 2023',
    explanation: 'Test Explanation 1',
    imgUrl: 'http://www.example1.com',
  );

  // test the initial state of the cubit
  test(
    'initial state should be empty',
    () => expect(
      imagesCubit.state,
      ImagesInitial(),
    ),
  );

  // test the behavior when internet is available and usecase returns images
  blocTest<ImagesCubit, ImagesStates>(
    'emits ImagesLoaded when internet is available and usecase returns images',
    setUp: () {
      // set up the mock behavior for usecase and connectivity
      when(mockImagesUsecase.getImages()).thenAnswer(
        (_) async => const Right([testImage]),
      );
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.mobile,
      );
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );
    },
    build: () => imagesCubit,
    act: (cubit) async => await cubit.getImages(),
    expect: () => [
      ImagesLoading(),
      const ImagesLoaded([testImage]),
    ],
  );

  // test the behavior when internet is unavailable and cached images are available
  blocTest<ImagesCubit, ImagesStates>(
    'emits ImagesLoaded with cached images when internet is unavailable',
    setUp: () {
      // set up the mock behavior for usecase and connectivity
      when(mockImagesUsecase.getCachedImages()).thenAnswer(
        (_) async => [testImage],
      );
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.none,
      );
    },
    build: () => imagesCubit,
    act: (cubit) async => await cubit.getImages(),
    expect: () => [
      ImagesLoading(),
      const ImagesLoaded([testImage]),
    ],
  );

  // test the behavior when usecase returns a failure
  blocTest<ImagesCubit, ImagesStates>(
    'emits ImagesError when usecase returns a failure',
    setUp: () {
      // set up the mock behavior for usecase and connectivity
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.wifi,
      );
      when(mockImagesUsecase.getImages()).thenAnswer(
        (_) async => const Left(
          Failure('Test Failure'),
        ),
      );
    },
    build: () => imagesCubit,
    act: (cubit) => cubit.getImages(),
    expect: () => [
      ImagesLoading(),
      const ImagesError('Test Failure'),
    ],
  );
}
