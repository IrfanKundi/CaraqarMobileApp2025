

import 'dart:io';

import 'package:careqar/ui/widgets/alerts.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveFile{

 static Future<File?> downloadFile(String url,String name)async{

   Directory directory;

   if (Platform.isAndroid) {
     if (await _requestPermission(Permission.storage)) {
       directory = await getApplicationDocumentsDirectory();
       String newPath = "";
       List<String> paths = directory.path.split("/");
       for (int x = 1; x < paths.length; x++) {
         String folder = paths[x];
         if (folder != "Android") {
           newPath += "/$folder";
         } else {
           break;
         }
       }
       newPath = "$newPath/CarAqar";
       directory = Directory(newPath);
     } else {
       showSnackBar(message: "StoragePermissionDenied");  return null;
     }
   } else {
     if (await _requestPermission(Permission.storage)) {
       directory = await getTemporaryDirectory();
     } else {
       showSnackBar(message: "StoragePermissionDenied");  return null;
     }
   }
   if (!await directory.exists()) {
     await directory.create(recursive: true);
   }
     final File file = File("${directory.path}/$name");
    final response=await Dio().get(url,options:Options(responseType:ResponseType.bytes,followRedirects:false,
    receiveTimeout:const Duration(seconds: 3),
    ));
    final raf=file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }




  static  Future<bool> _requestPermission(Permission permission) async {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
      return false;
    }




 static Future<void> getAppFolderPath()async{

   Directory directory;

   if (Platform.isAndroid) {
     if (await _requestPermission(Permission.storage)) {
       directory = await getApplicationDocumentsDirectory();
       String newPath = "";
       List<String> paths = directory.path.split("/");
       for (int x = 1; x < paths.length; x++) {
         String folder = paths[x];
         if (folder != "Android") {
           newPath += "/$folder";
         } else {
           break;
         }
       }
       newPath = "$newPath/CarAqar";
       directory = Directory(newPath);
     }
     else {
       showSnackBar(message: "StoragePermissionDenied");  return null;
     }
   }



   else {
     if (await _requestPermission(Permission.storage)) {
       directory = await getTemporaryDirectory();
     } else {
       showSnackBar(message: "StoragePermissionDenied");  return null;
     }
   }



   if (!await directory.exists()) {
     await directory.create(recursive: true);
   }



 }

}