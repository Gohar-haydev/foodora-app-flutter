import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'core/network/api_service.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/refresh_token_usecase.dart';
import 'features/auth/domain/usecases/get_user_usecase.dart';
import 'features/auth/domain/usecases/update_profile_usecase.dart';
import 'features/auth/domain/usecases/update_password_usecase.dart';
import 'features/auth/domain/usecases/forgot_password_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/menu/data/datasources/menu_remote_data_source_impl.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/menu/domain/usecases/get_branches_usecase.dart';
import 'features/menu/domain/usecases/get_categories_usecase.dart';
import 'features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'features/menu/domain/usecases/get_menu_items_by_category_usecase.dart';
import 'features/menu/domain/usecases/add_to_favorites_usecase.dart';
import 'features/menu/domain/usecases/remove_from_favorites_usecase.dart';
import 'features/menu/domain/usecases/get_favorites_usecase.dart';
import 'features/menu/domain/usecases/search_menu_items_usecase.dart';
import 'features/menu/domain/usecases/get_menu_items_by_category_filter_usecase.dart';
import 'features/menu/domain/usecases/get_menu_item_details_usecase.dart';
import 'features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'features/order/presentation/viewmodels/order_viewmodel.dart';

void main() {
  runApp(const FoodieApp());
}

class FoodieApp extends StatelessWidget {
  const FoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize Core Services
    final apiService = ApiService();

    // 2. Initialize Data Sources
    final authRemoteDataSource = AuthRemoteDataSourceImpl(apiService: apiService);

    // 3. Initialize Repositories
    final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

    // 4. Initialize Use Cases
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final refreshTokenUseCase = RefreshTokenUseCase(authRepository);
    final getUserUseCase = GetUserUseCase(authRepository);
    final updateProfileUseCase = UpdateProfileUseCase(authRepository);
    final updatePasswordUseCase = UpdatePasswordUseCase(authRepository);
    final forgotPasswordUseCase = ForgotPasswordUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    
    // Menu Feature Dependencies
    final menuRemoteDataSource = MenuRemoteDataSourceImpl(apiService);
    final menuRepository = MenuRepositoryImpl(menuRemoteDataSource);
    final getBranchesUseCase = GetBranchesUseCase(menuRepository);
    final getCategoriesUseCase = GetCategoriesUseCase(menuRepository);
    final getMenuItemsUseCase = GetMenuItemsUseCase(menuRepository);
    final getMenuItemsByCategoryUseCase = GetMenuItemsByCategoryUseCase(menuRepository);
    final addToFavoritesUseCase = AddToFavoritesUseCase(menuRepository);
    final removeFromFavoritesUseCase = RemoveFromFavoritesUseCase(menuRepository);
    final getFavoritesUseCase = GetFavoritesUseCase(menuRepository);
    final searchMenuItemsUseCase = SearchMenuItemsUseCase(menuRepository);
    final getMenuItemsByCategoryFilterUseCase = GetMenuItemsByCategoryFilterUseCase(menuRepository);
    final getMenuItemDetailsUseCase = GetMenuItemDetailsUseCase(menuRepository);

    // 5. Initialize ViewModels (Providers)
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            refreshTokenUseCase: refreshTokenUseCase,
            getUserUseCase: getUserUseCase,
            updateProfileUseCase: updateProfileUseCase,
            updatePasswordUseCase: updatePasswordUseCase,
            forgotPasswordUseCase: forgotPasswordUseCase,
            resetPasswordUseCase: resetPasswordUseCase,
            logoutUseCase: logoutUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MenuViewModel(
            getBranchesUseCase: getBranchesUseCase,
            getCategoriesUseCase: getCategoriesUseCase,
            getMenuItemsUseCase: getMenuItemsUseCase,
            getMenuItemsByCategoryUseCase: getMenuItemsByCategoryUseCase,
            addToFavoritesUseCase: addToFavoritesUseCase,
            removeFromFavoritesUseCase: removeFromFavoritesUseCase,
            getFavoritesUseCase: getFavoritesUseCase,
            searchMenuItemsUseCase: searchMenuItemsUseCase,
            getMenuItemsByCategoryFilterUseCase: getMenuItemsByCategoryFilterUseCase,
            getMenuItemDetailsUseCase: getMenuItemDetailsUseCase,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          fontFamily: 'Plus Jakarta Sans',
          scaffoldBackgroundColor: AppColors.white,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
