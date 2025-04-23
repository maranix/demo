import 'package:demo/src/features/home/domain/get_all_garments_response.dart';

abstract interface class FashionRepository {
  Future<GetAllGarmentsResponse> getAllGarments();
}
