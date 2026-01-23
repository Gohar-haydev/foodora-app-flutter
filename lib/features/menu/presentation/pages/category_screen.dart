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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.tr('category'),
          style: const TextStyle(
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
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          if (viewModel.categories.isEmpty) {
            return Center(
              child: Text(context.tr('no_categories_available')),
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
                    Text(
                      context.tr('category'),
                      style: const TextStyle(
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
                      child: Text(
                        context.tr('clear'),
                        style: const TextStyle(
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

                        const SizedBox(height: 40),

                        // Apply Filters Button
                        ApplyFilterButton(
                          label: context.tr('apply_filters'),
                          onPressed: () {
                            // Apply logic - pass selected category back
                            Navigator.of(context).pop(_selectedCategoryId);
                          },
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
