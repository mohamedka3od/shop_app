import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/app_cubit/cubit.dart';
import 'package:shop_app/shared/app_cubit/states.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/themes.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CacheHelper.init();
      DioHelper.init();
      bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
      Widget widget;
      bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
      token = CacheHelper.getData(key: 'token');
      if(onBoarding){
        if(token != null){
          widget = const ShopLayout();
        }
        else{
          widget = LoginScreen();
        }
      }
      else{
        widget = const OnBoardingScreen();
      }
      runApp(MyApp(isDark:isDark,startWidget:widget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;
  const MyApp({required this.isDark,required this.startWidget, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit(isDark: isDark)..getHomeData()..getCategories()..getFavorites()..getUserData()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: AppCubit.get(context).isDark! ? ThemeMode.dark:ThemeMode.light,
            darkTheme: darkTheme,

            home:  Directionality(
                textDirection: TextDirection.ltr,
                child: startWidget,
          ));
        },
      ),
    );
  }
}
