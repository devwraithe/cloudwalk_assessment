import 'package:cloudwalk_assessment/app/data/datasources/local_datasource.dart';
import 'package:cloudwalk_assessment/app/data/datasources/remote_datasource.dart';
import 'package:cloudwalk_assessment/app/data/repositories/repository_impl.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:cloudwalk_assessment/app/domain/repositories/repository.dart';
import 'package:cloudwalk_assessment/app/domain/usecases/get_images_usecase.dart';
import 'package:cloudwalk_assessment/app/presentation/cubits/images_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  ImagesCubit,
  ImagesUsecase,
  Repository,
  RepositoryImpl,
  RemoteDataSource,
  RemoteDataSourceImpl,
  LocalDataSource,
  LocalDataSourceImpl,
  http.Client,
  Box<ImageEntity>,
  HiveInterface,
  MethodChannel,
  Connectivity,
])
void main() {}
