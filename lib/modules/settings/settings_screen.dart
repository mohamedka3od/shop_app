import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/app_cubit/cubit.dart';
import 'package:shop_app/shared/app_cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({Key? key}) : super(key: key);
   final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController  = TextEditingController();
  final phoneController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context ,state){

      },
      builder: (context ,state){
          var model = AppCubit.get(context).userModel;
          nameController.text = model!.data!.name!;
          emailController.text = model.data!.email! ;
          phoneController.text = model.data!.phone! ;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConditionalBuilder(
            condition: AppCubit.get(context).userModel != null,
            builder: (context)=>SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is LoadingUpdateUserDataState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 20.0,),
                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (value){
                          if(value.isEmpty){
                            return 'name must not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: Icons.person
                    ),
                    const SizedBox(height: 20.0,),
                    defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value){
                          if(value.isEmpty){
                            return 'email must not be empty';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email
                    ),
                    const SizedBox(height: 20.0,),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value){
                          if(value.isEmpty){
                            return 'phone must not be empty';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: Icons.phone
                    ),
                    const SizedBox(height: 20.0,),
                    defaultButton(function: (){
                      if(formKey.currentState!.validate()){
                        AppCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      }

                    }, text: 'UpDate'),
                    const SizedBox(height: 20.0,),
                    defaultButton(function: (){
                      signOut(context);
                      nameController.text = '';
                      emailController.text = '' ;
                      phoneController.text = '';
                      AppCubit.get(context).userModel = null;
                    }, text: 'LogOut'),

                  ],
                ),
              ),
            ),
            fallback: (context)=>const Center(child: CircularProgressIndicator()),
          ),
        );
      },

    );
  }
}
