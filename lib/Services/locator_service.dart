import 'package:ambulance_dispatch_application/Services/navigation_and_dialog_service.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/Authentication/authentication.dart';
import 'package:ambulance_dispatch_application/View_Models/User_Management/user_management.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() async {
  locator.registerLazySingleton<UserManager>(
    () => UserManager(),
  );
  locator.registerLazySingleton<UserAuthentication>(
    () => UserAuthentication(),
  );
  // locator.registerLazySingleton<AdminManagementView>(
  //   () => AdminManagementView(),
  // );
  // locator.registerLazySingleton<StudentAccommodationManagementView>(
  //   () => StudentAccommodationManagementView(),
  // );
  // locator.registerLazySingleton<LandlordManagementView>(
  //   () => LandlordManagementView(),
  // );
  // locator.registerLazySingleton<StudentManagementView>(
  //   () => StudentManagementView(),
  // );

  locator.registerLazySingleton<NavigationAndDialogService>(
    () => NavigationAndDialogService(),
  );
}
