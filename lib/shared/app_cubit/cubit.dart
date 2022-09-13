import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/favourites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/app_cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../models/change_favorites_model.dart';
import '../../modules/products/products_screen.dart';
import '../../models/login_model.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit({this.isDark}) : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
late bool? isDark;
  void changeAppMode(){
    isDark=!isDark!;
    CacheHelper.setBoolean(key: 'isDark', value: isDark!);
    emit(AppChangeStateMode());

  }

  int currentIndex = 0;
  List<Widget> bottomScreens=[
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }
  HomeModel? homeModel;
  Map<int , bool>favorites={};
  void getHomeData(){
    emit(LoadingHomeDataState());
    DioHelper.getData(
        url: HOME,
      token: token,
    ).then((value){
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel!.data.banners[0].image);
      // print(homeModel!.status);
      for (var element in homeModel!.data.products) {
        favorites.addAll({
          element.id:element.inFavorites
        });
      }
      print(favorites.toString());

      emit(SuccessHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(ErrorHomeDataState());
    });
  }
  CategoriesModel? categoriesModel;
  void getCategories(){
    DioHelper.getData(
        url: GET_CATEGORIES,
      token: token,
    ).then((value){
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(SuccessCategoriesState());
    }).catchError((error){
      print(error.toString());
      emit(ErrorCategoriesState());
    });
  }

  late ChangeFavoritesModel changeFavoritesModel;
  void changeFavorites(int productId){
   favorites[productId] = !favorites[productId]!;
   emit(ChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        data: {'product_id':productId},
        token: token
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if(!changeFavoritesModel.status){
        favorites[productId] = !favorites[productId]!;
        showToast(text: changeFavoritesModel.message, state: ToastStates.ERROR);
      }
      else{
        getFavorites();
      }
      print(changeFavoritesModel.message);

      emit(SuccessChangeFavoritesState());
    }).catchError((error){
      favorites[productId] = !favorites[productId]!;
      emit(ErrorChangeFavoritesState());

    });
    favorites[productId] != favorites[productId];
  }


  FavoritesModel? favoritesModel;
  void getFavorites()
  {
    emit(LoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value){
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(SuccessGetFavoritesState());
    }).catchError((error){
      print(error.toString());
      emit(ErrorGetFavoritesState());
    });
  }

  LoginModel? userModel;
  void getUserData(){
    emit(LoadingGetUserDataState());
    DioHelper.getData(
        url: PROFILE,
      token: token,
    ).then((value) {
      userModel =LoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(SuccessGetUserDataState());

    }).catchError((error){
      print(error);
      emit(ErrorGetUserDataState());

    });


  }


  void updateUserData({
  required String? name,
  required String? email,
  required String? phone,
}){
    emit(LoadingUpdateUserDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value) {
      userModel =LoginModel.fromJson(value.data);
      emit(SuccessUpdateUserDataState(userModel!));

    }).catchError((error){
      print(error);
      emit(ErrorUpdateUserDataState());

    });


  }




}