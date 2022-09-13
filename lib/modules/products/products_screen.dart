import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/styles/colors.dart';

import '../../shared/app_cubit/cubit.dart';
import '../../shared/app_cubit/states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit  = AppCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.homeModel != null && cubit.categoriesModel != null ,
            builder: (context)=>productsBuilder(cubit.homeModel!, cubit.categoriesModel!,context),
            fallback: (context)=>const Center(child: CircularProgressIndicator()),
        );
      },

    );
  }

  Widget productsBuilder(HomeModel model , CategoriesModel categoriesModel,context)=>SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items: model.data.banners.map((e) => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: NetworkImage(e.image),
              width: double.infinity,
              fit: BoxFit.fill,
            ),

          )).toList(),
          options: CarouselOptions(
            height: 180,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            viewportFraction: 0.809,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
          ),),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Categories',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,

                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 90.0,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index)=>buildCategoryItem(categoriesModel.data.data[index]),
                    separatorBuilder: (context , index)=>const SizedBox(width: 10,),
                    itemCount: categoriesModel.data.data.length,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'New products',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,

                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 1 / 1.62,  //width / height
            children: List.generate(
                model.data.products.length,
                    (index) => buildGridProduct(model.data.products[index],context),
            ),


          ),
        )
      ],
    ),
  );

  Widget buildCategoryItem(DataModel model)=>SizedBox(
    height: 90.00,
    width: 90.0,
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
         Image(
          image: NetworkImage(model.image),
          height: 100.00,
          width: 100.0,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(.8),
          width: double.infinity,
          child:  Text(
            model.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );

  Widget buildGridProduct(ProductModel model ,context)=>Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
                image: NetworkImage(model.image),
              width: double.infinity,
              height: 200,
            ),
            if(model.discount !=0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: Colors.red,

              child: Text('${model.discount}% OFF', style: const TextStyle(color: Colors.white,fontSize: 12.0) ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0,left: 12.0,right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow:TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  height: 1.1,
                  fontSize: 14.0
                ),
                // style: const TextStyle(
                //   height: 1.1,
                //   fontSize: 14.0
                // ),
              ),
              Row(
                children: [
                  Text(
                    '${model.price} \$',
                    maxLines: 2,
                    overflow:TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: defaultColor,

                    ),
                  ),
                  const SizedBox(width: 5,),
                  if(model.discount !=0)
                  Text(
                    '${model.oldPrice}',
                    maxLines: 2,
                    overflow:TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,


                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: (){
                      AppCubit.get(context).changeFavorites(model.id);
                    },
                    icon: AppCubit.get(context).favorites[model.id]!? const Icon(Icons.favorite,size: 20,color: defaultColor,): const Icon(Icons.favorite_border,size: 20,),
                  //  constraints: const BoxConstraints(),
                   // padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

}
