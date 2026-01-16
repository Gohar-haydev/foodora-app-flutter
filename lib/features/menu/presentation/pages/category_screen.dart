import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/core/network/api_service.dart';
import 'package:foodora/core/constants/app_constants.dart';

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MenuViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.categoriesError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.categoriesError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchCategories(widget.branchId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.categories.isEmpty) {
            return const Center(
              child: Text('No categories available'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = null;
                        });
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4FAF5A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Categories Wrap with Button at bottom
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: viewModel.categories.map((category) {
                              final isSelected = _selectedCategoryId == category.id;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryId = category.id;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF4FAF5A) : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Apply Filters Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply logic - pass selected category back
                              Navigator.of(context).pop(_selectedCategoryId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backgroundLight,
                              foregroundColor: AppColors.primaryText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'APPLY FILTERS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
