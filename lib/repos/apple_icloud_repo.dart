import 'dart:async';

import 'package:icloud_storage/icloud_storage.dart';
import 'package:what_to_do/config.dart';

import 'package:what_to_do/repos/base_cloud_repo.dart';

class AppleICloudRepo extends BaseCloudRepo {
  AppleICloudRepo() : super();

  String icloudPath = 'organizly';

  @override
  Future<List<ICloudFile>> gather() async {
    return await ICloudStorage.gather(
        containerId: config['cloud']['apple']['ICLOUD_CONTAINER_ID']);
  }

  @override
  upload({required String path, required String dbName}) async {
    print('relativePath: $icloudPath/$dbName.db, destinationFilePath: $path');

    await ICloudStorage.upload(
      containerId: config['cloud']['apple']['ICLOUD_CONTAINER_ID'],
      filePath: path,
      destinationRelativePath: '$icloudPath/$dbName.db',
      onProgress: (stream) {
        stream.listen(
          (progress) => print('Upload File Progress: $progress'),
          onDone: () => print('Upload File Done'),
          onError: (err) => print('Upload File Error: $err'),
          cancelOnError: true,
        );
      },
    );
  }

  @override
  download(
      {required String path,
      required String dbName,
      required Function onDone}) async {
    print('relativePath: $icloudPath/$dbName.db, destinationFilePath: $path');

    await ICloudStorage.download(
      containerId: config['cloud']['apple']['ICLOUD_CONTAINER_ID'],
      relativePath: '$icloudPath/$dbName.db',
      destinationFilePath: path,
      onProgress: (stream) {
        stream.listen(
          (progress) => print('Download File Progress: $progress'),
          onDone: () {
            print('Download File Done');
            onDone();
          },
          onError: (err) => print('Download File Error: $err'),
          cancelOnError: true,
        );
      },
    );
  }
}
