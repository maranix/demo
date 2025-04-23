import 'dart:convert';

import 'package:demo/src/core/constants/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:demo/src/features/home/data/fashion_repository.dart';
import 'package:demo/src/features/home/domain/get_all_garments_response.dart';

final class FashionAppRepository implements FashionRepository {
  FashionAppRepository({String? baseURL, http.Client? client})
    : _baseURL = baseURL ?? "https://fashionapp.getstudioai.com/api",
      _client = client ?? http.Client();

  final String _baseURL;

  final http.Client _client;

  @override
  Future<GetAllGarmentsResponse> getAllGarments() async {
    final uri = Uri.parse("$_baseURL/garments/get-all-garments");
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      return GetAllGarmentsResponse.fromJson(jsonDecode(res.body));
    }

    throw Exception(AppStrings.UNKNOWN_ERROR_OCCURRED);
  }
}
