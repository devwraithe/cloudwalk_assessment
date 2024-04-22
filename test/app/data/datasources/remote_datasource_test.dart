import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudwalk_assessment/app/core/utilities/constants.dart';
import 'package:cloudwalk_assessment/app/core/utilities/errors/exceptions.dart';
import 'package:cloudwalk_assessment/app/data/datasources/remote_datasource.dart';
import 'package:cloudwalk_assessment/app/data/models/image_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../core/utilities/test_helper.mocks.dart';

void main() {
  // define mock objects and data source
  late MockClient mockClient;
  late RemoteDataSourceImpl dataSource;

  // set up the test environment
  setUp(() {
    // create a mock HTTP client
    mockClient = MockClient();

    // create the remote data source using the mock client
    dataSource = RemoteDataSourceImpl(mockClient);
  });

  // define the expected success response
  final expectedSuccessResponse = Response(
    json.encode([
      {
        'title': "Test Image 1",
        'date': "01 June 2023",
        'explanation': "Test Explanation 1",
        'hdurl': 'https://example.com/image1.jpg',
      },
      {
        'title': "Test Image 2",
        'date': "02 June 2023",
        'explanation': "Test Explanation 2",
        'hdurl': 'https://example.com/image2.jpg',
      },
    ]),
    200,
  );

  // test case: should return a list of ImageModel on successful response
  test('should return a list of ImageModel on successful response', () async {
    // set up the mock behavior of the client's get method
    when(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => expectedSuccessResponse);

    // call the data source's getImages method and store the result
    final result = await dataSource.getImages();

    // verify that the result is a list of ImageModel and has a length of 2
    expect(result, isA<List<ImageModel>>());
    expect(result.length, 2);

    // verify that the client's get method is called with the correct arguments
    verify(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).called(1);
  });

  // test case: should throw a ServerException on non-200 status code
  test('should throw a ServerException on non-200 status code', () async {
    // set up the mock behavior of the client's get method
    when(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async {
      return Response(Constants.serverError, 400);
    });

    // expect that calling the data source's getImages method throws a ServerException
    expect(
      dataSource.getImages(),
      throwsA(isA<ServerException>()),
    );
  });

  // test case: should throw a NetworkException on SocketException
  test('should throw a NetworkException on SocketException', () async {
    // set up the mock behavior of the client's get method
    when(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).thenThrow(SocketException(Constants.socketError));

    // expect that calling the data source's getImages method throws a NetworkException
    expect(
      dataSource.getImages(),
      throwsA(
        isA<NetworkException>(),
      ),
    );
  });

  // test case: should throw a NetworkException on TimeoutException
  test('should throw a NetworkException on TimeoutException', () async {
    // set up the mock behavior of the client's get method
    when(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).thenThrow(TimeoutException(Constants.timeout));

    // expect that calling the data source's getImages method throws a NetworkException
    expect(
      dataSource.getImages(),
      throwsA(
        isA<RequestTimeoutException>(),
      ),
    );
  });

  // test case: should throw a ServerException on PlatformException
  test('should throw a ServerException on PlatformException', () async {
    // set up the mock behavior of the client's get method
    when(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).thenThrow(
      PlatformException(
        code: 'platform_error',
        message: 'Platform error',
      ),
    );

    // expect that calling the data source's getImages method throws a ServerException
    expect(
      dataSource.getImages(),
      throwsA(
        isA<ServerException>(),
      ),
    );
  });

  // test case: should throw a ServerException on other exceptions
  test('should throw a ServerException on other exceptions', () async {
    // set up the mock behavior of the client's get method
    when(
      mockClient.get(
        Uri.parse(Constants.apiPath),
        headers: anyNamed('headers'),
      ),
    ).thenThrow(Exception(Constants.unknownError));

    // expect that calling the data source's getImages method throws a ServerException
    expect(
      dataSource.getImages(),
      throwsA(
        isA<ServerException>(),
      ),
    );
  });
}
