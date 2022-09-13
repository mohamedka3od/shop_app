

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/register/cubit/states.dart';

import '../../../models/login_model.dart';
import '../../../network/end_points.dart';
import '../../../network/remote/dio_helper.dart';
import '../../../shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  late LoginModel loginModel ;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }){
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data:
      {
        'name':name,
        'email':email,
        'password': password,
        'phone':phone,
      },
    ).then((value)
    {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel.status);
      print(loginModel.message);
      print(loginModel.data!.token);
      token = loginModel.data!.token!;
      emit(RegisterSuccessState(loginModel));
    }).catchError((error){
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }


  IconData suffix  = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility (){
    isPassword = !isPassword;

    suffix =isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());

  }
}