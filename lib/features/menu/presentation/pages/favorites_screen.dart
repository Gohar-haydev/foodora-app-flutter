import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:foodora/features/menu/presentation/pages/menu_item_detail_screen.dart';
import 'package:foodora/features/menu/presentation/widgets/widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    // Fetch favorites on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchFavoritesList(page: 1);
    });
    
    // Setup pagination scroll listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      final viewModel = context.read<MenuViewModel>();
      if (viewModel.hasFavoritesMore && !viewModel.isFavoritesLoadingMore) {
        viewModel.loadMoreFavorites();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<MenuViewModel>().fetchFavoritesList(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.tr('my_favorites'),
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Consumer<MenuViewModel>(
            builder: (context, viewModel, child) {
              // Loading state
              if (viewModel.isFavoritesLoading && viewModel.favoriteItems.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                  ),
                );
              }

              // Error state
              if (viewModel.favoritesListError != null && viewModel.favoriteItems.isEmpty) {
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
                        viewModel.favoritesListError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: AppDimensions.getBodySize(context),
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchFavoritesList(page: 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(context.tr('retry')),
                      ),
                    ],
                  ),
                );
              }

              // Empty state
              if (viewModel.favoriteItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: AppDimensions.responsiveIconSize(context, mobile: 80, tablet: 100),
                        color: AppColors.grey300,
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      Text(
                        context.tr('no_favorites_yet'),
                        style: TextStyle(
                          fontSize: AppDimensions.getH3Size(context),
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey600,
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                      Text(
                        context.tr('start_adding_favorites'),
                        style: TextStyle(
                          fontSize: AppDimensions.getSmallSize(context),
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Favorites list with pull to refresh
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primaryAccent,
                child: GridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(
                    AppDimensions.getResponsiveHorizontalPadding(context),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppDimensions.getGridColumns(context),
                    crossAxisSpacing: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                    mainAxisSpacing: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                    childAspectRatio: 0.75,
                  ),
                  itemCount: viewModel.favoriteItems.length + (viewModel.hasFavoritesMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= viewModel.favoriteItems.length) {
                      // Loading indicator for pagination
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                          ),
                        ),
                      );
                    }

                    final item = viewModel.favoriteItems[index];
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
                      child: FavoriteItemCard(
                        item: item,
                        onRemove: () async {
                          final message = await viewModel.removeFromFavorites(item.id);
                          if (context.mounted) {
                            // Refresh the list after removing
                            await viewModel.fetchFavoritesList(page: 1);
                            
                            if (message != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: AppColors.primaryAccent,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
