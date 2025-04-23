import 'package:demo/src/features/home/domain/garment_item_model.dart';
import 'package:equatable/equatable.dart';

final class GetAllGarmentsResponse extends Equatable {
  const GetAllGarmentsResponse({required this.male, required this.female});

  final GenderGarments male;

  final GenderGarments female;

  factory GetAllGarmentsResponse.fromJson(Map<String, dynamic> json) {
    if (json case {
      'MALE': Map<String, dynamic> male,
      'FEMALE': Map<String, dynamic> female,
    }) {
      return GetAllGarmentsResponse(
        male: GenderGarments.fromJson(male),
        female: GenderGarments.fromJson(female),
      );
    } else {
      throw FormatException('GetAllGarmentsResponse: Invalid Format', json);
    }
  }

  @override
  List<Object> get props => [male, female];
}

final class GenderGarments extends Equatable {
  const GenderGarments({
    required this.top,
    required this.bottom,
    required this.dress,
  });

  final List<GarmentItem> top;

  final List<GarmentItem> bottom;

  final List<GarmentItem> dress;

  factory GenderGarments.fromJson(Map<String, dynamic> json) {
    if (json case {
      'TOP': List<dynamic> top,
      'BOTTOM': List<dynamic> bottom,
      'DRESS': List<dynamic> dress,
    }) {
      return GenderGarments(
        top:
            top.cast<Map<String, dynamic>>().map(GarmentItem.fromJson).toList(),
        bottom:
            bottom
                .cast<Map<String, dynamic>>()
                .map(GarmentItem.fromJson)
                .toList(),

        dress:
            dress
                .cast<Map<String, dynamic>>()
                .map(GarmentItem.fromJson)
                .toList(),
      );
    } else {
      throw FormatException('GenderGarments: Invalid Format', json);
    }
  }

  @override
  List<Object> get props => [top, bottom, dress];
}
