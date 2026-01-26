import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/widgets/custom_text_field.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/features/menu/presentation/pages/menu_item_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Fetch categories on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchCategories(3); // Assuming branch ID 3
    });
    
    // Add search listener with debouncing
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.length > 2) {
      context.read<MenuViewModel>().searchMenuItems(query);
    } else if (query.isEmpty) {
      context.read<MenuViewModel>().clearSearch();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          context.tr('search_title'),
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.fontSize18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              CustomTextField(
                controller: _searchController,
                hintText: context.tr('search_hint'),
              ),
              
              const SizedBox(height: AppDimensions.spacing24),
              
              // Category Filter Chips
              Consumer<MenuViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.spacing12),
                      itemBuilder: (context, index) {
                        final category = viewModel.categories[index];
                        final isSelected = _selectedCategoryId == category.id;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedCategoryId == category.id) {
                                _selectedCategoryId = null;
                                viewModel.clearSearch();
                              } else {
                                _selectedCategoryId = category.id;
                                viewModel.filterByCategory(category.id);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryAccent : AppColors.greyLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected ? AppColors.white : AppColors.grey600,
                                fontWeight: FontWeight.w500,
                                fontSize: AppDimensions.fontSize14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.spacing32),
              
              // Search Results or Default Content
              Consumer<MenuViewModel>(
                builder: (context, viewModel, child) {
                  // Loading state
                  if (viewModel.isSearching) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                        ),
                      ),
                    );
                  }

                  // Error state
                  if (viewModel.searchError != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppColors.grey),
                            const SizedBox(height: AppDimensions.spacing16),
                            Text(
                              viewModel.searchError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.grey600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Results
                  if (viewModel.searchResults.isNotEmpty) {
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.searchResults.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spacing16),
                      itemBuilder: (context, index) {
                        final item = viewModel.searchResults[index];
                        
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
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.spacing12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryText.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                                    color: AppColors.grey200,
                                    image: item.image != null
                                        ? DecorationImage(
                                            image: NetworkImage(item.image!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: item.image == null
                                      ? const Icon(Icons.local_pizza, color: AppColors.grey, size: 40)
                                      : null,
                                ),
                                const SizedBox(width: AppDimensions.spacing16),
                                
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: AppDimensions.fontSize16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimensions.spacing8),
                                      Row(
                                        children: [
                                          const Icon(Icons.local_fire_department_outlined, size: 16, color: AppColors.primaryAccent),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.price} kr',
                                            style: const TextStyle(
                                              color: AppColors.primaryAccent,
                                              fontSize: AppDimensions.fontSize14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Arrow Button
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: AppColors.darkText,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  // Empty state
                  if (_searchController.text.isNotEmpty || _selectedCategoryId != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off, size: 64, color: AppColors.grey300),
                            const SizedBox(height: AppDimensions.spacing16),
                            Text(
                              context.tr('no_results_found'),
                              style: const TextStyle(
                                fontSize: AppDimensions.fontSize18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Default placeholder
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        context.tr('search_placeholder'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    ),
                  );
                },
              ),
               
               // Bottom padding for nav bar
               const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
    );
  }
}
