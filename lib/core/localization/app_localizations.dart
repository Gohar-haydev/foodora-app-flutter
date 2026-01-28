import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('sv'), // Swedish
  ];

  // Get localized strings based on current locale
  Map<String, String> get _localizedStrings {
    switch (locale.languageCode) {
      case 'sv':
        return _swedishStrings;
      case 'en':
      default:
        return _englishStrings;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // English strings
  static const Map<String, String> _englishStrings = {
    // App Info
    'app_name': 'Foodie',
    'app_tagline': 'Order from your favorite restaurants',
    'select_branch_title' : 'Select Branch',
    // Auth Screens
    'sign_in': 'Sign In',
    'welcome_back': 'Welcome back',
    'create_account': 'Create Account',
    'sign_up_subtitle': 'Enter your Name, Email and Password for sign up.',
    'email': 'Email',
    'email_address': 'EMAIL ADDRESS',
    'password': 'Password',
    'password_placeholder': '******',
    'full_name': 'Full Name',
    'full_name_placeholder': 'FULL NAME',
    'phone': 'PHONE NUMBER',
    'forgot_password': 'Forgot password?',
    'log_in': 'Log In',
    'sign_up': 'SIGN UP',
    'continue_as_guest': 'Continue as Guest',
    'dont_have_account': 'Don\'t have account?',
    'already_have_account': 'Already have account?',
    'terms_and_conditions': 'By Signing up you agree to our Terms Conditions & Privacy Policy.',
    'missing_information': 'Missing Information',
    'signing_in': 'Signing in...',
    'please_fill_all_fields': 'Please fill in all fields',
    'login_failed': 'Login Failed',
    'validation_error': 'Validation Error',
    'creating_account': 'Creating your account...',
    'registration_failed': 'Registration Failed',
    
    // Greetings
    'good_morning': 'Good Morning',
    'good_afternoon': 'Good Afternoon',
    'good_evening': 'Good Evening',
    'good_night': 'Good Night',
    
    // Navigation
    'cart': 'Cart',
    'home': 'Home',
    'search': 'Search',
    'notification': 'Notification',
    'profile': 'Profile',
    'orders': 'Orders',
    
    // Branch Selection
    'select_branch': 'Select Branch',
    'select_button': 'Select',
    'change_branch': 'Change Branch',
    
    // Cart
    'empty_cart': 'Your cart is empty',
    'checkout': 'Checkout',
    'subtotal': 'Subtotal',
    'delivery_fee': 'Delivery Fee',
    'tax': 'Tax',
    'total': 'Total',
    
    // Menu
    'featured': 'Featured',
    'category': 'Category',
    'popular_recipes': 'Popular Recipes',
    'see_all': 'See All',
    'featured_card_title_1': 'Free Delivery',
    'featured_card_title_2': '20% Off Today',
    'featured_card_time_1': 'Limited Time',
    'featured_card_time_2': 'Today Only',
    'no_menu_items': 'No menu items available',
    'from': 'from',
    
    // Item Details
    'ingredients': 'Ingredients',
    'add_to_cart': 'Add To Cart',

    'addons': 'Add-ons',
    'no_addons_available': 'No add-ons available',
    'special_instructions': 'Special Instructions',
    'special_instructions_hint': 'Any specific preferences or dietary requirements?',
    'instructions_label': 'Instructions',
    'instructions_example': 'e.g. No onions, extra sauce, etc.',
    'added_to_cart': 'added to cart',
    'min': 'Min',
    'kcal': 'Kcal',
    'carbs': 'carbs',
    'proteins': 'proteins',
    'fats': 'fats',
    'free': 'Free',
    
    // Checkout
    'delivery_address': 'Delivery Address',
    'change': 'Change',
    'payment_method': 'Payment Method',
    'order_notes': 'Order Notes',
    'order_summary': 'Order Summary',
    'place_order': 'PLACE ORDER',
    'paypal': 'PayPal',
    'klarna': 'Klarna',
    'klarna_payment': 'Klarna Payment',
    'cash_on_delivery': 'Cash on Delivery',
    'select_payment_method': 'Select Payment Method',
    'failed_to_place_order': 'Failed to place order',
    'order_notes_hint': 'Add any special instructions or notes for your order...',
    'your_cart_is_empty': 'Your cart is empty',
    'order_confirmation': 'Order Confirmation',
    'order_placed_successfully': 'Order Placed Successfully!',
    'order_placed_subtitle': 'Your order has been received and is being prepared. You will receive a notification when it\'s ready for pickup.',
    'order_number': 'Order Number',
    'estimated_time': 'Estimated Time',
    'cash': 'Cash',
    'view_order': 'VIEW ORDER',
    'retry': 'Retry',
    'no_categories_available': 'No categories available',
    'clear': 'Clear',
    'apply_filters': 'APPLY FILTERS',
    'search_title': 'Search',
    'search_hint': 'Search for food...',
    'no_results_found': 'No results found',
    'search_placeholder': 'Search for menu items or select a category',
    'notifications_title': 'Notifications',
    'today': 'Today',
    'yesterday': 'Yesterday',
    'mark_all_read': 'Mark all as Read',
    'order_delivered': 'Order Delivered',
    'order_cancelled': 'Order Cancelled',
    'order_delivered_desc': 'Your order has been delivered successfully.',
    'order_cancelled_desc': 'Your order has been cancelled.',
    'track_order': 'Track Order',
    'no_address_available': 'No address available',
    'status_pending': 'Pending',
    'status_confirmed': 'Confirmed',
    'status_preparing': 'Preparing',
    'status_ready': 'Ready',
    'status_out_for_delivery': 'Out for Delivery',
    'status_delivered': 'Delivered',
    'status_cancelled': 'Cancelled',
    'order_history': 'Order History',
    'past_orders': 'Past Orders',
    'no_past_orders_found': 'No past orders found.',
    'more': 'more',
    'no_tracking_data': 'No tracking data available',
    'delivery_status': 'Delivery Status',
    'branch_information': 'Branch Information',
    'stepper_cooking': 'Cooking',
    'stepper_on_way': 'On Way',
    'timeline_placed': 'Placed',
    'timeline_ready_pickup': 'Ready for Pickup',
    'profile_title': 'Profile',
    'user': 'User',
    'old_password': 'Old Password',
    'save': 'SAVE',
    'enter_current_password': 'Please enter current password',
    'profile_updated_success': 'Profile updated successfully',
    'please_enter_email': 'Please enter email address',
    'send_reset_instructions': 'Reset instructions sent to your email',
    'failed_to_send_reset_email': 'Failed to send reset email',
    'create_new_password_title': 'Create New Password',
    'enter_reset_token': 'Enter the token sent to your email',
    'reset_token': 'Reset Token',
    'password_reset_success': 'Password reset successfully',
    'failed_to_reset_password': 'Failed to reset password',
    'email_not_found': 'Email not found',
    'reset_failed': 'Password Reset Failed',
    'onboarding_title_1': 'Delicious Food',
    'onboarding_desc_1': 'Experience the best food from top restaurants.',
    'onboarding_title_2': 'Fast Delivery',
    'onboarding_desc_2': 'Get your favorite food delivered to your doorstep in minutes.',
    'onboarding_title_3': 'Easy Payment',
    'onboarding_desc_3': 'Multiple payment options available. Safe and secure.',
    'get_started': 'Get Started',
    'next': 'Next',
    'session_expired': 'Session Expired',
    'session_expired_message': 'Your session has expired. Please login again.',
    'please_login_again': 'Please Login Again',
    
    // Profile
    'logout': 'Logout',
    'logout_button': 'LOGOUT',
    'logout_confirm_title': 'Logout',
    'logout_confirm_message': 'Are you sure you want to logout?',
    'cancel': 'Cancel',
    'delete_account': 'Delete Account',
    'delete_account_confirm_title': 'Delete Account',
    'delete_account_confirm_message': 'Are you sure you want to delete your account? This action cannot be undone.',
    
    // Password Reset
    'forgot_password_title': 'Forgot password',
    'forgot_password_subtitle': 'Enter your email address and we will send you a reset instructions.',
    'reset_password': 'RESET PASSWORD',
    'new_password': 'NEW PASSWORD',
    'confirm_password': 'CONFIRM PASSWORD',
    'reset': 'RESET',
    'passwords_do_not_match': 'Passwords do not match',
    'password_changed_title': 'Password Changed!',
    'password_changed_subtitle': 'Your Password has been changed\\nsuccessfully.',
    'back_to_login': 'BACK TO LOGIN',
    
    // Favorites
    'my_favorites': 'My Favorites',
    'no_favorites_yet': 'No Favorites Yet',
    'start_adding_favorites': 'Start adding your favorite items!',
    'change_address_title': 'Change Address',
    'fetching_location': 'Fetching Location...',
    'use_current_location': 'Use Current Location',
    'street_address': 'Street Address',
    'street_address_hint': 'Enter your street address',
    'city': 'City',
    'city_hint': 'Enter city',
    'state_province': 'State/Province',
    'state_hint': 'State',
    'zip_code': 'ZIP Code',
    'zip_hint': 'ZIP',
    'country': 'Country',
    'country_hint': 'Enter country',
    'save_address_button': 'SAVE ADDRESS',
    
    // Order Details
    'order_details': 'Order Details',
    'completed': 'Completed',
    'restaurant_branch': 'Restaurant Branch',
    'items_ordered': 'Items Ordered',
    'total_paid': 'Total Paid',
    'qty': 'Qty',
    'cancel_order': 'Cancel Order',
    'cancel_order_confirm_message': 'Are you sure you want to cancel this order?',
    'yes': 'Yes',
    'no': 'No',
    
    // Language
    'language': 'Language',
    'select_language': 'Select Language',
    'english': 'English',
    'swedish': 'Swedish',
    'currency': 'Currency',
    'change_currency': 'Change Currency',
    'select_currency': 'Select Currency',
    'krones': 'Krones',
  };

  // Swedish strings
  static const Map<String, String> _swedishStrings = {
    // App Info
    'app_name': 'Foodie',
    'app_tagline': 'Beställ från dina favoritrestauranger',
    'select_branch_title' : 'Välj gren',
    // Auth Screens
    'sign_in': 'Logga in',
    'welcome_back': 'Välkommen tillbaka',
    'create_account': 'Skapa konto',
    'sign_up_subtitle': 'Ange ditt namn, e-post och lösenord för att registrera dig.',
    'email': 'E-post',
    'email_address': 'E-POSTADRESS',
    'password': 'Lösenord',
    'password_placeholder': '******',
    'full_name': 'Fullständigt namn',
    'full_name_placeholder': 'FULLSTÄNDIGT NAMN',
    'phone': 'TELEFONNUMMER',
    'forgot_password': 'Glömt lösenord?',
    'log_in': 'Logga in',
    'sign_up': 'REGISTRERA',
    'continue_as_guest': 'Fortsätt som gäst',
    'dont_have_account': 'Har du inget konto?',
    'already_have_account': 'Har du redan ett konto?',
    'terms_and_conditions': 'Genom att registrera dig godkänner du våra villkor och sekretesspolicy.',
    'missing_information': 'Information saknas',
    'signing_in': 'Loggar in...',
    'please_fill_all_fields': 'Vänligen fyll i alla fält',
    'login_failed': 'Inloggning misslyckades',
    'validation_error': 'Valideringsfel',
    'creating_account': 'Skapar ditt konto...',
    'registration_failed': 'Registrering misslyckades',
    
    // Greetings
    'good_morning': 'God morgon',
    'good_afternoon': 'God eftermiddag',
    'good_evening': 'God kväll',
    'good_night': 'God natt',
    
    // Navigation
    'cart': 'Varukorg',
    'home': 'Hem',
    'search': 'Sök',
    'notification': 'Meddelande',
    'profile': 'Profil',
    'orders': 'Beställningar',
    
    // Branch Selection
    'select_branch': 'Välj filial',
    'select_button': 'Välj',
    'change_branch': 'Byt filial',
    
    // Cart
    'empty_cart': 'Din varukorg är tom',
    'checkout': 'Kassa',
    'subtotal': 'Delsumma',
    'delivery_fee': 'Leveransavgift',
    'tax': 'Moms',
    'total': 'Totalt',
    
    // Menu
    'featured': 'Utvalda',
    'category': 'Kategori',
    'popular_recipes': 'Populära recept',
    'see_all': 'Se alla',
    'featured_card_title_1': 'Fri leverans',
    'featured_card_title_2': '20% rabatt idag',
    'featured_card_time_1': 'Begränsad tid',
    'featured_card_time_2': 'Endast idag',
    'no_menu_items': 'Inga menyalternativ tillgängliga',
    'from': 'från',
    
    // Item Details
    'ingredients': 'Ingredienser',
    'add_to_cart': 'Lägg till i varukorgen',
    'addons': 'Tillägg',
    'no_addons_available': 'Inga tillägg tillgängliga',
    'special_instructions': 'Specialinstruktioner',
    'special_instructions_hint': 'Några specifika preferenser eller kostbehov?',
    'instructions_label': 'Instruktioner',
    'instructions_example': 't.ex. Ingen lök, extra sås, etc.',
    'added_to_cart': 'tillagd i varukorgen',
    'min': 'Min',
    'kcal': 'Kcal',
    'carbs': 'kolhydrater',
    'proteins': 'proteiner',
    'fats': 'fetter',
    'free': 'Gratis',
    
    // Checkout
    'delivery_address': 'Leveransadress',
    'change': 'Ändra',
    'payment_method': 'Betalningsmetod',
    'order_notes': 'Beställningsanteckningar',
    'order_summary': 'Beställningssammanfattning',
    'place_order': 'LÄGG BESTÄLLNING',
    'paypal': 'PayPal',
    'klarna': 'Klarna',
    'klarna_payment': 'Klarna Betalning',
    'cash_on_delivery': 'Kontant vid leverans',
    'select_payment_method': 'Välj betalningsmetod',
    'failed_to_place_order': 'Misslyckades att lägga beställning',
    'order_notes_hint': 'Lägg till särskilda instruktioner eller anteckningar för din beställning...',
    'your_cart_is_empty': 'Din varukorg är tom',
    'order_confirmation': 'Orderbekräftelse',
    'order_placed_successfully': 'Beställning mottagen!',
    'order_placed_subtitle': 'Din beställning har mottagits och förbereds. Du får ett meddelande när den är klar för upphämtning.',
    'order_number': 'Beställningsnummer',
    'estimated_time': 'Beräknad tid',
    'cash': 'Kontant',
    'view_order': 'VISA BESTÄLLNING',
    'retry': 'Försök igen',
    'no_categories_available': 'Inga kategorier tillgängliga',
    'clear': 'Rensa',
    'apply_filters': 'ANVÄND FILTER',
    'search_title': 'Sök',
    'search_hint': 'Sök efter mat...',
    'no_results_found': 'Inga resultat hittades',
    'search_placeholder': 'Sök efter menyalternativ eller välj en kategori',
    'notifications_title': 'Notifikationer',
    'today': 'Idag',
    'yesterday': 'Igår',
    'mark_all_read': 'Markera allt som läst',
    'order_delivered': 'Beställning levererad',
    'order_cancelled': 'Beställning avbruten',
    'order_delivered_desc': 'Din beställning har levererats.',
    'order_cancelled_desc': 'Din beställning har avbrutits.',
    'track_order': 'Spåra beställning',
    'no_address_available': 'Ingen adress tillgänglig',
    'status_pending': 'Väntande',
    'status_confirmed': 'Bekräftad',
    'status_preparing': 'Förbereder',
    'status_ready': 'Klar',
    'status_out_for_delivery': 'Ute för leverans',
    'status_delivered': 'Levererad',
    'status_cancelled': 'Avbruten',
    'order_history': 'Orderhistorik',
    'past_orders': 'Tidigare beställningar',
    'no_past_orders_found': 'Inga tidigare beställningar hittades.',
    'more': 'mer',
    'no_tracking_data': 'Ingen spårningsdata tillgänglig',
    'delivery_status': 'Leveransstatus',
    'branch_information': 'Filialinformation',
    'stepper_cooking': 'Tillagas',
    'stepper_on_way': 'På väg',
    'timeline_placed': 'Mottagen',
    'timeline_ready_pickup': 'Klar för upphämtning',
    'profile_title': 'Profil',
    'user': 'Användare',
    'old_password': 'Gammalt lösenord',
    'save': 'SPARA',
    'enter_current_password': 'Ange nuvarande lösenord',
    'profile_updated_success': 'Profil uppdaterad',
    'please_enter_email': 'Ange e-postadress',
    'send_reset_instructions': 'Återställningsinstruktioner skickade till din e-post',
    'failed_to_send_reset_email': 'Misslyckades att skicka återställningsmejl',
    'create_new_password_title': 'Skapa nytt lösenord',
    'enter_reset_token': 'Ange token skickad till din e-post',
    'reset_token': 'Återställningskod',
    'password_reset_success': 'Lösenord återställt',
    'failed_to_reset_password': 'Misslyckades att återställa lösenord',
    'email_not_found': 'E-post hittades inte',
    'reset_failed': 'Lösenordsåterställning misslyckades',
    'onboarding_title_1': 'God Mat',
    'onboarding_desc_1': 'Upplev den bästa maten från toppmatsställen.',
    'onboarding_title_2': 'Snabb Leverans',
    'onboarding_desc_2': 'Få din favoritmat levererad till dörren på minuter.',
    'onboarding_title_3': 'Enkel Betalning',
    'onboarding_desc_3': 'Flera betalningsalternativ tillgängliga. Säkert och tryggt.',
    'get_started': 'Kom igång',
    'next': 'Nästa',
    'session_expired': 'Sessionen utlöpt',
    'session_expired_message': 'Din session har gått ut. Vänligen logga in igen.',
    'please_login_again': 'Logga in igen',
    
    // Profile
    'logout': 'Logga ut',
    'logout_button': 'LOGGA UT',
    'logout_confirm_title': 'Logga ut',
    'logout_confirm_message': 'Är du säker på att du vill logga ut?',
    'cancel': 'Avbryt',
    'delete_account': 'Radera konto',
    'delete_account_confirm_title': 'Radera konto',
    'delete_account_confirm_message': 'Är du säker på att du vill radera ditt konto? Denna åtgärd kan inte ångras.',
    
    // Password Reset
    'forgot_password_title': 'Glömt lösenord',
    'forgot_password_subtitle': 'Ange din e-postadress så skickar vi dig återställningsinstruktioner.',
    'reset_password': 'ÅTERSTÄLL LÖSENORD',
    'new_password': 'NYTT LÖSENORD',
    'confirm_password': 'BEKRÄFTA LÖSENORD',
    'reset': 'ÅTERSTÄLL',
    'passwords_do_not_match': 'Lösenorden matchar inte',
    'password_changed_title': 'Lösenord ändrat!',
    'password_changed_subtitle': 'Ditt lösenord har ändrats\\nframgångsrikt.',
    'back_to_login': 'TILLBAKA TILL INLOGGNING',
    
    // Favorites
    'my_favorites': 'Mina favoriter',
    'no_favorites_yet': 'Inga favoriter än',
    'start_adding_favorites': 'Börja lägga till dina favoritartiklar!',
    'change_address_title': 'Ändra adress',
    'fetching_location': 'Hämtar plats...',
    'use_current_location': 'Använd nuvarande plats',
    'street_address': 'Gatuadress',
    'street_address_hint': 'Ange din gatuadress',
    'city': 'Stad',
    'city_hint': 'Ange stad',
    'state_province': 'Län/Provins',
    'state_hint': 'Län',
    'zip_code': 'Postnummer',
    'zip_hint': 'Postnr',
    'country': 'Land',
    'country_hint': 'Ange land',
    'save_address_button': 'SPARA ADRESS',
    
    // Order Details
    'order_details': 'Beställningsdetaljer',
    'completed': 'Slutförd',
    'restaurant_branch': 'Restaurangfilial',
    'items_ordered': 'Beställda artiklar',
    'total_paid': 'Totalt betalt',
    'qty': 'Antal',
    'cancel_order': 'Avbryt beställning',
    'cancel_order_confirm_message': 'Är du säker på att du vill avbryta denna beställning?',
    'yes': 'Ja',
    'no': 'Nej',
    
    // Language
    'language': 'Språk',
    'select_language': 'Välj språk',
    'english': 'Engelska',
    'swedish': 'Svenska',
    'currency': 'Valuta',
    'change_currency': 'Ändra valuta',
    'select_currency': 'Välj valuta',
    'krones': 'Kronor',
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sv'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
