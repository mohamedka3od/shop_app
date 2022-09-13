import '../../models/login_model.dart';

abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeStateMode extends AppStates{}

class AppChangeBottomNavState extends AppStates{}

class LoadingHomeDataState extends AppStates{}
class SuccessHomeDataState extends AppStates{}
class ErrorHomeDataState extends AppStates{}

class LoadingCategoriesState extends AppStates{}
class SuccessCategoriesState extends AppStates{}
class ErrorCategoriesState extends AppStates{}

class ChangeFavoritesState extends AppStates{}
class SuccessChangeFavoritesState extends AppStates{}
class ErrorChangeFavoritesState extends AppStates{}

class LoadingGetFavoritesState extends AppStates{}
class SuccessGetFavoritesState extends AppStates{}
class ErrorGetFavoritesState extends AppStates{}

class LoadingGetUserDataState extends AppStates{}
class SuccessGetUserDataState extends AppStates{}
class ErrorGetUserDataState extends AppStates{}

class LoadingUpdateUserDataState extends AppStates{}
class SuccessUpdateUserDataState extends AppStates{
   final LoginModel loginModel;
   SuccessUpdateUserDataState(this.loginModel);

}
class ErrorUpdateUserDataState extends AppStates{}
