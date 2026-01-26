import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/features/menu/presentation/pages/category_screen.dart';
import 'package:foodora/features/menu/presentation/pages/favorites_screen.dart';
import 'package:foodora/features/menu/presentation/pages/menu_item_detail_screen.dart';
import 'package:foodora/features/menu/presentation/widgets/section_header.dart';
import 'package:foodora/features/menu/presentation/widgets/featured_card.dart';
import 'package:foodora/features/menu/presentation/widgets/category_chip.dart';
import 'package:foodora/features/menu/presentation/widgets/recipe_card.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:foodora/core/providers/currency_provider.dart';

class MenuScreen extends StatefulWidget {
  final int branchId;
  
  const MenuScreen({super.key, required this.branchId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Fetch categories and menu items when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MenuViewModel>();
      viewModel.fetchCategories(widget.branchId);
      viewModel.fetchMenuItems(widget.branchId);
      viewModel.fetchFavoritesList(page: 1);
    });
  }


  // Get greeting based on current time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return context.tr('good_morning');
    } else if (hour >= 12 && hour < 17) {
      return context.tr('good_afternoon');
    } else if (hour >= 17 && hour < 21) {
      return context.tr('good_evening');
    } else {
      return context.tr('good_night');
    }
  }

  // Get greeting icon based on current time
  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 17) {
      return Icons.wb_sunny_outlined;
    } else if (hour >= 17 && hour < 21) {
      return Icons.wb_twilight_outlined;
    } else {
      return Icons.nightlight_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch currency provider to rebuild on change
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: () {
              // Logic to go back or switch to home tab if at root
              final navigator = Navigator.of(context);
              if (navigator.canPop()) {
                navigator.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
          centerTitle: true,
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header / Greeting
              Row(
                children: [
                   Icon(
                    _getGreetingIcon(),
                    color: AppColors.grey600,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSize16,
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.watch<AuthViewModel>().userName ?? 'Alena Sabyan',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FavoritesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.spacing8),
                      decoration: const BoxDecoration(
                        color: AppColors.greyLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColors.primaryAccent,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacing24),

              // Featured Section
              Text(
                context.tr('featured'),
                style: const TextStyle(
                  fontSize: AppDimensions.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              
              // Featured Carousel
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    FeaturedCard(
                      title: context.tr('featured_card_title_1'),
                      time: context.tr('featured_card_time_1'),
                      authorName: 'Olivia',
                      authorImage: 'assets/images/user_avatar.jpg', // Placeholder
                      foodImage: 'assets/images/noodle_bowl.png', // Placeholder
                      backgroundColor: AppColors.primaryAccent,
                    ),
                    const SizedBox(width: AppDimensions.spacing16),
                    FeaturedCard(
                      title: context.tr('featured_card_title_2'),
                      time: context.tr('featured_card_time_2'),
                      authorName: 'Olivia',
                      authorImage: 'assets/images/user_avatar.jpg',
                      foodImage: 'assets/images/salad_bowl.png',
                      backgroundColor: AppColors.success,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spacing24),

              // Category Section
              SectionHeader(
                title: context.tr('category'),
                onSeeAll: () async {
                  final selectedCategoryId = await Navigator.of(context).push<int?>(
                    MaterialPageRoute(
                      builder: (_) => CategoryScreen(
                        branchId: widget.branchId,
                        initialSelectedCategoryId: _selectedCategoryId,
                      ),
                    ),
                  );
                  
                  // Update selected category if user selected one
                  if (selectedCategoryId != null && mounted) {
                    setState(() {
                      _selectedCategoryId = selectedCategoryId;
                    });
                    // Fetch menu items for the selected category
                    context.read<MenuViewModel>().fetchMenuItemsByCategory(selectedCategoryId);
                  }
                },
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Consumer<MenuViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isCategoriesLoading) {
                    return const SizedBox(
                      height: 40,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (viewModel.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Show all categories
                  final categoriesToShow = viewModel.categories;

                  // Set first category as selected if none selected
                  if (_selectedCategoryId == null && categoriesToShow.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _selectedCategoryId = categoriesToShow[0].id;
                      });
                    });
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < categoriesToShow.length; i++) ...[
                          CategoryChip(
                            label: categoriesToShow[i].name,
                            isSelected: _selectedCategoryId == categoriesToShow[i].id,
                            onTap: () {
                              setState(() {
                                _selectedCategoryId = categoriesToShow[i].id;
                              });
                              // Fetch menu items for the selected category
                              viewModel.fetchMenuItemsByCategory(categoriesToShow[i].id);
                            },
                          ),
                          if (i < categoriesToShow.length - 1) const SizedBox(width: AppDimensions.spacing12),
                        ],
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: AppDimensions.spacing24),

              // Popular Recipes Section
              SectionHeader(title: context.tr('popular_recipes'), onSeeAll: () {}),
              const SizedBox(height: AppDimensions.spacing16),
              
              Consumer<MenuViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isMenuItemsLoading) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (viewModel.menuItemsError != null) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppColors.grey),
                            const SizedBox(height: AppDimensions.spacing8),
                            Text(
                              viewModel.menuItemsError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.grey600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (viewModel.menuItems.isEmpty) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(context.tr('no_menu_items')),
                      ),
                    );
                  }

                  // Show first 2 menu items
                  final itemsToShow = viewModel.menuItems.take(2).toList();

                  return Row(
                    children: [
                      for (int i = 0; i < itemsToShow.length; i++) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MenuItemDetailScreen(
                                    menuItemId: itemsToShow[i].id,
                                  ),
                                ),
                              );
                            },
                            child: RecipeCard(
                              title: itemsToShow[i].name,
                              price: '${context.tr('from')} ${currencyProvider.formatPrice(double.tryParse(itemsToShow[i].price.toString()) ?? 0)}',
                              image: itemsToShow[i].image ?? 'assets/images/kebabpizza.jpg',
                                menuItemId: itemsToShow[i].id,
                              isFavorite: viewModel.isFavorite(itemsToShow[i].id),
                              onFavoriteTap: () async {
                                // Verify status first as requested
                                await viewModel.checkFavoriteStatus(itemsToShow[i].id);
                                
                                if (!context.mounted) return;
                                
                                final message = await viewModel.toggleFavorite(itemsToShow[i].id);
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
                          ),
                        ),
                        if (i < itemsToShow.length - 1) const SizedBox(width: AppDimensions.spacing16),
                      ],
                    ],
                  );
                },
              ),
              // Sub bottom padding for better scroll feel above bottom nav
               const SizedBox(height: AppDimensions.spacing20),
            ],
          ),
        ),
      ),
    );
  }
}




