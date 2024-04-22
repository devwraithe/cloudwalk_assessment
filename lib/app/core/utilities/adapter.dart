import 'package:hive/hive.dart';

import '../../domain/entities/image_entity.dart';

class ImageEntityAdapter extends TypeAdapter<ImageEntity> {
  @override
  final int typeId = 0; // Unique identifier for the adapter

  @override
  ImageEntity read(BinaryReader reader) {
    final title = reader.readString();
    final date = reader.readString();
    final imageUrl = reader.readString();
    final explanation = reader.readString();
    return ImageEntity(
      title: title,
      date: date,
      imgUrl: imageUrl,
      explanation: explanation,
    );
  }

  @override
  void write(BinaryWriter writer, ImageEntity obj) {
    writer.writeString(obj.title!);
    writer.writeString(obj.date!);
    writer.writeString(obj.imgUrl!);
    writer.writeString(obj.explanation!);
  }
}
