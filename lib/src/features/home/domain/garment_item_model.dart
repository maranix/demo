import 'package:equatable/equatable.dart';

class GarmentItem extends Equatable {
  const GarmentItem({
    required this.id,
    required this.name,
    required this.displayUrl,
  });

  final String id;
  final String name;
  final String displayUrl;

  factory GarmentItem.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': String id,
      'name': String name,
      'displayUrl': String displayUrl,
    }) {
      return GarmentItem(id: id, name: name, displayUrl: displayUrl);
    } else {
      throw FormatException('GarmentItem: Invalid Json', json);
    }
  }

  @override
  List<Object> get props => [id, name, displayUrl];
}
