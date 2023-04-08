import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {


  Future<String> downloadAndCacheImage(String imageUrl) async {
    DefaultCacheManager cacheManager = DefaultCacheManager();
    File imageFile = await cacheManager.getSingleFile(imageUrl);
    Directory appDir = await getApplicationDocumentsDirectory();
    String appPath = appDir.path;
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    File newImageFile = await imageFile.copy('$appPath/$fileName');
    await cacheManager.removeFile(imageUrl);
    return newImageFile.path;
  }

}
