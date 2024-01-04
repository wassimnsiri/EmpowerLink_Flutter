import '../model/education.dart';
import '../api/response/api_response.dart';
import '../repository/education_repository.dart';
import 'base_view_model.dart';

class EducationViewModel extends BaseViewModel<Education> {
  Future<ApiResponse> getById({required String id}) async {
    return await makeApiCall(apiCall: () => EducationRepository.getById(id));
  }

  Future<ApiResponse> getAll() async {
    return await makeApiCall(apiCall: () => EducationRepository.getAll());
  }

  Future<ApiResponse> add({required Education education}) async {
    return await makeApiCall(
      apiCall: () => EducationRepository.add(education),
    );
  }

  Future<ApiResponse> update({required Education education}) async {
    return await makeApiCall(
      apiCall: () => EducationRepository.update(education),
    );
  }

  Future<ApiResponse> delete({required String id}) async {
    return await makeApiCall(apiCall: () => EducationRepository.delete(id));
  }
}
