import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/features/menu/presentation/pages/category_screen.dart';
import 'package:foodora/features/menu/presentation/pages/favorites_screen.dart';
import 'package:foodora/features/menu/presentation/pages/menu_item_detail_screen.dart';

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
      return AppStrings.goodMorning;
    } else if (hour >= 12 && hour < 17) {
      return AppStrings.goodAfternoon;
    } else if (hour >= 17 && hour < 21) {
      return AppStrings.goodEvening;
    } else {
      return AppStrings.goodNight;
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
                        Icons.favorite,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Featured Section
              const Text(
                AppStrings.featured,
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
                    _FeaturedCard(
                      title: 'Asian white noodle\nwith extra seafood',
                      time: '20 Min',
                      authorName: 'Olivia',
                      authorImage: 'assets/images/user_avatar.jpg', // Placeholder
                      foodImage: 'assets/images/noodle_bowl.png', // Placeholder
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 16),
                    _FeaturedCard(
                      title: 'Healthy recipe\nwith fresh vegetables',
                      time: '15 Min',
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
              _SectionHeader(
                title: AppStrings.category,
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryId = categoriesToShow[i].id;
                              });
                              // Fetch menu items for the selected category
                              viewModel.fetchMenuItemsByCategory(categoriesToShow[i].id);
                            },
                            child: _CategoryChip(
                              label: categoriesToShow[i].name,
                              isSelected: _selectedCategoryId == categoriesToShow[i].id,
                            ),
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
              _SectionHeader(title: AppStrings.popularRecipes, onSeeAll: () {}),
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
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('No menu items available'),
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
                            child: _RecipeCard(
                              title: itemsToShow[i].name,
                              price: 'from ${itemsToShow[i].price} kr',
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4CAF50),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String title;
  final String time;
  final String authorName;
  final String authorImage;
  final String foodImage;
  final Color backgroundColor;

  const _FeaturedCard({
    required this.title,
    required this.time,
    required this.authorName,
    required this.authorImage,
    required this.foodImage,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
           // Circle decorations for background texture
           Positioned(
             top: -10,
             left: 20,
             child: Container(
               width: 10,
               height: 10,
               decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
             )
           ),
           
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 160,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage('assets/images/user_avatar.jpg'), // Fallback needed
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    authorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Food Image on the right
           Positioned(
            right: -30,
            top: 10,
            bottom: 10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: Colors.white.withOpacity(0.2),
              ),
               child: const Icon(Icons.rice_bowl, color: Colors.white70, size: 60), // Placeholder for image
            ),
          )
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF757575),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final int menuItemId;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _RecipeCard({
    required this.title,
    required this.price,
    required this.image,
    required this.menuItemId,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 10,
             offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.grey[100],
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Center(
                        child: Icon(Icons.local_pizza, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_outlined, 
                      size: 14, 
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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
}
