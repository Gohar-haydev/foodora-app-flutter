import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/features/menu/presentation/viewmodels/menu_viewmodel.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/menu/domain/entities/addon_entity.dart';
import 'package:foodora/core/constants/app_strings.dart';
import 'package:foodora/core/constants/app_colors.dart';

class MenuItemDetailScreen extends StatefulWidget {
  final int menuItemId;

  const MenuItemDetailScreen({Key? key, required this.menuItemId}) : super(key: key);

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
      context.read<MenuViewModel>().fetchMenuItemDetails(widget.menuItemId);
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
                height: 350,
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
                top: 50,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleAction(
                      icon: Icons.close,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildCircleAction(
                      icon: viewModel.isFavorite(item.id) ? Icons.favorite : Icons.favorite_border,
                      onTap: () async {
                         await viewModel.toggleFavorite(item.id);
                      },
                    ),
                  ],
                ),
              ),

              // Draggable/Scrollable Content
              Positioned.fill(
                top: 280,
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
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // Extra padding for bottom bar
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
                              const SizedBox(height: 20),

                              // Title & Time
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '30 ${AppStrings.min}', 
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Description
                              Text(
                                item.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Nutrition Info Grid
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  // ignore: unused_local_variable
                                  double itemWidth = (constraints.maxWidth - 16) / 2;
                                  return Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: const [
                                      NutritionItem(icon: Icons.grass, value: '65g', label: AppStrings.carbs), 
                                      NutritionItem(icon: Icons.local_fire_department, value: '120', label: AppStrings.kcal), 
                                      NutritionItem(icon: Icons.egg_alt_outlined, value: '27g', label: AppStrings.proteins), 
                                      NutritionItem(icon: Icons.pie_chart_outline, value: '91g', label: AppStrings.fats), 
                                    ],
                                  );
                                }
                              ),
                              const SizedBox(height: 32),

                              // Ingredients Header
                              const Text(
                                AppStrings.ingredients,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Ingredients List (Static/Free items)
                              if (item.ingredients != null && item.ingredients!.isNotEmpty) ...[
                                ...item.ingredients!.map((ing) => IngredientRow(name: ing)).toList(),
                              ] else ...[
                                // Placeholder
                                const IngredientRow(name: "Tortilla Chips"),
                                const IngredientRow(name: "Avocado"),
                                const IngredientRow(name: "Red Cabbage"),
                                const IngredientRow(name: "Peanuts"),
                                const IngredientRow(name: "Red Onions"),
                              ],
                              const SizedBox(height: 32),

                              // Add-ons Header
                              const Text(
                                AppStrings.addons,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 16),

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
                                }).toList(),
                              ] else ...[
                                Text(AppStrings.noAddonsAvailable, style: TextStyle(color: Colors.grey[500])),
                              ],
                              const SizedBox(height: 32),

                              // Special Instructions
                              const Text(
                                AppStrings.specialInstructions,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                AppStrings.specialInstructionsHint,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _instructionsController,
                                  maxLines: 4,
                                  minLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppStrings.instructionsExample,
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    labelText: AppStrings.instructionsLabel,
                                    labelStyle: TextStyle(color: Colors.grey[600]),
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
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Quantity Counter
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _buildSmallCounterBtn(Icons.remove, _decrementQuantity),
                                  SizedBox(
                                    width: 40, 
                                    child: Center(
                                      child: Text(
                                        '$_quantity',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                    )
                                  ),
                                  _buildSmallCounterBtn(Icons.add, _incrementQuantity, isPlus: true),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
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
                                      content: Text(AppStrings.formatItemAddedToCart(item.name)),
                                      backgroundColor: AppColors.primaryAccent,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  AppStrings.addToCartButton, 
                                  style: TextStyle(
                                    fontSize: 16,
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

  Widget _buildCircleAction({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryText),
      ),
    );
  }

  Widget _buildSmallCounterBtn(IconData icon, VoidCallback onTap, {bool isPlus = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon, 
          size: 20, 
          color: isPlus ? AppColors.primaryAccent : Colors.grey[700]
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class NutritionItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const NutritionItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 48 - 16) / 2; 

    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.5), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white, 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IngredientRow extends StatelessWidget {
  final String name;

  const IngredientRow({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image, color: AppColors.mutedText, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
            ),
            child: Row(
              children: [
                const Icon(Icons.radio_button_unchecked, color: AppColors.primaryAccent, size: 16),
                 const SizedBox(width: 4),
                Text(
                  AppStrings.free,
                  style: const TextStyle(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddonRow extends StatelessWidget {
  final String name;
  final String price;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const AddonRow({
    Key? key,
    required this.name,
    required this.price,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fastfood, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                     color: AppColors.primaryText,
                  ),
                ),
                Text(
                  price, 
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildCounterIcon(Icons.remove, onRemove),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              _buildCounterIcon(Icons.add, onAdd, isPlus: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterIcon(IconData icon, VoidCallback onTap, {bool isPlus = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isPlus 
            ? Border.all(color: AppColors.primaryAccent) 
            : Border.all(color: Colors.grey.withOpacity(0.4)),
          color: AppColors.white,
        ),
        child: Icon(
          icon, 
          size: 16, 
          color: isPlus ? AppColors.primaryAccent : Colors.grey[600]
        ),
      ),
    );
  }
}
