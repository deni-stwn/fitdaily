import '../models/{{entity_name.snakeCase()}}_model.dart';

abstract class {{feature_name.pascalCase()}}LocalDataSource {
  Future<List<{{entity_name.pascalCase()}}Model>> fetch{{entity_name.pascalCase()}}s();
}

/// Returns dummy data (no backend).
/// Replace with a remote data source once an API is available.
class {{feature_name.pascalCase()}}LocalDataSourceImpl
    implements {{feature_name.pascalCase()}}LocalDataSource {
  {{feature_name.pascalCase()}}LocalDataSourceImpl();

  @override
  Future<List<{{entity_name.pascalCase()}}Model>> fetch{{entity_name.pascalCase()}}s() async {
    // Simulates latency so loading states stay visible while slicing.
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: replace with dummy data matching the design
    // (inline list, or a JSON file in assets/dummy/ like the `home` feature).
    return const [];
  }
}
