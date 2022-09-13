import 'package:flutter/material.dart';

import '../app_cubit/cubit.dart';
import '../styles/colors.dart';

Widget buildListProduct(model,context ,{bool hasOldPrice = true})=>Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: SizedBox(
    height: 120,
    child: Row(
      mainAxisAlignment:MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image!),
                width: 120,
                height: 120,
              ),
              if(model.discount !=0 && hasOldPrice)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.red,

                  child: Text('${model.discount} OFF', style: const TextStyle(color: Colors.white,fontSize: 12.0) ),
                )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow:TextOverflow.ellipsis,
                  style: const TextStyle(
                      height: 1.1,
                      fontSize: 14.0
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price!} \$',
                      maxLines: 2,
                      overflow:TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: defaultColor,

                      ),
                    ),
                    const SizedBox(width: 5,),
                    if(model.discount !=0 && hasOldPrice)
                      Text(
                        '${model.oldPrice} \$',
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
                        AppCubit.get(context).changeFavorites(model.id!);
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
        ),
      ],
    ),
  ),
);
