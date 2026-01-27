import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/menu/domain/entities/addon_entity.dart';
import 'package:foodora/core/constants/app_colors.dart';
import 'package:foodora/core/constants/app_dimensions.dart';
import 'package:foodora/features/menu/presentation/widgets/addon_row.dart';
import 'package:foodora/features/menu/presentation/widgets/ingredient_row.dart';
import 'package:foodora/features/menu/presentation/widgets/nutrition_item.dart';
import 'package:foodora/core/extensions/context_extensions.dart';


class MenuItemDetailScreen extends StatefulWidget {
  final int menuItemId;

  const MenuItemDetailScreen({super.key, required this.menuItemId});

  @override
  State<MenuItemDetailScreen> createState() => _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends State<MenuItemDetailScreen> {
  final Map<int, int> _addonCounts = {};
  int _quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MenuViewModel>();
      viewModel.fetchMenuItemDetails(widget.menuItemId);
      viewModel.checkFavoriteStatus(widget.menuItemId);
    });
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _incrementAddon(int addonId) {
    setState(() {
      _addonCounts[addonId] = (_addonCounts[addonId] ?? 0) + 1;
    });
  }

  void _decrementAddon(int addonId) {
    setState(() {
      if ((_addonCounts[addonId] ?? 0) > 0) {
        _addonCounts[addonId] = (_addonCounts[addonId] ?? 0) - 1;
      }
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  double _calculateTotal(double basePrice, List<dynamic>? addons) {
    double addonsTotal = 0.0;
    if (addons != null) {
      for (var addon in addons) {
        final count = _addonCounts[addon.id] ?? 0;
        if (count > 0) {
          final addonPrice = double.tryParse(addon.price.toString()) ?? 0.0;
          addonsTotal += (addonPrice * count);
        }
      }
    }
    return (basePrice + addonsTotal) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isMenuItemDetailsLoading) {
           return const Scaffold(
             backgroundColor: AppColors.white,
             body: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
           );
        }

        final item = viewModel.selectedMenuItem;

        if (item == null) {
           return Scaffold(
             backgroundColor: AppColors.white,
             body: Center(child: Text(viewModel.menuItemDetailsError ?? 'Item not found', style: const TextStyle(color: AppColors.primaryText))),
           );
        }

        final basePrice = double.tryParse(item.price) ?? 0.0;
        // ignore: unused_local_variable
        final totalPrice = _calculateTotal(basePrice, item.addons); 

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            children: [
              // Background Image (Top)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: AppDimensions.responsive(context, mobile: 350, tablet: 400, desktop: 450),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        item.image ?? 'https://thumbs.dreamstime.com/b/pizza-pepperoni-cheese-salami-vegetables-58914487.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              // Action Buttons (Close & Favorite)
              Positioned(
                top: AppDimensions.responsiveSpacing(context, mobile: 50, tablet: 60),
                left: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28),
                right: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleAction(
                      context: context,
                      icon: Icons.close,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildCircleAction(
                      context: context,
                      icon: viewModel.isFavorite(item.id) ? Icons.favorite : Icons.favorite_border,
                      iconColor: viewModel.isFavorite(item.id) ? Colors.red : AppColors.primaryText,
                      onTap: () async {
                         await viewModel.toggleFavorite(item.id);
                      },
                    ),
                  ],
                ),
              ),

              // Draggable/Scrollable Content
              Positioned.fill(
                top: AppDimensions.responsive(context, mobile: 280, tablet: 320, desktop: 360),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      // Handle Bar & Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            AppDimensions.getResponsiveHorizontalPadding(context),
                            AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32),
                            AppDimensions.getResponsiveHorizontalPadding(context),
                            100, // Extra padding for bottom bar
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Handle Bar
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // Keep mild grey for handle
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),

                              // Title & Time
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: AppDimensions.getH2Size(context),
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: AppDimensions.responsiveIconSize(context, mobile: 16, tablet: 20),
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '30 ${context.tr('min')}', 
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: AppDimensions.getSmallSize(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                              // Description
                              Text(
                                item.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  height: 1.5,
                                  fontSize: AppDimensions.getBodySize(context),
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                              // Nutrition Info Grid
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  // ignore: unused_local_variable
                                  double itemWidth = (constraints.maxWidth - 16) / 2;
                                  return Wrap(
                                    spacing: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                                    runSpacing: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                                    children: [
                                      NutritionItem(icon: Icons.grass, value: '65g', label: context.tr('carbs')), 
                                      NutritionItem(icon: Icons.local_fire_department, value: '120', label: context.tr('kcal')), 
                                      NutritionItem(icon: Icons.egg_alt_outlined, value: '27g', label: context.tr('proteins')), 
                                      NutritionItem(icon: Icons.pie_chart_outline, value: '91g', label: context.tr('fats')), 
                                    ],
                                  );
                                }
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                              // Ingredients Header
                              Text(
                                context.tr('ingredients'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getH3Size(context),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                              // Ingredients List (Static/Free items)
                              if (item.ingredients != null && item.ingredients!.isNotEmpty) ...[
                                ...item.ingredients!.map((ing) => IngredientRow(name: ing)),
                              ] else ...[
                                // Placeholder
                                const IngredientRow(name: "Tortilla Chips"),
                                const IngredientRow(name: "Avocado"),
                                const IngredientRow(name: "Red Cabbage"),
                                const IngredientRow(name: "Peanuts"),
                                const IngredientRow(name: "Red Onions"),
                              ],
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                              // Add-ons Header
                              Text(
                                context.tr('addons'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getH3Size(context),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),

                              // Add-ons List
                              if (item.addons != null && item.addons!.isNotEmpty) ...[
                                ...item.addons!.map((addon) {
                                  return AddonRow(
                                    name: addon.name,
                                    price: addon.formattedPrice, 
                                    count: _addonCounts[addon.id] ?? 0,
                                    onAdd: () => _incrementAddon(addon.id),
                                    onRemove: () => _decrementAddon(addon.id),
                                  );
                                }),
                              ] else ...[
                                Text(
                                  context.tr('no_addons_available'),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: AppDimensions.getBodySize(context),
                                  ),
                                ),
                              ],
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                              // Special Instructions
                              Text(
                                context.tr('special_instructions'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getH3Size(context),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                              Text(
                                context.tr('special_instructions_hint'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getSmallSize(context),
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _instructionsController,
                                  maxLines: 4,
                                  minLines: 3,
                                  style: TextStyle(
                                    fontSize: AppDimensions.getBodySize(context),
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: context.tr('instructions_example'),
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: AppDimensions.getSmallSize(context),
                                    ),
                                    labelText: context.tr('instructions_label'),
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: AppDimensions.getBodySize(context),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always, 
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bottom Bar
                      Container(
                        padding: EdgeInsets.all(
                          AppDimensions.getResponsiveHorizontalPadding(context),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Quantity Counter
                            Container(
                              height: AppDimensions.responsive(context, mobile: 50, tablet: 56),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _buildSmallCounterBtn(context, Icons.remove, _decrementQuantity),
                                  SizedBox(
                                    width: AppDimensions.responsive(context, mobile: 40, tablet: 50), 
                                    child: Center(
                                      child: Text(
                                        '$_quantity',
                                        style: TextStyle(
                                          fontSize: AppDimensions.getH3Size(context),
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                    )
                                  ),
                                  _buildSmallCounterBtn(context, Icons.add, _incrementQuantity, isPlus: true),
                                ],
                              ),
                            ),
                            SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),
                            // Add to Cart Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final List<AddonEntity> selectedAddons = [];
                                  if (item.addons != null) {
                                    for (var addon in item.addons!) {
                                      final count = _addonCounts[addon.id] ?? 0;
                                      for (int i = 0; i < count; i++) {
                                         selectedAddons.add(addon); 
                                      }
                                    }
                                  }
                                  
                                  context.read<CartViewModel>().addToCart(item, _quantity, selectedAddons);
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${item.name} ${context.tr('added_to_cart')}'),
                                      backgroundColor: AppColors.primaryAccent,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAccent,
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  context.tr('add_to_cart'),
                                  style: TextStyle(
                                    fontSize: AppDimensions.getBodySize(context),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircleAction({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.primaryText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.responsive(context, mobile: 40, tablet: 48),
        height: AppDimensions.responsive(context, mobile: 40, tablet: 48),
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildSmallCounterBtn(BuildContext context, IconData icon, VoidCallback onTap, {bool isPlus = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.responsive(context, mobile: 40, tablet: 48),
        height: AppDimensions.responsive(context, mobile: 40, tablet: 48),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon, 
          size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24), 
          color: isPlus ? AppColors.primaryAccent : Colors.grey[700]
        ),
      ),
    );
  }
}

// Imports added at the top
// Inline classes removed at the bottom
