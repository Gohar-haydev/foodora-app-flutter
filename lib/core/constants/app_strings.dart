/// Application-wide string constants
/// All hardcoded text should be moved here for easy maintenance and localization
class AppStrings {
  // App Info
  static const String appName = 'Foodie';
  static const String appTagline = 'Order from your favorite restaurants';

  // Auth Screens
  static const String signIn = 'SIGN IN';
  static const String welcomeBack = 'Welcome back';
  static const String createAccount = 'Create Account';
  static const String signUpSubtitle = 'Enter your Name, Email and Password for sign up.';
  static const String email = 'Email';
  static const String emailAddress = 'EMAIL ADDRESS';
  static const String emailAddressPlaceholder = 'EMAIL ADDRESS';
  static const String password = 'Password';
  static const String passwordPlaceholder = '******';
  static const String fullName = 'Full Name';
  static const String fullNamePlaceholder = 'FULL NAME';
  static const String phone = 'PHONE NUMBER';
  static const String forgotPassword = 'Forgot password?';
  static const String forgetPassword = 'Forget Password?';
  static const String logIn = 'Log In';
  static const String signUp = 'SIGN UP';
  static const String continueAsGuest = 'Continue as Guest';
  static const String createNewAccount = 'Create new account.';
  static const String dontHaveAccount = 'Don\'t have account?';
  static const String alreadyHaveAccount = 'Already have account?';
  static const String termsAndConditions = 'By Signing up you agree to our Terms Conditions & Privacy Policy.';
  static const String missingInformation = 'Missing Information';
  static const String signingIn = 'Signing in...';

  // Greetings
  static const String goodMorning = 'Good Morning';
  static const String goodAfternoon = 'Good Afternoon';
  static const String goodEvening = 'Good Evening';
  static const String goodNight = 'Good Night';

  // Branch Selection
  static const String selectBranchTitle = 'Select Branch';
  static const String branchA = 'Branch A';
  static const String branchB = 'Branch B';
  static const String branchAAddress = '123 Main Street, Anytown';
  static const String branchBAddress = '456 Oak Avenue, Anytown';
  static const String selectButton = 'Select';
  static const String cart = 'Cart';
  static const String home = 'Home';
  static const String search = 'Search';
  static const String notification = 'Notification';
  static const String profile = 'Profile';

  // Validation Messages
  static const String pleaseFillAllFields = 'Please fill in all fields';
  static const String loginFailed = 'Login Failed';
  static const String signupSuccessful = 'Signup Successful (Mock)';

  // Session Management
  static const String sessionExpired = 'Session Expired';
  static const String sessionExpiredMessage = 'Your session has expired. Please login again.';
  static const String pleaseLoginAgain = 'Please Login Again';

  // Menu Screen
  static const String order = 'Order';
  static const String orders = 'Orders';
  
  // Categories
  static const String popular = 'Popular';
  static const String appetizers = 'Appetizers';
  static const String mainCourse = 'Main Course';

  // Menu Items
  static const String chickenWings = 'Chicken Wings';
  static const String chickenWingsDescription = 'Spicy, savory, and satisfying';
  static const String frenchFries = 'French Fries';
  static const String frenchFriesDescription = 'Crispy, golden, and delicious';
  static const String gardenSalad = 'Garden Salad';
  static const String gardenSaladDescription = 'Fresh, vibrant, and healthy';

  // Cart & Order Dialogs
  static const String addToCart = 'Add to Cart';
  static const String cancel = 'Cancel';
  static const String addToCartMessage = 'Add {item} to cart for \${price}?';
  static const String itemAddedToCart = '{item} added to cart!';

  // Branch Selection
  static const String selectBranch = 'Select Branch';
  static const String mainBranch = 'Main Branch';
  static const String mainBranchAddress = '123 Street, City';
  static const String parkAvenue = 'Park Avenue';
  static const String parkAvenueAddress = '456 Avenue, Uptown';

  // Cart Screen
  static const String myCart = 'My Cart';
  static const String cartContent = 'Cart Content';

  // Checkout Screen
  static const String checkout = 'Checkout';
  static const String checkoutContent = 'Checkout Content';

  // Order Screens
  static const String orderHistory = 'Order History';
  static const String orderHistoryContent = 'Order History Content';
  static const String orderConfirmed = 'Order Confirmed';
  static const String orderConfirmationContent = 'Order Confirmation Content';

