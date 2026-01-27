import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
// import 'package:foodora/core/network/api_service.dart'; // Unused
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/widgets/widgets.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class CategoryScreen extends StatefulWidget {
  final int branchId;
  final int? initialSelectedCategoryId;
  
  const CategoryScreen({
    super.key,
    required this.branchId,
    this.initialSelectedCategoryId,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Initialize with the passed selected category ID
    _selectedCategoryId = widget.initialSelectedCategoryId;
    
    // Fetch categories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchCategories(widget.branchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.tr('category'),
          style: TextStyle(
            color: Colors.black,
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
              if (viewModel.isCategoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.categoriesError != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppDimensions.responsiveIconSize(context, mobile: 48, tablet: 60),
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      Text(
                        viewModel.categoriesError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: AppDimensions.getBodySize(context),
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchCategories(widget.branchId),
                        child: Text(context.tr('retry')),
                      ),
                    ],
                  ),
                );
              }

              if (viewModel.categories.isEmpty) {
                return Center(
                  child: Text(
                    context.tr('no_categories_available'),
                    style: TextStyle(
                      fontSize: AppDimensions.getBodySize(context),
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(
                  AppDimensions.getResponsiveHorizontalPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('category'),
                          style: TextStyle(
                            fontSize: AppDimensions.getH3Size(context),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = null;
                            });
                          },
                          child: Text(
                            context.tr('clear'),
                            style: TextStyle(
                              fontSize: AppDimensions.getBodySize(context),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4FAF5A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),

                    // Categories Wrap with Button at bottom
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
                                runSpacing: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16),
                                children: viewModel.categories.map((category) {
                                  return CategoryChip(
                                    label: category.name,
                                    isSelected: _selectedCategoryId == category.id,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategoryId = category.id;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),

                            SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 40, tablet: 50)),

                            // Apply Filters Button
                            ApplyFilterButton(
                              label: context.tr('apply_filters'),
                              onPressed: () {
                                // Apply logic - pass selected category back
                                Navigator.of(context).pop(_selectedCategoryId);
                              },
                            ),
                            SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
