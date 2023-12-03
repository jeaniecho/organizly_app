import 'package:http/http.dart';

class BaseCloudRepo {
  Client? client;
  dynamic cloud;

  BaseCloudRepo();

  clearData() {
    client = null;
    cloud = null;
  }

  gather() {}

  upload({required String path, required String dbName}) {}

  download(
      {required String path,
      required String dbName,
      required Function() onDone}) {}
}
