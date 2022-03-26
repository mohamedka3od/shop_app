import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../layout/shop_layout.dart';

class LoginScreen extends StatelessWidget {
    LoginScreen({Key? key}) : super(key: key);
   final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (BuildContext context, state) {
          if(state is LoginSuccessState){
            if(state.loginModel.status){
              print(state.loginModel.message);
              print(state.loginModel.data?.token);
              CacheHelper.saveData(key: 'token', value: state.loginModel.data?.token).then((value){
                navigateAndFinish(context, const ShopLayout());
              });
            }
            else{
              print(state.loginModel.message);
              showToast(text: state.loginModel.message, state:ToastStates.ERROR );
            }
          }
        },
        builder: (BuildContext context, Object? state)
        {
         return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        Text(
                          "Login now to browse hot offers",
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          prefix: Icons.email_outlined,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          prefix: Icons.lock_outline,
                          suffix: LoginCubit.get(context).suffix,
                          suffixPressed: () {
                            LoginCubit.get(context).changePasswordVisibility();
                          },
                          onSubmit: (value){
                            if (formKey.currentState!.validate()){
                              LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text
                              );
                            }
                          },
                          isPassword: LoginCubit.get(context).isPassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          type: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          fallback: (BuildContext context) => const Center(child: CircularProgressIndicator()),
                          builder: (BuildContext context) => defaultButton(
                            function: () {

                              if (formKey.currentState!.validate()){
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                            },
                            text: 'Login',
                          ),

                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            defaultTextButton(
                                function: () {
                                  navigateTo(context, const RegisterScreen());
                                },
                                text: 'register'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
