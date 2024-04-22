import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String? title, date, explanation, imgUrl;

  const ImageEntity({
    this.title,
    this.date,
    this.explanation,
    this.imgUrl,
  });

  @override
  List<Object> get props => [
        title!,
        date!,
        explanation!,
        imgUrl!,
      ];
}
