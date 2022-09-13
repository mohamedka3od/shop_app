import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/app_cubit/cubit.dart';
import 'package:shop_app/shared/app_cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context , state){},
      builder: (context, state){
        var cubit = AppCubit.get(context);
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder:(context , index) =>buildCatItem(cubit.categoriesModel!.data.data[index],context),
          separatorBuilder: (context , index )=>const Divider(),
          itemCount: cubit.categoriesModel!.data.data.length
      );
        },
    ) ;
  }

  Widget buildCatItem(DataModel model ,context)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
    child: Row(
      children:  [
        Image(
          image: NetworkImage(model.image),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: Text(
            model.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            // style: const TextStyle(
            //   fontSize: 20.0,
            //   fontWeight: FontWeight.bold,
            // ),
          ),
        ),
         Icon(Icons.arrow_forward_ios,color: Theme.of(context).iconTheme.color,),
      ],
    ),
  );
}
