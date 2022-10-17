import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizecart/services/service_repository.dart';

final serviceControllerProvider = Provider((ref) {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return ServiceController(ref: ref, serviceRepository: serviceRepository);
});

class ServiceController {
  final ServiceRepository serviceRepository;
  final ProviderRef ref;
  ServiceController({this.serviceRepository, this.ref});

  Future<String> getUserAddress() {
    return serviceRepository.getUserAddress();
  }
}
