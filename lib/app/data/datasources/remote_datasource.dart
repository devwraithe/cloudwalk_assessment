import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudwalk_assessment/app/core/utilities/errors/failure.dart';
import 'package:cloudwalk_assessment/app/data/models/image_model.dart';
import 'package:http/http.dart';

import '../../core/utilities/constants.dart';
import '../../core/utilities/errors/exceptions.dart';

abstract class RemoteDataSource {
  Future<List<ImageModel>> getImages();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Client client;
  const RemoteDataSourceImpl(this.client);

  @override
  Future<List<ImageModel>> getImages() async {
    try {
      final url = Uri.parse(Constants.apiPath);
      final Response response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      final data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ServerException(Failure(Constants.serverError));
      }

      final List<ImageModel> images = data.map<ImageModel>((image) {
        return ImageModel.fromJson(image);
      }).toList();
      return images;
    } on SocketException {
      throw NetworkException(Failure(Constants.lostConnection));
    } on TimeoutException {
      throw RequestTimeoutException(Failure(Constants.timeout));
    } catch (e) {
      throw ServerException(Failure(Constants.unknownError));
    }
  }
}
