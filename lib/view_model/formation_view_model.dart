import '../api/response/api_response.dart';
import '../model/formation.dart';
import '../repository/formation_repository.dart';
import 'base_view_model.dart';

class FormationViewModel extends BaseViewModel<Formation> {
  Future<ApiResponse> getById({required String id}) async {
    return await makeApiCall(apiCall: () => FormationRepository.getById(id));
  }

  Future<ApiResponse> getAll() async {
    return await makeApiCall(apiCall: () => FormationRepository.getAll());
  }

  Future<ApiResponse> add({required Formation formation}) async {
    return await makeApiCall(
      apiCall: () => FormationRepository.add(formation),
    );
  }

  Future<ApiResponse> update({required Formation formation}) async {
    return await makeApiCall(
      apiCall: () => FormationRepository.update(formation),
    );
  }

  Future<ApiResponse> delete({required String id}) async {
    return await makeApiCall(apiCall: () => FormationRepository.delete(id));
  }
}
