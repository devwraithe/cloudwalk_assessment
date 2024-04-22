import 'package:cloudwalk_assessment/app/core/utilities/constants.dart';
import 'package:cloudwalk_assessment/app/core/utilities/errors/exceptions.dart';
import 'package:cloudwalk_assessment/app/core/utilities/errors/failure.dart';
import 'package:cloudwalk_assessment/app/data/models/image_model.dart';
import 'package:cloudwalk_assessment/app/data/repositories/repository_impl.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../core/utilities/test_helper.mocks.dart';

void main() {
  // define the variables needed for the test
  late RepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  // set up the necessary objects and dependencies before each test
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = RepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  // define mock data for testing
  final mockImages = [
    const ImageEntity(
      title: 'Image 1',
      date: '2021-09-01',
      explanation: 'Explanation 1',
      imgUrl: 'https://image1.com',
    ),
    const ImageEntity(
      title: 'Image 2',
      date: '2021-09-02',
      explanation: 'Explanation 2',
      imgUrl: 'https://image2.com',
    ),
  ];

  final mockImageModels = [
    const ImageModel(
      title: 'Image 1',
      date: '2021-09-01',
      explanation: 'Explanation 1',
      imgUrl: 'https://image1.com',
    ),
    const ImageModel(
      title: 'Image 2',
      date: '2021-09-02',
      explanation: 'Explanation 2',
      imgUrl: 'https://image2.com',
    ),
  ];

  // test case: should return a list of ImageEntity on success
  test('should return a list of ImageEntity on success', () async {
    // set up the behavior of the mock remote data source
    when(mockRemoteDataSource.getImages()).thenAnswer(
      (_) async => mockImageModels,
    );

    // call the repository method and get the result
    final result = await repository.getImagesRepo();

    // verify the result is of the expected type and contains the correct data
    expect(result, isA<Right<Failure, List<ImageEntity>>>());
    expect(result.getOrElse(() => throw Error()), isA<List<ImageEntity>>());
    expect(result.getOrElse(() => throw Error()).length, 2);
  });

  // test case: should return a ServerFailure on ServerException
  test('should return a ServerFailure on ServerException', () async {
    // create a server exception with the corresponding failure
    final serverException = ServerException(Failure(Constants.serverError));

    // set up the behavior of the mock remote data source to throw the server exception
    when(mockRemoteDataSource.getImages()).thenThrow(serverException);

    // call the repository method and get the result
    final result = await repository.getImagesRepo();

    // verify the result is of the expected type and contains the correct failure
    expect(result, isA<Left<Failure, List<ImageEntity>>>());
    expect(result.isLeft(), true);
    expect(
      result.fold(
        (failure) => failure,
        (_) => throw Error(),
      ),
      serverException.failure,
    );
  });

  // test case: should return a Failure on SocketException
  test('should return a Failure on SocketException', () async {
    // set up the behavior of the mock remote data source to throw a socket exception
    when(mockRemoteDataSource.getImages()).thenThrow(
      NetworkException(Failure(Constants.socketError)),
    );

    // call the repository method and get the result
    final result = await repository.getImagesRepo();

    // verify the result is of the expected type and contains the correct failure
    expect(result, isA<Left<Failure, List<ImageEntity>>>());
    expect(result.isLeft(), true);
    expect(
      result.fold((failure) => failure, (_) => throw Error()),
      Failure(Constants.lostConnection),
    );
  });

  // test case: should return a Failure on TimeoutException
  test('should return a Failure on TimeoutException', () async {
    // set up the behavior of the mock remote data source to throw a timeout exception
    when(mockRemoteDataSource.getImages()).thenThrow(
      RequestTimeoutException(Failure(Constants.timeout)),
    );

    // call the repository method and get the result
    final result = await repository.getImagesRepo();

    // verify the result is of the expected type and contains the correct failure
    expect(result, isA<Left<Failure, List<ImageEntity>>>());
    expect(result.isLeft(), true);
    expect(
      result.fold((failure) => failure, (_) => throw Error()),
      Failure(Constants.timeout),
    );
  });

  // test case: should return a Failure on other exceptions
  test('should return a Failure on other exceptions', () async {
    // set up the behavior of the mock remote data source to throw a generic exception
    when(mockRemoteDataSource.getImages()).thenThrow(
      Exception(Constants.unknownError),
    );

    // call the repository method and get the result
    final result = await repository.getImagesRepo();

    // verify the result is of the expected type and contains a Failure object
    expect(result, isA<Left<Failure, List<ImageEntity>>>());
    expect(result.isLeft(), true);
    expect(
      result.fold(
        (failure) => failure,
        (_) => throw Error(),
      ),
      isA<Failure>(),
    );
  });

  // test case: should update local database with images successfully
  test('should update local database with images successfully', () async {
    // call the repository method to update the local database with mock images
    await repository.updateLocalDatabase(mockImages);

    // verify that the storeImages method of the mock local data source is called
    verify(mockLocalDataSource.storeImages(mockImages)).called(1);
  });

  // test case: should retrieve cached images successfully
  test('should retrieve cached images successfully', () async {
    // set up the behavior of the mock local data source to return the mock images
    when(mockLocalDataSource.retrieveImages()).thenAnswer(
      (_) async => mockImages,
    );

    // call the repository method to retrieve the cached images
    final result = await repository.getCachedImages();

    // verify that the result matches the expected mock images
    expect(result, equals(mockImages));

    // verify that the retrieveImages method of the mock local data source is called
    verify(mockLocalDataSource.retrieveImages()).called(1);
  });
}