  // Menu Listing & Item Detail
  static const String menuListing = 'Menu Listing';
  static const String menuListingContent = 'Menu Listing Content';
  static const String itemDetail = 'Item Detail';
  static const String itemDetailContent = 'Item Detail Content';

  // Helper methods for dynamic strings
  static String formatAddToCartMessage(String itemName, double price) {
    return addToCartMessage
        .replaceAll('{item}', itemName)
        .replaceAll('{price}', price.toStringAsFixed(2));
  }

  static const String forgotPasswordTitle = 'Forgot password';
  static const String forgotPasswordSubtitle = 'Enter your email address and we will send you a reset instructions.';
  static const String resetPassword = 'RESET PASSWORD';
  static const String resetToken = 'RESET TOKEN';
  static const String enterResetToken = 'Enter your token and new password.';
  static const String emailNotFound = 'Email not found. Please try again.';
  static const String passwordResetSuccess = 'Password reset successful! Please login.';
  static const String resetFailed = 'Reset failed';
  static const String sendResetInstructions = 'Password reset instructions sent to your email';
  static const String failedToSendResetEmail = 'Failed to send reset email';
  static const String pleaseEnterEmail = 'Please enter your email';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String newPassword = 'NEW PASSWORD';
  static const String confirmPassword = 'CONFIRM PASSWORD';
  static const String reset = 'RESET';

  static String formatItemAddedToCart(String itemName) {
    return itemAddedToCart.replaceAll('{item}', itemName);
  }

  // Search Screen
  static const String searchTitle = 'Search';
  static const String searchHint = 'Search';
  static const String viewAll = 'View All';
  static const String popularRecipes = 'Popular Recipes';
  static const String featured = 'Featured';
  static const String category = 'Category';
  static const String editorsChoice = 'Editor\'s Choice';
  
  // Profile Screen
  static const String profileTitle = 'Profile';
  static const String name = 'Name';
  static const String save = 'SAVE';
  static const String oldPassword = 'OLD PASSWORD';
  static const String enterCurrentPassword = 'Please enter current password';
  static const String profileUpdatedSuccess = 'Profile updated successfully';
  
  // Branch Selection
  static const String retry = 'Retry';
  static const String noBranchesAvailable = 'No branches available';
  
  // Logout
  static const String logout = 'Logout';
  static const String logoutButton = 'LOGOUT';
  static const String logoutConfirmTitle = 'Logout';
  static const String logoutConfirmMessage = 'Are you sure you want to logout?';
  static const String user = 'User';
  
  // Menu Item Details
  static const String ingredients = 'Ingredients';
  static const String addAllToCart = 'Add All to Cart';
  static const String addToCartButton = 'Add To Cart';
  static const String relatedRecipes = 'Related Recipes';
  static const String seeAll = 'See All';
  static const String min = 'Min';
  static const String kcal = 'Kcal';
  static const String carbs = 'carbs';
  static const String proteins = 'proteins';
  static const String fats = 'fats';
  static const String item = 'Item'; // e.g. "6 Item"
  
  // Checkout Screen
  static const String deliveryAddress = 'Delivery Address';
  static const String change = 'Change';
  static const String paymentMethod = 'Payment Method';
  static const String orderNotes = 'Order Notes';
  static const String orderSummary = 'Order Summary';
  static const String subtotal = 'Subtotal';
  static const String deliveryFee = 'Delivery Fee';
  static const String tax = 'Tax';
  static const String total = 'Total';
  static const String placeOrder = 'PLACE ORDER';
  
  // Payment Methods
  static const String paypal = 'PayPal';
  static const String klarna = 'Klarna';
  static const String cashOnDelivery = 'Cash on Delivery';
  static const String selectPaymentMethod = 'Select Payment Method';
  
  // Order Details Screen
  static const String orderDetails = 'Order Details';
  static const String completed = 'Completed';
  static const String restaurantBranch = 'Restaurant Branch';
  static const String itemsOrdered = 'Items Ordered';
  static const String totalPaid = 'Total Paid';
  static const String qty = 'Qty';

  static const String changeBranch = 'Change Branch';
  static const String clear = 'Clear';
  static const String applyFilters = 'APPLY FILTERS';
  static const String noCategoriesAvailable = 'No categories available';
  
  static const String myFavorites = 'My Favorites';
  static const String noFavoritesYet = 'No Favorites Yet';
  static const String startAddingFavorites = 'Start adding your favorite items!';
  static const String favoriteItemRemoved = 'Item removed from favorites';
}

