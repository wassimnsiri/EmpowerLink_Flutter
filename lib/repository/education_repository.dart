import '../model/education.dart';
import '../api/network/api_service.dart';
import '../api/network/http_method.dart';
import '../env.dart';

class EducationRepository {
  static const String apiUrl = "$baseUrl/education/back-office";

  static Future<Education> getById(String id) async {
    final Map<String, dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/one/$id",
      httpMethod: HttpMethod.get,
    );

    return Education.fromJson(json["data"]);
  }

  static Future<List<Education>> getAll() async {
    final List<dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.get,
    );

    return List<Education>.from(json.map((model) => Education.fromJson(model)))
        .reversed
        .toList();
  }

  static Future<bool> add(Education education) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.post,
      body: education.toJson(),
    );

    return true;
  }

  static Future<bool> update(Education education) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.put,
      body: education.toJson(),
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
