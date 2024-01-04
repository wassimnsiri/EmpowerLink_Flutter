import '../api/network/api_service.dart';
import '../api/network/http_method.dart';
import '../env.dart';
import '../model/formation.dart';

class FormationRepository {
  static const String apiUrl = "$baseUrl/formation/back-office";

  static Future<Formation> getById(String id) async {
    final Map<String, dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/one/$id",
      httpMethod: HttpMethod.get,
    );

    return Formation.fromJson(json["data"]);
  }

  static Future<List<Formation>> getAll() async {
    final List<dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.get,
    );

    return List<Formation>.from(json.map((model) => Formation.fromJson(model)))
        .reversed
        .toList();
  }

  static Future<bool> add(Formation formation) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.post,
      body: formation.toJson(),
    );

    return true;
  }

  static Future<bool> update(Formation formation) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.put,
      body: formation.toJson(),
    );

    return true;
  }

  static Future<bool> delete(String id) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/$id",
      httpMethod: HttpMethod.delete,
    );

    return true;
  }
}
