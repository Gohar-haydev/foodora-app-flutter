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
  // Local state for addon counts (using addons instead of ingredients based on user new requirement mixed with old design)
  // The API returns 'addons' as objects with prices, and simple string 'ingredients'.
  // The design showed ingredients with counters. The USER REQUEST implies real data has addons.
  // We will map Addons to the counter UI.
  final Map<int, int> _addonCounts = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchMenuItemDetails(widget.menuItemId);
    });
  }

  void _increment(int addonId) {
    setState(() {
      _addonCounts[addonId] = (_addonCounts[addonId] ?? 0) + 1;
    });
  }

  void _decrement(int addonId) {
    setState(() {
      if ((_addonCounts[addonId] ?? 0) > 0) {
        _addonCounts[addonId] = (_addonCounts[addonId] ?? 0) - 1;
      }
    });
  }

  double _calculateTotal(double basePrice, List<dynamic>? addons) {
    double total = basePrice;
    if (addons != null) {
      for (var addon in addons) {
        final count = _addonCounts[addon.id] ?? 0;
        if (count > 0) {
          // Parse addon price safely
          final addonPrice = double.tryParse(addon.price.toString()) ?? 0.0;
          total += (addonPrice * count);
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuViewModel>(
      builder: (context, viewModel, child) {
        // Loading State
        if (viewModel.isMenuItemDetailsLoading) {
           return const Scaffold(
             backgroundColor: Colors.white,
             body: Center(child: CircularProgressIndicator()),
           );
        }

        final item = viewModel.selectedMenuItem;

        if (item == null) {
           // Error or Empty State
           return Scaffold(
             backgroundColor: Colors.white,
             body: Center(child: Text(viewModel.menuItemDetailsError ?? 'Item not found')),
           );
        }

        return Scaffold(
          backgroundColor: Colors.white,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle Bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
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
                                  '30 Min', 
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

                        // Nutrition Info (Static for now, API doesn't have it explicitly yet)
                        Wrap(
                          spacing: 16,
                          runSpacing: 0, 
                          children: const [
                            NutritionItem(icon: Icons.grass, value: '65g', label: AppStrings.carbs),
                            NutritionItem(icon: Icons.local_fire_department, value: '120', label: AppStrings.appetizers),
                            NutritionItem(icon: Icons.egg_alt_outlined, value: '27g', label: AppStrings.proteins),
                            NutritionItem(icon: Icons.pie_chart_outline, value: '91g', label: AppStrings.fats),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Ingredients/Addons Header
                        if (item.addons != null && item.addons!.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Add-ons", // Distinct from static ingredients
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.addons!.length} ${AppStrings.item}',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Addons List
                          ...item.addons!.map((addon) {
                            return IngredientItem(
                              name: addon.name,
                              count: _addonCounts[addon.id] ?? 0,
                              onAdd: () => _increment(addon.id),
                              onRemove: () => _decrement(addon.id),
                              price: addon.formattedPrice,
                            );
                          }).toList(),
                           const SizedBox(height: 32),
                        ],
                        
                        // Ingredient Strings (Read-only list if available)
                        if (item.ingredients != null && item.ingredients!.isNotEmpty) ...[
                           const Text(
                              "Ingredients",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: item.ingredients!.map((ing) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primaryAccent.withOpacity(0.1)),
                                ),
                                child: Text(
                                  ing,
                                  style: const TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )).toList(),
                            ),
                            const SizedBox(height: 32),
                        ],


                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              final List<AddonEntity> selectedAddons = [];
                              if (item.addons != null) {
                                for (var addon in item.addons!) {
                                  final count = _addonCounts[addon.id] ?? 0;
                                  // For now, if user selects 2x Cheese, we add Cheese object 2 times to the list.
                                  // This aligns with how we calculated the total price (summing up).
                                  // Ideally CartItemEntity might want a better structure, but this works for simple "list of addons".
                                  for (int i = 0; i < count; i++) {
                                     // We need to map AddonModel to AddonEntity if not already handling it via polymorphism.
                                     // item.addons are AddonModels but typed as such. AddonModel extends AddonEntity.
                                     selectedAddons.add(addon); 
                                  }
                                }
                              }

                              context.read<CartViewModel>().addToCart(item, 1, selectedAddons);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${item.name} to cart'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              
                              // Optional: Navigate to Cart or just stay.
                              // User might want to verify. Let's just stay for now as standard UX.
                              // Or if user insists on "send it to cart screen", maybe they mean data, not navigation.
                              // "send it to ... cart_screen.dart" implies data transfer.
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  AppStrings.addToCartButton,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Builder(
                                  builder: (context) {
                                    final basePrice = double.tryParse(item.price) ?? 0.0;
                                    final total = _calculateTotal(basePrice, item.addons);
                                    return Text(
                                      '\$${total.toStringAsFixed(2)}', 
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Related Recipes Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const Text(
                              AppStrings.relatedRecipes,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                AppStrings.seeAll,
                                style: TextStyle(color: AppColors.primaryAccent),
                              ),
                            ),
                          ],
                        ),
                        
                        // Related Recipes List (Horizontal)
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                             children: const [
                              RelatedRecipeCard(name: 'Egg & Avocado', image: 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'),
                              RelatedRecipeCard(name: 'Bowl of Rice', image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'),
                              RelatedRecipeCard(name: 'Chicken Salad', image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}

// Sub-widgets specifically for this screen

class NutritionChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const NutritionChip({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed width/height or minimal constraints can be tricky in Row without flexible, 
      // but in the design they look like fixed pills.
      // Let's use flexible if needed, but here simple Column in Container works.
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight, // Light grey/greenish?
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
            Icon(icon, size: 20, color: Colors.grey[700]), // Icon color?
            // Wait, design shows 2x2 grid basically or wrapped? 
            // The image shows:
            // [Icon] [Value] [Label]
            // Actually: [Icon box] [Value + Label]?
            // Image: 
            // [ Leaf Icon (Box) ]  65g carbs
            // [ Fire Icon (Box) ] 120 Kcal
            // The Layout is Grid-like: 2 columns.
        ],
      ),
    );
  }
}

// Re-implementing Nutrition Section to match image better:
// The image shows 4 distinct items arranged in a 2x2 grid or just 2 rows of 2 columns.
// Item structure: [Icon in a square]  [Value (Data)] [Label (Data)]
// Actually looks like: Icon in square on left. Text on right.
// Let's adjust usage in main build method.

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
    return Container(
      width: MediaQuery.of(context).size.width * 0.4, // Approx half width
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blueGrey), // Styled icon
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


class IngredientItem extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final String? price;

  const IngredientItem({
    Key? key,
    required this.name,
    required this.count,
    required this.onAdd,
    required this.onRemove,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Ingredient Image Placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              // image: DecorationImage(...) // Add real images later
            ),
            child: const Icon(Icons.fastfood, color: Colors.orange, size: 24), // Placeholder
          ),
          const SizedBox(width: 16),
          // Name
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
                if (price != null)
                  Text(
                    price!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          // Counter
          Row(
            children: [
              _buildCounterBtn(Icons.remove, onRemove),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _buildCounterBtn(Icons.add, onAdd),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCounterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.green),
      ),
    );
  }
}

class RelatedRecipeCard extends StatelessWidget {
  final String name;
  final String image;

  const RelatedRecipeCard({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
