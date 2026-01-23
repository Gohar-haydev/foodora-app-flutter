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
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Logic to go back or switch to home tab if at root
              final navigator = Navigator.of(context);
              if (navigator.canPop()) {
                navigator.pop();
              } else {
                // Assuming MainLayout state logic, but we can't access it easily without a provider or global key.
                // For now, standard behavior. If this is a root tab, back button visually exists per requirement.
                // We could try specific logic if needed, but let's stick to standard pop first.
                // If it does nothing, user might rely on bottom nav.
                // Alternatively, find MainLayoutState? No, too complex.
                // Just Pop.
                Navigator.of(context).maybePop();
              }
            },
          ),
          // title: const Text(
          //   'Profile',
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 20,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          centerTitle: true,
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header / Greeting
              Row(
                children: [
                   Icon(
                    _getGreetingIcon(),
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.watch<AuthViewModel>().userName ?? 'Alena Sabyan',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Featured Section
              Text(
                context.tr('featured'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              
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
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 16),
                    FeaturedCard(
                      title: context.tr('featured_card_title_2'),
                      time: context.tr('featured_card_time_2'),
                      authorName: 'Olivia',
                      authorImage: 'assets/images/user_avatar.jpg',
                      foodImage: 'assets/images/salad_bowl.png',
                      backgroundColor: const Color(0xFF66BB6A),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
              const SizedBox(height: 12),
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
                          if (i < categoriesToShow.length - 1) const SizedBox(width: 12),
                        ],
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Popular Recipes Section
              SectionHeader(title: context.tr('popular_recipes'), onSeeAll: () {}),
              const SizedBox(height: 16),
              
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
                            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              viewModel.menuItemsError!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
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
                              price: '${context.tr('from')} ${itemsToShow[i].price} kr',
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
                                          ? Colors.red 
                                          : const Color(0xFF4CAF50),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        if (i < itemsToShow.length - 1) const SizedBox(width: 16),
                      ],
                    ],
                  );
                },
              ),
              // Sub bottom padding for better scroll feel above bottom nav
               const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}








