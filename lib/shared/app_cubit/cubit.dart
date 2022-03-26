import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/app_cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(this.isDark) : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
bool isDark;
  void changeAppMode(){
    isDark=!isDark;
    CacheHelper.setBoolean(key: 'isDark', value: isDark);
    emit(AppChangeStateMode());

  }
}