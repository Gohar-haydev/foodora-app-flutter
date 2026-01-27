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
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                AppDimensions.getResponsiveHorizontalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  CustomTextField(
                    controller: _searchController,
                    hintText: context.tr('search_hint'),
                  ),
                  
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                  
                  // Category Filter Chips
                  Consumer<MenuViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.categories.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return SizedBox(
                        height: AppDimensions.responsive(context, mobile: 40, tablet: 48),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.categories.length,
                          separatorBuilder: (context, index) => SizedBox(
                            width: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
                          ),
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 24),
                                  vertical: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10),
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryAccent : AppColors.greyLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.white : AppColors.grey600,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppDimensions.getSmallSize(context),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),
                  
                  // Search Results or Default Content
                  Consumer<MenuViewModel>(
                    builder: (context, viewModel, child) {
                      // Loading state
                      if (viewModel.isSearching) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 50),
                            ),
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                            ),
                          ),
                        );
                      }

                      // Error state
                      if (viewModel.searchError != null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                              AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 50),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: AppDimensions.responsiveIconSize(context, mobile: 48, tablet: 60),
                                  color: AppColors.grey,
                                ),
                                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                                Text(
                                  viewModel.searchError!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.grey600,
                                    fontSize: AppDimensions.getBodySize(context),
                                  ),
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
                          separatorBuilder: (context, index) => SizedBox(
                            height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                          ),
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
                                padding: EdgeInsets.all(
                                  AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryText.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Image
                                    Container(
                                      width: AppDimensions.responsive(context, mobile: 80, tablet: 100),
                                      height: AppDimensions.responsive(context, mobile: 80, tablet: 100),
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
                                          ? Icon(
                                              Icons.local_pizza,
                                              color: AppColors.grey,
                                              size: AppDimensions.responsiveIconSize(context, mobile: 40, tablet: 50),
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                                    
                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: AppDimensions.getBodySize(context),
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                          SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_fire_department_outlined,
                                                size: AppDimensions.responsiveIconSize(context, mobile: 16, tablet: 20),
                                                color: AppColors.primaryAccent,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${item.price} kr',
                                                style: TextStyle(
                                                  color: AppColors.primaryAccent,
                                                  fontSize: AppDimensions.getSmallSize(context),
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
                                      width: AppDimensions.responsive(context, mobile: 32, tablet: 40),
                                      height: AppDimensions.responsive(context, mobile: 32, tablet: 40),
                                      decoration: const BoxDecoration(
                                        color: AppColors.darkText,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.white,
                                        size: AppDimensions.responsiveIconSize(context, mobile: 16, tablet: 20),
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
                            padding: EdgeInsets.all(
                              AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 50),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: AppDimensions.responsiveIconSize(context, mobile: 64, tablet: 80),
                                  color: AppColors.grey300,
                                ),
                                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                                Text(
                                  context.tr('no_results_found'),
                                  style: TextStyle(
                                    fontSize: AppDimensions.getH3Size(context),
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
                          padding: EdgeInsets.all(
                            AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 50),
                          ),
                          child: Text(
                            context.tr('search_placeholder'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: AppDimensions.getBodySize(context),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                   
                   // Bottom padding for nav bar
                   SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 80, tablet: 100)), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
