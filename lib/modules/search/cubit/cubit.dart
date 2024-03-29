

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../../network/end_points.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);
  late SearchModel model;
  void search(String text){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        data:{
          'text' : text,
        },
      token: token,
    ).then((value){
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());

    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());

    });
  }


}