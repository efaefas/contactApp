import 'package:permission_handler/permission_handler.dart';

Future<bool> getPermission(Permission perm) async {
  if (await perm.request().isGranted) {
    return true;
  }
  PermissionStatus? permission = await perm.status;
  switch(permission){
    case PermissionStatus.denied:
      return false;
    case PermissionStatus.granted:
      return true;
    case PermissionStatus.restricted:
      return false;
    case PermissionStatus.limited:
      return true;
    case PermissionStatus.permanentlyDenied:
      return false;
    case PermissionStatus.provisional:
      return true;
      break;
  }
}