import 'package:cloudwalk_assessment/app/core/utilities/errors/failure.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/get_cached_images_usecase.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/get_images_usecase.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/update_local_db_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../core/utilities/test_helper.mocks.dart';

void main() {
  late ImagesUsecase usecase;
  late GetCachedImagesUsecase getCachedImagesUsecase;
  late UpdateLocalDbUsecase updateLocalDbUsecase;
  late MockRepository mockRepository;

  // set up the test environment by creating a mock repository instance
  setUp(() {
    mockRepository = MockRepository();
    usecase = ImagesUsecase(mockRepository);
    getCachedImagesUsecase = GetCachedImagesUsecase(mockRepository);
    updateLocalDbUsecase = UpdateLocalDbUsecase(mockRepository);
  });

  // define a list of mock ImageEntity objects for testing
  final mockImages = [
    const ImageEntity(
      title: 'Image 1',
      date: '2023-07-12',
      explanation: 'This is image 1',
      imgUrl: 'https://example.com/image1.jpg',
    ),
    const ImageEntity(
      title: 'Image 2',
      date: '2023-07-15',
      explanation: 'This is image 2',
      imgUrl: 'https://example.com/image2.jpg',
    ),
  ];

  // test case: should return a list of ImageEntity on successful response
  test('should return a list of ImageEntity on successful response', () async {
    // set up the mock behavior of the repository's getImagesRepo method
    when(mockRepository.getImagesRepo()).thenAnswer(
      (_) async => Right(mockImages),
    );

    // call the use case's getImages method and store the result
    final result = await usecase.getImages();

    // verify that the result is equal to Right(mockImages)
    expect(result, equals(Right(mockImages)));

    // verify that the repository's getImagesRepo method is called once
    verify(mockRepository.getImagesRepo()).called(1);

    // verify that there are no more interactions with the mock repository
    verifyNoMoreInteractions(mockRepository);
  });

  // test case: should return a Failure when repository returns a Left
  test('should return a Failure when repository returns a Left', () async {
    // create a mock Failure instance
    const failure = Failure('Test failure');

    // set up the mock behavior of the repository's getImagesRepo method
    when(mockRepository.getImagesRepo()).thenAnswer(
      (_) async => const Left(failure),
    );

    // call the use case's getImages method and store the result
    final result = await usecase.getImages();

    // verify that the result is equal to Left(failure)
    expect(result, equals(const Left(failure)));

    // verify that the repository's getImagesRepo method is called once
    verify(mockRepository.getImagesRepo()).called(1);

    // verify that there are no more interactions with the mock repository
    verifyNoMoreInteractions(mockRepository);
  });

  // test case: should update the local database with given images
  test('should update the local database with given images', () async {
    // call the use case's updateLocalDatabase method with the mock images
    await updateLocalDbUsecase.updateLocalDatabase(mockImages);

    // verify that the repository's updateLocalDatabase method is called once
    verify(mockRepository.updateLocalDatabase(mockImages)).called(1);

    // verify that there are no more interactions with the mock repository
    verifyNoMoreInteractions(mockRepository);
  });

  // test case: should retrieve cached images successfully
  test('should retrieve cached images successfully', () async {
    // set up the mock behavior of the repository's getCachedImages method
    when(mockRepository.getCachedImages()).thenAnswer(
      (_) async => mockImages,
    );

    // call the use case's getCachedImages method and store the result
    final result = await getCachedImagesUsecase.getCachedImages();

    // verify that the result is equal to the mock images
    expect(result, equals(mockImages));

    // verify that the repository's getCachedImages method is called once
    verify(mockRepository.getCachedImages()).called(1);

    // verify that there are no more interactions with the mock repository
    verifyNoMoreInteractions(mockRepository);
  });
}
