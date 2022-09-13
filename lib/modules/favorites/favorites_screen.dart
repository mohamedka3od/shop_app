import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/app_cubit/cubit.dart';
import 'package:shop_app/shared/app_cubit/states.dart';

import '../../shared/components/list_product.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context , state){},
      builder:(context , state){
        return ConditionalBuilder(
          condition: AppCubit.get(context).favoritesModel?.data?.data != null,
          builder:(context)=> ListView.separated(
            physics: const BouncingScrollPhysics(),
              itemBuilder: (context , index)=>buildListProduct(AppCubit.get(context).favoritesModel!.data!.data![index].product!,context),
              separatorBuilder: (context , index)=> const Divider(),
              itemCount: AppCubit.get(context).favoritesModel!.data!.data!.length
          ),
          fallback:(context)=> const Center(child: CircularProgressIndicator(),),
        );
      } ,
    );
  }

}
