import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:foodora/core/providers/currency_provider.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/features/menu/presentation/pages/menu_item_detail_screen.dart';
import 'package:foodora/features/menu/presentation/widgets/recipe_card.dart';

/// Screen to display all menu items for a selected category
class CategoryItemsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryItemsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch menu items for this category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchMenuItemsByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Consumer<MenuViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isMenuItemsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryAccent,
              ),
            );
          }

          if (viewModel.menuItemsError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.responsiveIconSize(context, mobile: 48, tablet: 60),
                    color: AppColors.grey,
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                  Text(
                    viewModel.menuItemsError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: AppDimensions.getBodySize(context),
                    ),
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.fetchMenuItemsByCategory(widget.categoryId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: AppColors.white,
                    ),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          if (viewModel.menuItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu_outlined,
                    size: AppDimensions.responsiveIconSize(context, mobile: 64, tablet: 80),
                    color: AppColors.grey300,
                  ),
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                  Text(
                    context.tr('no_menu_items'),
                    style: TextStyle(
                      fontSize: AppDimensions.getBodySize(context),
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppDimensions.isTablet(context) ? 3 : 2,
                crossAxisSpacing: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                mainAxisSpacing: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                childAspectRatio: 0.75,
              ),
              itemCount: viewModel.menuItems.length,
              itemBuilder: (context, index) {
                final item = viewModel.menuItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MenuItemDetailScreen(
                          menuItemId: item.id,
                        ),
                      ),
                    );
                  },
                  child: RecipeCard(
                    title: item.name,
                    price: '${context.tr('from')} ${currencyProvider.formatPrice(double.tryParse(item.price.toString()) ?? 0)}',
                    image: item.imageUrl ?? 'assets/images/kebabpizza.jpg',
                    menuItemId: item.id,
                    isFavorite: viewModel.isFavorite(item.id),
                    onFavoriteTap: () async {
                      await viewModel.checkFavoriteStatus(item.id);
                      if (!context.mounted) return;
                      
                      final message = await viewModel.toggleFavorite(item.id);
                      if (context.mounted && message != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: viewModel.favoritesError != null
                                ? AppColors.error
                                : AppColors.primaryAccent,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
