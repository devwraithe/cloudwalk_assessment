import 'package:cloudwalk_assessment/app/core/utilities/constants.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String? title, date, explanation, imgUrl;

  const ImageModel({
    this.title,
    this.date,
    this.explanation,
    this.imgUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      title: json['title'] ?? "",
      date: json['date'] ?? "",
      explanation: json['explanation'] ?? "",
      imgUrl: json['hdurl'] ?? Constants.backupImage,
    );
  }

  ImageEntity toEntity() {
    return ImageEntity(
      title: title,
      date: date,
      explanation: explanation,
      imgUrl: imgUrl,
    );
  }

  @override
  List<Object> get props => [
        title!,
        date!,
        explanation!,
        imgUrl!,
      ];
}
