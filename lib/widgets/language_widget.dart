import 'package:flutter/material.dart';
import 'package:posternova/services/language/language_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String? _userId; // Add this to store userId

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  // Add method to set userId
  void setUserId(String? userId) {
    _userId = userId;
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<bool> setLocale(Locale locale) async {
    if (_locale == locale) return true;

    // Call API first if userId is available
    if (_userId != null) {
      final success = await ApiService.updateUserLanguage(
        _userId!,
        locale.languageCode,
      );

      if (!success) {
        print('Failed to update language on server');
        return false;
      }
    }

    // Update local state only after successful API call
    _locale = locale;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    notifyListeners();
    return true;
  }
}

// class LanguageProvider extends ChangeNotifier {
//   Locale _locale = const Locale('en');

//   Locale get locale => _locale;

//   LanguageProvider() {
//     _loadSavedLanguage();
//   }

//   Future<void> _loadSavedLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String languageCode = prefs.getString('language_code') ?? 'en';
//     _locale = Locale(languageCode);
//     notifyListeners();
//   }

//   Future<void> setLocale(Locale locale) async {
//     if (_locale == locale) return;

//     _locale = locale;

//     // Save to SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language_code', locale.languageCode);

//     notifyListeners();
//   }
// }

class LocalizationService {
  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'app_title': 'Poster Maker',
      'search_placeholder': 'Search Poster by Topic',
      'upcoming_festivals': 'Upcoming Festivals',
      'festivals': 'Festivals',
      'new_poster': 'New Poster',
      'no_festivals_found': 'No Festivals Found',
      'try_different_date': 'Try selecting a different date',
      'check_other_dates': 'Check Other Dates',
      'no_new_posters': 'No New posters available',
      'view_all': 'View All',
      'select_language': 'Select Language',
      'language_switched': 'Language switched successfully!',
      'ugadi': 'Ugadi',
      'clothing': 'Clothing',
      'beauty': 'Beauty',
      'chemical': 'Chemical',
      'subscription_plans': 'Subscription Plans',
      'choose_plan': 'Choose Your Plan',
      'payment_options': 'Payment Options',
      'free': 'Free',
      'activate_plan': 'ACTIVATE PLAN',
      'pay_now': 'PAY NOW',
      'welcome_back': 'Welcome back!',
      'design_studio': 'Design Studio',

      'online_punchang': 'Online Punchang',
      'invoices': 'Invoices',
      'update_profile': 'Update Profile', // English

      'choose_canvas_size': 'Choose Canvas Size',
      'select_perfect_size': 'Select the perfect size for your design',

      // NEW KEYS
      'categories': 'Categories',
      'create_template': 'Create Template',
      'logo_design': 'Logo Design',
      'image_to_video': 'Image to Video',
      'create_poster': 'Create Poster',
      'get_invoice': 'Get Invoice',
      'no_invoice_yet': 'No invoice Yet',
      'create_first_invoice': 'Create your first invoice!',
      'create_new_invoice': 'Create New Invoice',
      'add_customers': 'Add customers',
      'no_customers_found': 'No customers found',
      'add_first_customer': 'Add your first customer to get started',
      'add_new_customer': 'Add new Customer',
      'chooose_plan': 'Choose Plan',
      'your_story': 'Your Story',
      'add_user_data': 'Add User Data',
      'business_name': 'Business Name',
      'mobile_number': 'Mobile Number',
      'email_id': 'Email ID',
      'gst': 'GST',
      'business_type': 'Business Type',
      'home': 'Home',
      'category': 'Category',
      'create': 'Create',
      'invoice': 'Invoice',
      'add_customer': 'Add Customer',
      'custom_post': 'Create Custom Post',
      'square_post': 'Square Post',
      'story_post': 'Story Post',
      'cover_picture': 'Cover Picture',
      'display_picture': 'Display Picture',
      'instagram_post': 'Instagram Post',
      'youtube_thumbnail': 'YouTube Thumbnail',
      'a4_size': 'A4 Size',
      'certificate': 'Certificate',
      'poster_maker': 'Poster Maker',
      'add_image': 'Add Image',
      'logo_maker': 'Logo Maker',
      'create_invoice': 'Create Invoice',
      'logo': 'Logo',
      'choose_logo': 'Choose Logo',
      'customer_name': 'Customer Name',
      'customer_mobile': 'Customer Mobile',
      'customer_address': 'Customer Address',
      'product_name': 'Product Name',
      'quantity': 'Quantity',
      'description': 'Description',
      'price': 'Price',
      'offer_price': 'Offer Price',
      'hsn': 'HSN',
      'add_more': 'Add More',
      'logo_editor': 'Logo Editor',
      'text': 'Text',
      'image': 'Image',
      'shapes': 'Shapes',
      'elements': 'Elements',
      'choose_shape': 'Choose Shape',
      'circle': 'Circle',
      'rectangle': 'Rectangle',
      'triangle': 'Triangle',
      'star': 'Star',
      'choose_element': 'Choose Element',
      'heart': 'Heart',
      'bulb': 'Bulb',
      'music': 'Music',
      'camera': 'Camera',
      'phone': 'Phone',
      'email': 'Email',
      'location': 'Location',
      'name': 'Name',
      'email_optional': 'E-Mail (Optional)',
      'address': 'Address',
      'gender': 'Gender',
      'date_of_birth': 'Date of Birth',
      'date_of_anniversary': 'Date of Anniversary',
      'edit_poster': 'Edit Poster',
      'marriage_anniversary': 'Marriage Anniversary',

      'select_contact': 'Select Contact',
      'save_logo': 'Save Logo',

      'poster': 'Poster',
      'reels': 'Reels',
      'customer': 'Customer',
      'total_customers': 'Total Customers',

      'create_story': 'Create Story',
      'new_story': 'New Story',
      'create_your_story': 'Create Your Story',
      'share_story_prompt':
          'Share a photo or video to let your\nfriends know what you\'re up to',
      'add_photo': 'Add Photo',
      'story_visible_24h':
          'Stories are visible for 24 hours and can be viewed by your friends',
      'add_caption': 'Add a caption',
      'story_disappear_24h': 'Your story will disappear after 24 hours',
      'additional_information': 'Additional Information',

      'background': 'Background',
      'profile': 'Profile',
      'filter': 'Filter',
      'color': 'Color',
      'add_text': 'Add Text',
      'stickers': 'Stickers',
      'contact': 'Contact',
      'save': 'Save',
      'explore_templates': 'Explore Templates',
      'browse_or_voice_search': 'Browse categories or search with voice',
      'edit_profile': 'Edit Profile',
      'tap_change_photo': 'Tap to change photo',
      'personal_information': 'Personal Information',

      'new_customer': 'New Customer',
      'fill_customer_details': 'Fill in customer details',
      'basic_information': 'Basic Information',

      'seasonal_celebrations': 'Seasonal Celebrations',
      'never_miss_celebration': 'Never miss a celebration',
      'celebration_templates': 'Celebration Templates',
      'perfect_every_occasion': 'Perfect for every occasion',
      'weekly_templates': 'Weekly Templates',
      'fresh_designs_everyday': 'Fresh designs for every day',

      'share_referral_earn':
          'Share your referral code with friends and earn rewards when they upgrade',
      'your_referral_code': 'Your Referral Code',
      'how_it_works': 'How It Works',
      'send_referral_any_platform':
          'Send your referral code to friends via any platform',
      'share_your_code': 'Share Your Code',
      'friend_signs_up': 'Friend Signs Up',
      'enter_code_during_signup': 'They enter your code during registration',
      'earn_rewards': 'Earn Rewards',
      'get_200_on_upgrade': 'Get ₹200 when they upgrade their account',

      'text_remover': 'Text Remover',
      'remove_text_ai':
          'Remove unwanted text from your images with Editezy precision',
      'select_image': 'Select Image',

      //new ones
      'plan_details': 'Plan Details',
      'login_number': 'Login Number',
      'current_plan': 'Current Plan',
      'media_credits': 'Media Credits',
      'expires_on': 'Expires on',
      'how_to_use': 'How To Use',
      'change_industry': 'Change Industry',
      'refer_earn': 'Refer & Earn',
      'settings': 'Settings',
      'delete_account': 'Delete Account',
      'add_business': 'Add Business',
      'contact_us': 'Contact Us',
      'partner_with_us': 'Partner With Us',
      'rate_app': 'Rate App',
      'policies': 'Policies',
      'terms_conditions': 'Terms and Conditions',
      'chat_with_ai': 'Chat With AI',
      'logout': 'Logout',
      'back': 'Back',
      'bday_greetings': 'B\'day Greetings',
      'brand_info': 'Brand Info',
      'remove_background': 'Remove Background',
      'caption': 'Caption',
      'whatsapp_sticker': 'WhatsApp Sticker',
      'auto_product_ad': 'Auto Product Ad',
      'ask_me_anything': 'Ask me anything',
      'privacy_policy': 'Privacy Policy',
      'terms_and_conditions': 'Terms & Conditions',
      'logo_categories': 'Logo Categories',
      'logo_templates': 'Logo Templates',

      'total_and_taxes': 'Total & Taxes',

      'business_profile': 'Business Profile',
'add_business_logo': 'Add Business Logo',
'upload_business_logo': 'Upload your business logo or brand image',
'business_details': 'Business Details',
'business_name': 'Business Name',
'business_type': 'Business Type',
'contact_information': 'Contact Information',
'mobile_number': 'Mobile Number',
'email_address': 'Email Address',
'gst_number_optional': 'GST Number (Optional)',
'gst_rate_percent': 'GST Rate % (e.g., 18%)',
'save_profile': 'Save Profile',



      'chat': 'Chat',

      'chat_with_chicha': 'Chat with Chicha',
      'start_chat_with_chicha': 'Start Chat with Chicha',

      'enter_full_name': 'Enter full name',
      'enter_mobile_number': 'Enter mobile number',
      'enter_email_optional': 'Enter email address (optional)',
      'select_gender': 'Select gender',
      'select_religion': 'Select religion',
      'enter_address_optional': 'Enter address (optional)',

      'create_business_post': 'Create Business Post',
      'add_business_logo': 'Add Business Logo',

      'invite_friend': 'Invite a friend',
      'share_code_button': 'Share your code using the Share button.',
      'enter_code_signup_settings':
          'They enter your code during signup or in settings',
      'both_get_rewards': 'Both get rewards',
      'credits_after_purchase':
          'Credits are added after successful first purchase',
      'logo_history': 'Logo History',

      'about': 'About',
      'chicha_ai': 'Chicha AI',
      'text_remover': 'Text Remover',

      'owner_name': 'Owner Name',
      'designation': 'Designation',
      'phone_number': 'Phone Number',
      'whatsapp_number': 'WhatsApp Number',
      'email_address': 'Email Address',
      'website': 'Website',
      'choose_perfect_design': 'Choose your perfect design',

      'poster_making': 'Poster Making',
      'add_filter': 'Add Filter',
      'add_color': 'Add Color',

      'no_invoices_yet': 'No Invoices Yet',
      'start_creating_invoices': 'Start creating professional invoices',
      'all_invoices': 'All Invoices',

      'gst_number': 'GST Number',
      'add_supporting_image': 'Add Supporting Image',
      'submit_post': 'Submit Post',
      'virtual_business_card': 'Virtual Business Card',

      'upload_brand_details': 'Upload Your Brand Details',
      'upload_logo': 'Upload Logo',
      'extra_elements': 'Extra Elements',
      'select_social_icons': 'Select Social Media Icons to Highlight on Post',

      'how_to_use_title': 'How to Use',
      'how_to_use_intro':
          '🖼️ Poster Making Application – Overview\n\nWhat is this App?\n\nThe Poster Making App is a simple and powerful tool designed to help users create personalized greeting posters for special occasions like birthdays and anniversaries. Whether you\'re a business wanting to send client wishes or an individual crafting messages for friends and family, this app makes it fast and easy.',
      'how_to_use_features':
          'Key Features\n• ✅ Add & manage customer details\n• 🎂 Select from birthday and anniversary templates\n• ✍️ Customize messages with editable captions\n• 🖼️ Choose and change templates with a tap\n• 💾 Save messages using SharedPreferences\n• 📤 Import customer data (planned feature)',
      'how_to_use_steps':
          '👨‍🏫 How to Use the App\n\n1. Add Customer Details\n   Tap on “Add Customer Details” to input name, date of birth, or anniversary.\n\n2. Select a Template\n   Choose between templates with or without images.\n\n3. Customize Your Caption\n   Type a custom message and hit Save.\n\n4. Change Templates\n   Tap “Change Template” to browse and select a new one.\n\n5. Preview or Share\n   (Optional feature to be added): Download or share the final poster.',
      'how_to_use_stack':
          '🛠️ Technology Stack\n• Flutter for UI\n• SharedPreferences for local storage\n• Image.network to load templates\n• Navigation & Routing for screen transitions',

      'bank_details': 'Bank Details',
      'add_bank_details': 'Add Your Bank Details',
      'secure_bank_info':
          'Securely add your banking information for transactions',
      'bank_info': 'Bank Information',
      'account_holder_name': 'Account Holder Name',
      'bank_name': 'Bank Name',
      'account_type': 'Account Type',
      'checking': 'Checking',
      'savings': 'Savings',
      'account_number': 'Account Number',
      'routing_number': 'Routing Number',
      'cancel': 'Cancel',
      'save_details': 'Save Details',
      'bank_details_saved': 'Bank details saved successfully!',

      'no_celebration_found': 'No Celebration Found',
      'try_select_different_date': 'Try to select a different date',

      'customers': 'Customers',
      'no_customers_yet': 'No customers yet',
      'add_first_customer_start': 'Add your first customer to get started',
      'adjust_search': 'Try adjusting your search',

      'search_customers': 'Search Customers',

      'total_earning': 'Total Earning till date',
      'current_balance': 'Current Balance',
      'redeem_now': 'Redeem Now',
      'refer_earn_big': 'Refer & Earn BIG!',
      'introduce_friend': 'Introduce a Friend & Get 30 Credit INSTANTLY!',
      'bonus_credit': 'Bonus! Get 50 Credit More When They Make a Purchase!',
      'earn_now': 'Earn Now',
      'referral_info': 'You can earn yearly subscription by refering 3 friends',

      'bday_anniversary': "B'day Anniversary Greetings",
      'add_customer_details': 'Add Customer\nDetails',
      'select_birthday_templates': 'Select Birthday Templates',
      'with_images': 'With Images',
      'without_images': 'Without Images',
      'birthday_captions': 'Birthday Captions',
      'select_anniversary_templates': 'Select Anniversary Templates',
      'anniversary_captions': 'Anniversary Captions',
      'change': 'Change',
      'message_with_image': 'This message will be sent with\nyour image.',

      'birth_date': 'BirthDate',
      'anniversary_date': 'Anniversary Date',
      'upload_profile_photo': 'Upload Profile Photo',
      'submit': 'Submit',
      'featured': 'Featured',

      'user_not_logged_in': 'User not logged in',
      'panchang_no_data': 'No data available for the selected date',
      'panchang_load_failed': 'Failed to load panchang data',
      'error_prefix': 'Error',
      'panchang_loading': 'Loading panchang...',
      'panchang_retry': 'Try Again',
      'panchang_change_location': 'Change Location',
      'panchang_location_hint': 'e.g. Hyderabad, Telangana, India',
      'panchang_dob': 'Date of Birth',
      'panchang_vaara': 'Weekday (Vaara)',
      'panchang_sunrise': 'Sunrise',
      'panchang_sunset': 'Sunset',
      'panchang_nakshatra': 'Nakshatra',
      'panchang_tithi': 'Tithi',
      'panchang_yoga': 'Yoga',
      'panchang_karana': 'Karana',
      'panchang_lord': 'Lord',

        'user_not_logged_in': 'User not logged in',
  'panchang_no_data': 'No data available for the selected date',
  'panchang_load_failed': 'Failed to load panchang data',
  'error_prefix': 'Error',
  'panchang_loading': 'Loading panchang...',
  'panchang_retry': 'Try Again',
  'panchang_change_location': 'Change Location',
  'panchang_location_hint': 'e.g. Hyderabad, Telangana, India',
  'panchang_dob': 'Date of Birth',
  'panchang_vaara': 'Weekday (Vaara)',
  'panchang_sunrise': 'Sunrise',
  'panchang_sunset': 'Sunset',
  'panchang_moonrise': 'Moonrise',        // ← NEW
  'panchang_moonset': 'Moonset',          // ← NEW
  'panchang_subtitle': 'Vedic Daily Almanac', // ← NEW
  'panchang_nakshatra': 'Nakshatra',
  'panchang_tithi': 'Tithi',
  'panchang_yoga': 'Yoga',
  'panchang_karana': 'Karana',
  'panchang_lord': 'Lord',

      'Monday': 'Monday',
      'Tuesday': 'Tuesday',
      'Wednesday': 'Wednesday',
      'Thursday': 'Thursday',
      'Friday': 'Friday',
      'Saturday': 'Saturday',
      'Sunday': 'Sunday',
      'today_prefix': 'Today',

      'happy_birthday': 'Happy Birthday',
      'happy_anniversary': 'Happy Anniversary',
      'loading_wishes': 'Loading wishes...',
      'loading_celebrations': 'Loading celebrations...',

      'describe_poster': 'Describe your poster...',

      'today': 'Today',

      'sorry_to_see_you_go':
          'We are sorry to see you go. Please review the information below before proceeding.',
      'warning': 'Warning',
      'action_permanent': 'This action is permanent and cannot be undone',
      'before_you_go': 'Before you go',
      'delete_confirm_understand':
          'I understand that deleting my account is permanent and all my data will be lost',

      'about_us': 'About Us',
      'create_stunning': 'Create stunning posters & logos effortlessly',
      'about_editezy': 'About Editezy',
      'about_description':
          'PosterNova is your all-in-one creative studio for designing stunning posters, logos, and promotional content...',
      'custom_templates': 'Custom Templates',
      'choose_thousands':
          'Choose from thousands of templates designed for every purpose.',
      'easy_sharing': 'Easy Sharing',
      'share_instantly': 'Share your designs instantly on social media.',
      'version_made': 'Version 1.0.0\nMade with ❤️ by Editezy Team',

      'notifications': 'Notifications',
      'dark_mode': 'Dark Mode',

      'contact_us_intro': 'We’d love to hear from you!',
      'contact_us_message':
          'Feel free to reach out with any questions or feedback.',
      'message': 'Message',
      'send_message': 'Send Message',

      'save_poster': 'Save Poster',
      'share_poster': 'Share Poster',
      'share_to_customers': 'Share to Customers',

      'customer_information': 'Customer Information',
      'product_details': 'Product Details',



      'create_amazing_content': 'Create amazing content',
      'what_do_you_want_create': 'What do you want to create?',
      'choose_tool_get_started': 'Choose a tool to get started',
      'poster_maker_title': 'Poster Maker',
      'design_beautiful_posters': 'Design beautiful posters',
      'customer_logo': 'Customer Logo',
      'create_logo_customers': 'Create logo for customers',
      'search_categories': 'Search categories',

      'reels': 'Reels',
      'amazing_video_editezy': 'Amazing video by Editezy! Check this out',

      'background_remover': 'Background Remover',
      'no_image_selected': 'No image selected',
      'tap_gallery_camera': 'Tap the gallery or camera button below to start',

      'user': 'User',
      'search_poster_by_topic': 'Search Poster by Topic',
      'username': 'Username',
      'share_invite_code': 'Share invite code',
      'copy': 'Copy',
      'select_business_industry': 'Select Your Business Industry',
      'search_posters': 'Search Posters',

      'delete_your_account': 'Delete Your Account',
      'delete_warning':
          'This action is permanent and cannot be undone. All your data will be erased',
      'delete_my_account': 'Delete My Account',

      'join_content_creator': 'Join Us As A Content Creator',
      'join_product_dealer': 'Join Us As A Product Dealer',
      'important_dates': 'Important Dates',
    },
    'te': {
      'app_title': 'పోస్టర్ మేకర్',
      'search_placeholder': 'విషయం ద్వారా పోస్టర్ వెతకండి',
      'upcoming_festivals': 'రాబోయే పండుగలు',
      'festivals': 'పండుగలు',
      'new_poster': 'కొత్త పోస్టర్',
      'important_dates': 'ముఖ్యమైన తేదీలు',

      'no_festivals_found': 'పండుగలు కనుగొనబడలేదు',
      'try_different_date': 'వేరే తేదీని ఎంచుకోవడానికి ప్రయత్నించండి',
      'check_other_dates': 'ఇతర తేదీలను తనిఖీ చేయండి',
      'no_new_posters': 'కొత్త పోస్టర్లు అందుబాటులో లేవు',
      'view_all': 'అన్నీ చూడండి',
      'select_language': 'భాషను ఎంచుకోండి',
      'language_switched': 'భాష విజయవంతంగా మార్చబడింది!',
      'ugadi': 'ఉగాది',
      'clothing': 'వస్త్రాలు',
      'beauty': 'అందం',
      'chemical': 'రసాయనిక',
      'subscription_plans': 'సబ్‌స్క్రిప్షన్ ప్లాన్‌లు',
      'choose_plan': 'మీ ప్లాన్‌ను ఎంచుకోండి',
      'payment_options': 'చెల్లింపు ఎంపికలు',
      'free': 'ఉచితం',
      'activate_plan': 'ప్లాన్ యాక్టివేట్ చేయండి',
      'pay_now': 'ఇప్పుడు చెల్లించండి',
      'welcome_back': 'తిరిగి స్వాగతం!',

      'today': 'ఈ రోజు',

      'logo_categories': 'లోగో వర్గాలు',
      'logo_templates': 'లోగో టెంప్లేట్లు',
      'choose_perfect_design': 'మీకు సరైన డిజైన్‌ను ఎంచుకోండి',

      'enter_full_name': 'పూర్తి పేరు నమోదు చేయండి',
      'enter_mobile_number': 'మొబైల్ నంబర్ నమోదు చేయండి',
      'enter_email_optional': 'ఇమెయిల్ చిరునామా నమోదు చేయండి (ఐచ్చికం)',
      'select_gender': 'లింగాన్ని ఎంచుకోండి',
      'select_religion': 'మతాన్ని ఎంచుకోండి',
      'enter_address_optional': 'చిరునామా నమోదు చేయండి (ఐచ్చికం)',

      'chat': 'చాట్',

      'save_logo': 'లోగోను సేవ్ చేయండి',

      'online_punchang': 'ఆన్‌లైన్ పంచాంగం',
      'edit_poster': 'పోస్టర్ సవరించండి',
      'invoices': 'ఇన్వాయిస్‌లు',
      'background_remover': 'నేపథ్యం తొలగింపు',
      'explore_templates': 'టెంప్లేట్లను చూడండి',
      'choose_canvas_size': 'క్యాన్వాస్ పరిమాణాన్ని ఎంచుకోండి',
      'select_perfect_size': 'మీ డిజైన్‌కు సరైన పరిమాణాన్ని ఎంచుకోండి',

      'new_customer': 'కొత్త కస్టమర్',
      'fill_customer_details': 'కస్టమర్ వివరాలను నమోదు చేయండి',
      'basic_information': 'ప్రాథమిక సమాచారం',

      'search_customers': 'గ్రాహకులను వెతకండి',

      'select_contact': 'సంప్రదింపును ఎంచుకోండి',

      'additional_information': 'అదనపు సమాచారం',

      'logo_history': 'లోగో చరిత్ర',

      'search_categories': 'వర్గాలను వెతకండి',

      'no_invoices_yet': 'ఇంకా ఇన్వాయిసులు లేవు',
      'start_creating_invoices':
          'ప్రొఫెషనల్ ఇన్వాయిసులు సృష్టించడం ప్రారంభించండి',
      'all_invoices': 'అన్ని ఇన్వాయిసులు',

      'no_celebration_found': 'ఎలాంటి వేడుకలు కనుగొనబడలేదు',
      'try_select_different_date': 'దయచేసి వేరే తేదీని ఎంచుకోండి',

      'chat_with_chicha': 'చిచాతో చాట్ చేయండి',
      'start_chat_with_chicha': 'చిచాతో చాట్ ప్రారంభించండి',
      'ask_me_anything': 'ఏదైనా అడగండి',
      'poster': 'పోస్టర్',

      'text': 'పాఠ్యం',
      'image': 'చిత్రం',
      'shapes': 'ఆకారాలు',
      'elements': 'అంశాలు',

      'home': 'హోమ్',
      'category': 'వర్గం',
      'poster': 'పోస్టర్',
      'reels': 'రీల్స్',
      'customer': 'కస్టమర్',

      'update_profile': 'ప్రొఫైల్‌ను నవీకరించండి',

      'delete_account': 'ఖాతాను తొలగించండి',
      'sorry_to_see_you_go':
          'మీరు వెళ్తుండటం మాకు బాధగా ఉంది. ముందుకు సాగేముందు దయచేసి క్రింది సమాచారాన్ని పరిశీలించండి.',
      'warning': 'హెచ్చరిక',
      'action_permanent': 'ఈ చర్య శాశ్వతమైనది మరియు తిరిగి మార్చలేము',
      'before_you_go': 'మీరు వెళ్లే ముందు',
      'delete_confirm_understand':
          'నా ఖాతాను తొలగించడం శాశ్వతమని మరియు నా మొత్తం డేటా కోల్పోతానని నేను అర్థం చేసుకున్నాను',

      'save_poster': 'పోస్టర్‌ను సేవ్ చేయండి',
      'share_poster': 'పోస్టర్‌ను పంచుకోండి',
      'share_to_customers': 'గ్రాహకులతో పంచుకోండి',
      'total_customers': 'మొత్తం గ్రాహకులు',

      'seasonal_celebrations': 'కాలానుగుణ వేడుకలు',
      'never_miss_celebration': 'ఏ వేడుకను కూడా కోల్పోకండి',
      'celebration_templates': 'వేడుక టెంప్లేట్లు',
      'perfect_every_occasion': 'ప్రతి సందర్భానికి పర్ఫెక్ట్',
      'weekly_templates': 'వారపు టెంప్లేట్లు',
      'fresh_designs_everyday': 'ప్రతి రోజు కొత్త డిజైన్లు',
      'design_studio': 'డిజైన్ స్టూడియో',
      'reels': 'రీల్స్',
      'amazing_video_editezy': 'Editezy యొక్క అద్భుతమైన వీడియో! చూడండి',
      'share_referral_earn':
          'మీ రిఫరల్ కోడ్‌ను స్నేహితులతో పంచుకుని, వారు అప్‌గ్రేడ్ చేసినప్పుడు బహుమతులు పొందండి',
      'your_referral_code': 'మీ రిఫరల్ కోడ్',
      'how_it_works': 'ఇది ఎలా పనిచేస్తుంది',
      'send_referral_any_platform':
          'ఏ ప్లాట్‌ఫారమ్ ద్వారా అయినా మీ రిఫరల్ కోడ్‌ను స్నేహితులకు పంపండి',
      'share_your_code': 'మీ కోడ్‌ను పంచుకోండి',
      'friend_signs_up': 'స్నేహితుడు సైన్ అప్ చేస్తాడు',
      'enter_code_during_signup':
          'రిజిస్ట్రేషన్ సమయంలో వారు మీ కోడ్‌ను నమోదు చేస్తారు',
      'earn_rewards': 'బహుమతులు పొందండి',
      'get_200_on_upgrade':
          'వారు తమ ఖాతాను అప్‌గ్రేడ్ చేసినప్పుడు ₹200 పొందండి',

      'edit_profile': 'ప్రొఫైల్‌ను సవరించండి',
      'tap_change_photo': 'ఫోటో మార్చడానికి ట్యాప్ చేయండి',
      'personal_information': 'వ్యక్తిగత సమాచారం',
      'marriage_anniversary': 'వివాహ వార్షికోత్సవం',

      'invite_friend': 'స్నేహితుడిని ఆహ్వానించండి',
      'share_code_button': 'షేర్ బటన్ ఉపయోగించి మీ కోడ్‌ను పంచుకోండి.',
      'enter_code_signup_settings':
          'వారు సైన్ అప్ సమయంలో లేదా సెట్టింగ్స్‌లో మీ కోడ్‌ను నమోదు చేస్తారు',
      'both_get_rewards': 'ఇద్దరికీ బహుమతులు లభిస్తాయి',
      'credits_after_purchase':
          'మొదటి విజయవంతమైన కొనుగోలు తర్వాత క్రెడిట్లు జోడించబడతాయి',

      'remove_text_ai':
          'AI ఖచ్చితత్వంతో మీ చిత్రాల నుండి అవసరం లేని టెక్స్ట్‌ను తొలగించండి',
      'select_image': 'చిత్రాన్ని ఎంచుకోండి',

      'about': 'గురించి',
      'text_remover': 'టెక్స్ట్ తొలగింపు',
      'chicha_ai': 'Chicha AI',
      'featured': 'ప్రత్యేకం',

      'about_us': 'మా గురించి',
      'create_stunning': 'సులభంగా అద్భుతమైన పోస్టర్లు & లోగోలు సృష్టించండి',
      'about_editezy': 'Editezy గురించి',
      'about_description':
          'PosterNova అద్భుతమైన పోస్టర్లు, లోగోలు మరియు ప్రమోషనల్ కంటెంట్ రూపొందించడానికి మీ ఆల్-ఇన్-వన్ క్రియేటివ్ స్టూడియో. మీరు వ్యాపార యజమాని, ఇన్‌ఫ్లుయెన్సర్ లేదా డిజైనర్ అయినా, PosterMaker సిద్ధంగా ఉన్న టెంప్లేట్లు మరియు శక్తివంతమైన ఎడిటింగ్ టూల్స్‌తో మీ ఆలోచనలను నిజం చేయడంలో సహాయపడుతుంది.',
      'custom_templates': 'కస్టమ్ టెంప్లేట్లు',
      'choose_thousands':
          'ప్రతి అవసరానికి రూపొందించిన వేలాది టెంప్లేట్లలోంచి ఎంచుకోండి.',
      'easy_sharing': 'సులభమైన షేరింగ్',
      'share_instantly': 'మీ డిజైన్లను వెంటనే సోషల్ మీడియాలో పంచుకోండి.',
      'version_made': 'వెర్షన్ 1.0.0\nEditezy టీమ్ నుండి ❤️తో రూపొందించబడింది',
      'no_image_selected': 'ఏ చిత్రం ఎంపిక చేయబడలేదు',
      'tap_gallery_camera':
          'ప్రారంభించడానికి క్రింద గ్యాలరీ లేదా కెమెరా బటన్‌ను ట్యాప్ చేయండి',
      'poster_making': 'పోస్టర్ తయారీ',
      'add_filter': 'ఫిల్టర్ జోడించండి',
      'add_color': 'రంగు జోడించండి',

      'create_story': 'స్టోరీ సృష్టించండి',
      'new_story': 'కొత్త స్టోరీ',
      'create_your_story': 'మీ స్టోరీ సృష్టించండి',
      'share_story_prompt':
          'మీరు ఏమి చేస్తున్నారో మీ\nస్నేహితులకు తెలియజేయడానికి ఫోటో లేదా వీడియోను పంచుకోండి',
      'add_photo': 'ఫోటో జోడించండి',
      'story_visible_24h':
          'స్టోరీ 24 గంటలు కనిపిస్తుంది మరియు మీ స్నేహితులు దాన్ని చూడగలరు',
      'add_caption': 'క్యాప్షన్ జోడించండి',
      'story_disappear_24h': 'మీ స్టోరీ 24 గంటల తర్వాత మాయమవుతుంది',

      // NEW KEYS
      'categories': 'వర్గాలు',
      'create_template': 'టెంప్లేట్ సృష్టించండి',
      'logo_design': 'లోగో డిజైన్',
      'image_to_video': 'చిత్రాన్ని వీడియోగా మార్చండి',
      'create_poster': 'పోస్టర్ సృష్టించండి',
      'get_invoice': 'ఇన్వాయిస్ పొందండి',
      'no_invoice_yet': 'ఇన్వాయిస్ ఏదీ లేదు',
      'create_first_invoice': 'మీ మొదటి ఇన్వాయిస్ సృష్టించండి!',
      'create_new_invoice': 'కొత్త ఇన్వాయిస్ సృష్టించండి',
      'add_customers': 'గ్రాహులను జోడించండి',
      'no_customers_found': 'గ్రాహకులు కనుగొనబడలేదు',
      'add_first_customer': 'ప్రారంభించేందుకు మీ మొదటి గ్రాహకుడిని జోడించండి',
      'add_new_customer': 'కొత్త గ్రాహకుడిని జోడించండి',
      'chooose_plan': 'మీ ప్లాన్‌ను ఎంచుకోండి',
      'your_story': 'మీ కథ',
      'add_user_data': 'వినియోగదారు డేటాను జోడించండి',
      'business_name': 'బిజినెస్ పేరు',
      'mobile_number': 'మొబైల్ నంబర్',
      'email_id': 'ఈమెయిల్ ID',
      'gst': 'GST',
      'business_type': 'వ్యాపార రకం',
      'home': 'హోమ్',
      'category': 'వర్గం',
      'create': 'సృష్టించండి',
      'invoice': 'ఇన్వాయిస్',
      'add_customer': 'గ్రాహకుడిని జోడించండి',
      'custom_post': 'కస్టమ్ పోస్ట్ సృష్టించండి',
      'square_post': 'చతురస్ర పోస్ట్',
      'story_post': 'స్టోరీ పోస్ట్',
      'cover_picture': 'కవర్ చిత్రం',
      'display_picture': 'ప్రదర్శన చిత్రం',
      'instagram_post': 'ఇన్‌స్టాగ్రామ్ పోస్ట్',
      'youtube_thumbnail': 'యూట్యూబ్ థంబ్‌నెయిల్',
      'a4_size': 'A4 పరిమాణం',
      'certificate': 'సర్టిఫికేట్',
      'poster_maker': 'పోస్టర్ మేకర్',
      'add_image': 'చిత్రాన్ని జోడించండి',
      'logo_maker': 'లోగో మేకర్',
      'create_invoice': 'ఇన్వాయిస్ సృష్టించండి',
      'logo': 'లోగో',
      'choose_logo': 'లోగో ఎంచుకోండి',
      'customer_name': 'గ్రాహకుని పేరు',
      'customer_mobile': 'గ్రాహక మొబైల్',
      'customer_address': 'గ్రాహక చిరునామా',
      'product_name': 'ఉత్పత్తి పేరు',
      'quantity': 'పరిమాణం',
      'description': 'వివరణ',
      'price': 'ధర',
      'offer_price': 'ఆఫర్ ధర',
      'hsn': 'HSN',
      'add_more': 'మరిన్ని జోడించండి',
      'logo_editor': 'లోగో ఎడిటర్',
      'text': 'పాఠ్యం',
      'image': 'చిత్రం',
      'shapes': 'ఆకారాలు',
      'elements': 'అంశాలు',
      'choose_shape': 'ఆకారం ఎంచుకోండి',
      'circle': 'వృత్తం',
      'rectangle': 'చతురస్రం',
      'triangle': 'త్రిభుజం',
      'star': 'నక్షత్రం',
      'choose_element': 'అంశాన్ని ఎంచుకోండి',
      'heart': 'హృదయం',
      'bulb': 'బల్బ్',
      'music': 'సంగీతం',
      'camera': 'కెమెరా',
      'phone': 'ఫోన్',
      'email': 'ఇమెయిల్',
      'location': 'ప్రాంతం',
      'name': 'పేరు',
      'email_optional': 'ఈమెయిల్ (ఐచ్ఛికం)',
      'address': 'చిరునామా',
      'gender': 'లింగం',
      'date_of_birth': 'పుట్టిన తేది',
      'date_of_anniversary': 'వివాహ వార్షికోత్సవ తేది',
      'background': 'నేపథ్యం',
      'profile': 'ప్రొఫైల్',
      'filter': 'ఫిల్టర్',
      'color': 'రంగు',
      'add_text': 'పాఠ్యాన్ని జోడించండి',
      'stickers': 'స్టిక్కర్లు',
      'contact': 'సంప్రదించండి',
      'save': 'సేవ్ చేయండి',

      'customers': 'కస్టమర్లు',
      'no_customers_yet': 'ఇంకా కస్టమర్లు లేరు',
      'add_first_customer_start':
          'ప్రారంభించడానికి మీ మొదటి కస్టమర్‌ను జోడించండి',
      'adjust_search': 'మీ శోధనను మార్చి ప్రయత్నించండి',

      'browse_or_voice_search': 'వర్గాలను చూడండి లేదా వాయిస్‌తో వెతకండి',

      'create_amazing_content': 'అద్భుతమైన కంటెంట్ సృష్టించండి',
      'what_do_you_want_create': 'మీరు ఏమి సృష్టించాలనుకుంటున్నారు?',
      'choose_tool_get_started': 'ప్రారంభించడానికి ఒక టూల్ ఎంచుకోండి',
      'poster_maker_title': 'పోస్టర్ మేకర్',
      'design_beautiful_posters': 'అందమైన పోస్టర్లు డిజైన్ చేయండి',
      'customer_logo': 'కస్టమర్ లోగో',
      'create_logo_customers': 'కస్టమర్ల కోసం లోగో సృష్టించండి',

      //
      'plan_details': 'ప్లాన్ వివరాలు',
      'login_number': 'లాగిన్ నంబర్',
      'current_plan': 'ప్రస్తుత ప్లాన్',
      'media_credits': 'మీడియా క్రెడిట్స్',
      'expires_on': 'గడువు తేదీ',
      'how_to_use': 'వినియోగించే విధానం',
      'change_industry': 'పరిశ్రమ మార్చండి',
      'refer_earn': 'రిఫర్ చేసి సంపాదించండి',
      'settings': 'సెట్టింగ్స్',
      'delete_account': 'ఖాతాను తొలగించు',
      'add_business': 'వ్యాపారాన్ని జోడించండి',
      'contact_us': 'మమ్మల్ని సంప్రదించండి',
      'partner_with_us': 'మాతో భాగస్వామ్యం అవ్వండి',
      'rate_app': 'యాప్‌కి రేటింగ్ ఇవ్వండి',
      'policies': 'పాలసీలు',
      'terms_conditions': 'నిబంధనలు మరియు షరతులు',
      'chat_with_ai': 'AI తో చాట్ చేయండి',
      'logout': 'లాగ్ అవుట్',
      'back': 'వెనుకకు',
      'bday_greetings': 'పుట్టినరోజు శుభాకాంక్షలు',
      'brand_info': 'బ్రాండ్ సమాచారం',
      'remove_background': 'నేపథ్యాన్ని తొలగించండి',
      'caption': 'శీర్షిక',
      'whatsapp_sticker': 'వాట్సాప్ స్టికర్',
      'auto_product_ad': 'ఆటో ఉత్పత్తి ప్రకటన',
      'ask_me_anything': 'ఏదైనా అడగండి',
      'privacy_policy': 'గోప్యతా విధానం',
      'terms_and_conditions': 'నియమాలు మరియు షరతులు',

      'create_business_post': 'బిజినెస్ పోస్ట్ సృష్టించండి',
      'add_business_logo': 'బిజినెస్ లోగోను జోడించండి',
      'owner_name': 'యజమాని పేరు',
      'designation': 'హోదా',
      'phone_number': 'ఫోన్ నంబర్',
      'whatsapp_number': 'వాట్సాప్ నంబర్',
      'email_address': 'ఈమెయిల్ చిరునామా',
      'website': 'వెబ్‌సైట్',
      'gst_number': 'GST నంబర్',
      'add_supporting_image': 'మద్దతిచెప్పే చిత్రం జోడించండి',
      'submit_post': 'పోస్ట్ సమర్పించండి',
      'virtual_business_card': 'వర్చువల్ బిజినెస్ కార్డు',

      'upload_brand_details': 'మీ బ్రాండ్ వివరాలను అప్‌లోడ్ చేయండి',
      'upload_logo': 'లోగోను అప్‌లోడ్ చేయండి',
      'extra_elements': 'అదనపు అంశాలు',

      'select_social_icons':
          'పోస్ట్‌పై హైలైట్ చేయడానికి సామాజిక మాధ్యమ చిహ్నాలను ఎంచుకోండి',

      'how_to_use_title': 'వినియోగించుకునే విధానం',
      'how_to_use_intro':
          '🖼️ పోస్టర్ మేకింగ్ యాప్ – అవలోకనం\n\nఈ యాప్ అంటే ఏమిటి?\n\nపోస్టర్ మేకింగ్ యాప్ అనేది పుట్టినరోజులు, వార్షికోత్సవాలు వంటి ప్రత్యేక సందర్భాలకు వ్యక్తిగత శుభాకాంక్షల పోస్టర్లు సృష్టించేందుకు రూపొందించబడిన సాధారణమైన మరియు శక్తివంతమైన సాధనం. వ్యాపారాలు తమ క్లయింట్లకు శుభాకాంక్షలు పంపడానికైనా లేదా వ్యక్తిగతంగా కుటుంబం, స్నేహితులకు సందేశాలు రూపొందించడానికైనా ఇది ఉపయోగపడుతుంది.',
      'how_to_use_features':
          'ముఖ్యమైన ఫీచర్లు:\n• ✅ కస్టమర్ వివరాలు జోడించండి & నిర్వహించండి\n• 🎂 పుట్టినరోజు మరియు వార్షికోత్సవ టెంప్లేట్లు ఎంచుకోండి\n• ✍️ మీ సందేశాలను ఎడిట్ చేయండి\n• 🖼️ టెంప్లేట్లను తడిపి మార్చండి\n• 💾 SharedPreferences ద్వారా స్థానికంగా సేవ్ చేయండి\n• 📤 కస్టమర్ డేటా ఇంపోర్ట్ (భవిష్యత్ ఫీచర్)',
      'how_to_use_steps':
          '👨‍🏫 యాప్‌ని ఎలా ఉపయోగించాలి:\n\n1. కస్టమర్ వివరాలు జోడించండి\n   పేరు, జన్మదినం లేదా వార్షికోత్సవ తేదీని నమోదు చేయండి\n\n2. టెంప్లేట్‌ను ఎంచుకోండి\n   చిత్రాలతో లేదా లేకుండా టెంప్లేట్లను ఎంచుకోండి\n\n3. మీ సందేశాన్ని ఎడిట్ చేయండి\n   వ్యక్తిగత మెసేజ్ టైప్ చేసి Save చేయండి\n\n4. టెంప్లేట్ మార్చండి\n   కొత్త టెంప్లేట్ బ్రౌజ్ చేసి ఎంచుకోండి\n\n5. ప్రీవ్యూ లేదా షేర్ చేయండి\n   (భవిష్యత్ ఫీచర్): పోస్టర్‌ను డౌన్‌లోడ్ చేయండి లేదా షేర్ చేయండి',
      'how_to_use_stack':
          '🛠️ టెక్నాలజీ స్టాక్:\n• UI కోసం Flutter\n• డేటా నిల్వ కోసం SharedPreferences\n• టెంప్లేట్ల కోసం Image.network\n• స్క్రీన్ మార్పులకు నావిగేషన్ & రూటింగ్',

      'bank_details': 'బ్యాంక్ వివరాలు',
      'add_bank_details': 'మీ బ్యాంక్ వివరాలను జోడించండి',
      'secure_bank_info':
          'లావాదేవీల కోసం మీ బ్యాంక్ సమాచారాన్ని సురక్షితంగా జోడించండి',
      'bank_info': 'బ్యాంక్ సమాచారం',
      'account_holder_name': 'ఖాతాదారు పేరు',
      'bank_name': 'బ్యాంక్ పేరు',
      'account_type': 'ఖాతా రకం',
      'checking': 'చెకింగ్',
      'savings': 'సేవింగ్స్',
      'account_number': 'ఖాతా సంఖ్య',
      'routing_number': 'రౌటింగ్ నంబర్',
      'cancel': 'రద్దు చేయండి',
      'save_details': 'వివరాలు సేవ్ చేయండి',
      'bank_details_saved': 'బ్యాంక్ వివరాలు విజయవంతంగా సేవ్ చేయబడ్డాయి!',

      'happy_birthday': 'పుట్టినరోజు శుభాకాంక్షలు',
      'happy_anniversary': 'వివాహ వార్షికోత్సవ శుభాకాంక్షలు',
      'loading_wishes': 'శుభాకాంక్షలు లోడ్ అవుతున్నాయి...',
      'loading_celebrations': 'వేడుకలు లోడ్ అవుతున్నాయి...',

      'total_earning': 'ఇప్పటివరకు సంపాదించిన మొత్తం',
      'current_balance': 'ప్రస్తుత బ్యాలెన్స్',
      'redeem_now': 'ఇప్పుడు రీడీమ్ చేయండి',
      'refer_earn_big': 'సూచించండి & పెద్దగా సంపాదించండి!',
      'introduce_friend':
          'స్నేహితుడిని పరిచయం చేయండి మరియు వెంటనే 30 క్రెడిట్ పొందండి!',
      'bonus_credit':
          'బోనస్! వారు కొనుగోలు చేసినప్పుడు అదనంగా 50 క్రెడిట్ పొందండి!',
      'earn_now': 'ఇప్పుడు సంపాదించండి',
      'referral_info':
          'మీరు నెలలో 10 మంది స్నేహితులను సూచించడం ద్వారా\nAED 3000 వరకు సంపాదించవచ్చు తెలుసా?\nఇది నెలవారీ సబ్‌స్క్రిప్షన్‌కు సమానం.',

      'bday_anniversary': 'పుట్టినరోజు & వార్షికోత్సవ శుభాకాంక్షలు',
      'add_customer_details': 'గ్రాహక\nవివరాలు జోడించండి',
      'select_birthday_templates': 'పుట్టినరోజు టెంప్లేట్లను ఎంచుకోండి',
      'with_images': 'చిత్రాలతో',
      'without_images': 'చిత్రాలు లేకుండా',
      'birthday_captions': 'పుట్టినరోజు క్యాప్షన్లు',
      'select_anniversary_templates':
          'వివాహ వార్షికోత్సవ టెంప్లేట్లను ఎంచుకోండి',
      'anniversary_captions': 'వివాహ వార్షికోత్సవ క్యాప్షన్లు',
      'change': 'మార్చు',
      'message_with_image': 'ఈ సందేశం మీ చిత్రంతో\nకలిపి పంపబడుతుంది.',

      'Monday': 'సోమవారం',
      'Tuesday': 'మంగళవారం',
      'Wednesday': 'బుధవారం',
      'Thursday': 'గురువారం',
      'Friday': 'శుక్రవారం',
      'Saturday': 'శనివారం',
      'Sunday': 'ఆదివారం',
      'today_prefix': 'ఈ రోజు',

      'birth_date': 'పుట్టిన తేది',
      'anniversary_date': 'వివాహ వార్షికోత్సవ తేది',
      'upload_profile_photo': 'ప్రొఫైల్ ఫోటోను అప్‌లోడ్ చేయండి',
      'submit': 'సమర్పించండి',

      'notifications': 'నోటిఫికేషన్లు',
      'dark_mode': 'డార్క్ మోడ్',

      'contact_us_intro': 'మా నుండి వినడానికి మేము ఉత్సుకతగా ఎదురుచూస్తున్నాం!',
      'contact_us_message':
          'ఏవైనా ప్రశ్నలు లేదా అభిప్రాయాలతో మమ్మల్ని నిశ్చింతగా సంప్రదించండి.',
      'message': 'సందేశం',
      'send_message': 'సందేశం పంపండి',

      'user': 'వినియోగదారు',
      'search_poster_by_topic': 'విషయం ద్వారా పోస్టర్ వెతకండి',
      'username': 'వినియోగదారుని పేరు',
      'share_invite_code': 'ఆహ్వాన కోడ్‌ను షేర్ చేయండి',
      'copy': 'కాపీ చేయండి',
      'select_business_industry': 'మీ వ్యాపార రంగాన్ని ఎంచుకోండి',
      'search_posters': 'పోస్టర్లను వెతకండి',

      'delete_your_account': 'మీ ఖాతాను తొలగించండి',
      'delete_warning':
          'ఈ చర్య శాశ్వతమైనది మరియు తిరగలేని పని. మీ అన్ని డేటా తొలగించబడుతుంది',
      'delete_my_account': 'నా ఖాతాను తొలగించండి',

      'join_content_creator': 'కంటెంట్ క్రియేటర్‌గా మమ్మల్ని చేరండి',
      'join_product_dealer': 'ఉత్పత్తి డీలర్‌గా మమ్మల్ని చేరండి',
    },
    'hi': {
      'app_title': 'पोस्टर मेकर',
      'search_placeholder': 'विषय के द्वारा पोस्टर खोजें',
      'upcoming_festivals': 'आगामी त्योहार',
      'festivals': 'त्योहार',
      'new_poster': 'नया पोस्टर',
      'no_festivals_found': 'कोई त्योहार नहीं मिला',
      'try_different_date': 'अलग तारीख चुनने की कोशिश करें',
      'check_other_dates': 'अन्य तारीखें जांचें',
      'no_new_posters': 'कोई नए पोस्टर उपलब्ध नहीं',
      'view_all': 'सभी देखें',
      'select_language': 'भाषा चुनें',
      'language_switched': 'भाषा सफलतापूर्वक बदल गई!',
      'ugadi': 'उगादी',
      'clothing': 'कपड़े',
      'beauty': 'सुंदरता',
      'chemical': 'रासायनिक',
      'subscription_plans': 'सब्सक्रिप्शन प्लान',
      'choose_plan': 'अपना प्लान चुनें',
      'payment_options': 'भुगतान विकल्प',
      'free': 'मुफ्त',
      'activate_plan': 'प्लान सक्रिय करें',
      'pay_now': 'अभी भुगतान करें',
      'welcome_back': 'वापस स्वागत है!',
      'explore_templates': 'टेम्पलेट्स देखें',
      'choose_canvas_size': 'कैनवास आकार चुनें',
      'select_perfect_size': 'अपने डिज़ाइन के लिए सही आकार चुनें',

      'save_logo': 'लोगो सहेजें',

      'today': 'आज',
      'search_categories': 'श्रेणियाँ खोजें',

      'happy_birthday': 'जन्मदिन मुबारक',
      'happy_anniversary': 'सालगिरह मुबारक',
      'loading_wishes': 'शुभकामनाएं लोड हो रही हैं...',
      'loading_celebrations': 'उत्सव लोड हो रहे हैं...',

      'chat_with_chicha': 'चिचा के साथ चैट करें',
      'start_chat_with_chicha': 'चिचा के साथ चैट शुरू करें',
      'ask_me_anything': 'मुझसे कुछ भी पूछें',
      'poster': 'पोस्टर',

      'business_name': 'व्यवसाय का नाम',

      'total_and_taxes': 'कुल और कर',


      'business_profile': 'व्यवसाय प्रोफ़ाइल',
'add_business_logo': 'व्यवसाय लोगो जोड़ें',
'upload_business_logo': 'अपना व्यवसाय लोगो या ब्रांड छवि अपलोड करें',
'business_details': 'व्यवसाय विवरण',
'business_name': 'व्यवसाय का नाम',
'business_type': 'व्यवसाय का प्रकार',
'contact_information': 'संपर्क जानकारी',
'mobile_number': 'मोबाइल नंबर',
'email_address': 'ईमेल पता',
'gst_number_optional': 'GST नंबर (वैकल्पिक)',
'gst_rate_percent': 'GST दर % (जैसे, 18%)',
'save_profile': 'प्रोफ़ाइल सहेजें',




      'text': 'टेक्स्ट',
      'image': 'छवि',
      'shapes': 'आकृतियाँ',
      'elements': 'तत्व',

      'Monday': 'सोमवार',
      'Tuesday': 'मंगलवार',
      'Wednesday': 'बुधवार',
      'Thursday': 'गुरुवार',
      'Friday': 'शुक्रवार',
      'Saturday': 'शनिवार',
      'Sunday': 'रविवार',
      'today_prefix': 'आज',

      'logo_history': 'लोगो इतिहास',

      'remove_text_ai': 'एडिटेज़ी की सटीकता के साथ अपनी छवियों से अनचाहा टेक्स्ट हटाएँ',



       'user_not_logged_in': 'उपयोगकर्ता लॉग इन नहीं है',
  'panchang_no_data': 'चुनी गई तारीख के लिए कोई डेटा उपलब्ध नहीं है',
  'panchang_load_failed': 'पंचांग डेटा लोड करने में विफल',
  'error_prefix': 'त्रुटि',
  'panchang_loading': 'पंचांग लोड हो रहा है...',  // ← NEW
  'panchang_retry': 'पुनः प्रयास करें',
  'panchang_change_location': 'स्थान बदलें',
  'panchang_location_hint': 'उदा. हैदराबाद, तेलंगाना, भारत',
  'panchang_dob': 'जन्म तिथि',              // ← NEW
  'panchang_vaara': 'वार',
  'panchang_sunrise': 'सूर्योदय',
  'panchang_sunset': 'सूर्यास्त',
  'panchang_moonrise': 'चंद्रोदय',          // ← NEW
  'panchang_moonset': 'चंद्रास्त',           // ← NEW
  'panchang_subtitle': 'वैदिक दैनिक पंचांग', // ← NEW
  'panchang_nakshatra': 'नक्षत्र',
  'panchang_tithi': 'तिथि',
  'panchang_yoga': 'योग',
  'panchang_karana': 'करण',
  'panchang_lord': 'स्वामी',

  'customer_information': 'ग्राहक जानकारी',


      'user_not_logged_in': 'उपयोगकर्ता लॉग इन नहीं है',
      'panchang_no_data': 'चुनी गई तारीख के लिए कोई डेटा उपलब्ध नहीं है',
      'panchang_load_failed': 'पंचांग डेटा लोड करने में विफल',
      'error_prefix': 'त्रुटि',
      'panchang_loading': 'पंचांग लोड हो रहा है...',
      'panchang_retry': 'पुनः प्रयास करें',
      'panchang_change_location': 'स्थान बदलें',
      'panchang_location_hint': 'उदा. हैदराबाद, तेलंगाना, भारत',
      'panchang_dob': 'जन्म तिथि',
      'panchang_vaara': 'वार',
      'panchang_sunrise': 'सूर्योदय',
      'panchang_sunset': 'सूर्यास्त',
      'panchang_nakshatra': 'नक्षत्र',
      'panchang_tithi': 'तिथि',
      'panchang_yoga': 'योग',
      'panchang_karana': 'करण',
      'panchang_lord': 'स्वामी',

      'important_dates': 'महत्वपूर्ण तिथियाँ',

      'delete_confirm_understand':
          'मैं समझता/समझती हूँ कि मेरा खाता हटाना स्थायी है और मेरा सारा डेटा खो जाएगा',

      'text_remover': 'टेक्स्ट हटाने वाला',
      'remove_text_ai': 'AI की सटीकता से अपनी छवियों से अनचाहा टेक्स्ट हटाएं',
      'select_image': 'छवि चुनें',

      'enter_full_name': 'पूरा नाम दर्ज करें',
      'enter_mobile_number': 'मोबाइल नंबर दर्ज करें',
      'enter_email_optional': 'ईमेल पता दर्ज करें (वैकल्पिक)',
      'select_gender': 'लिंग चुनें',
      'select_religion': 'धर्म चुनें',
      'enter_address_optional': 'पता दर्ज करें (वैकल्पिक)',

      'home': 'होम',
      'category': 'श्रेणी',
      'poster': 'पोस्टर',
      'reels': 'रील्स',
      'customer': 'ग्राहक',

      'chat': 'चैट',

      'search_customers': 'ग्राहकों को खोजें',

      'no_celebration_found': 'कोई उत्सव नहीं मिला',
      'try_select_different_date': 'कृपया कोई दूसरी तारीख चुनें',

      'invoices': 'इनवॉइस',
      'no_invoices_yet': 'अभी तक कोई इनवॉइस नहीं',
      'start_creating_invoices': 'पेशेवर इनवॉइस बनाना शुरू करें',
      'all_invoices': 'सभी इनवॉइस',

      'background_remover': 'बैकग्राउंड हटाने वाला',
      'no_image_selected': 'कोई छवि चयनित नहीं',
      'tap_gallery_camera':
          'शुरू करने के लिए नीचे गैलरी या कैमरा बटन पर टैप करें',

      'new_customer': 'नया ग्राहक',
      'fill_customer_details': 'ग्राहक विवरण भरें',
      'basic_information': 'मूल जानकारी',

      'additional_information': 'अतिरिक्त जानकारी',

      'total_customers': 'कुल ग्राहक',

      'select_contact': 'संपर्क चुनें',

      'save_poster': 'पोस्टर सहेजें',
      'share_poster': 'पोस्टर साझा करें',
      'share_to_customers': 'ग्राहकों को साझा करें',

      'update_profile': 'प्रोफ़ाइल अपडेट करें',

      'edit_profile': 'प्रोफ़ाइल संपादित करें',
      'tap_change_photo': 'फोटो बदलने के लिए टैप करें',
      'personal_information': 'व्यक्तिगत जानकारी',
      'marriage_anniversary': 'विवाह वर्षगांठ',
      'poster_making': 'पोस्टर बनाना',
      'add_filter': 'फ़िल्टर जोड़ें',
      'add_color': 'रंग जोड़ें',

      'how_it_works': 'यह कैसे काम करता है',
      'invite_friend': 'दोस्त को आमंत्रित करें',
      'share_code_button': 'शेयर बटन का उपयोग करके अपना कोड साझा करें।',
      'friend_signs_up': 'दोस्त साइन अप करता है',
      'enter_code_signup_settings':
          'वे साइनअप के दौरान या सेटिंग्स में आपका कोड दर्ज करते हैं',
      'both_get_rewards': 'दोनों को इनाम मिलता है',
      'credits_after_purchase':
          'पहली सफल खरीद के बाद क्रेडिट जोड़ दिए जाते हैं',

      'logo_categories': 'लोगो श्रेणियाँ',
      'logo_templates': 'लोगो टेम्पलेट्स',
      'choose_perfect_design': 'अपना परफेक्ट डिज़ाइन चुनें',

      'delete_account': 'खाता हटाएं',
      'sorry_to_see_you_go':
          'आपको जाते हुए देखकर हमें खेद है। कृपया आगे बढ़ने से पहले नीचे दी गई जानकारी देखें।',
      'warning': 'चेतावनी',
      'action_permanent': 'यह कार्रवाई स्थायी है और इसे वापस नहीं लिया जा सकता',
      'before_you_go': 'जाने से पहले',
      'delete_confirm_understand':
          'मैं समझता/समझती हूँ कि मेरा खाता हटाना स्थायी है और मेरा सारा डेटा खो जाएगा',

      'create_story': 'स्टोरी बनाएं',
      'new_story': 'नई स्टोरी',
      'create_your_story': 'अपनी स्टोरी बनाएं',
      'share_story_prompt':
          'फोटो या वीडियो शेयर करें ताकि आपके\nदोस्त जान सकें कि आप क्या कर रहे हैं',
      'add_photo': 'फोटो जोड़ें',
      'story_visible_24h':
          'स्टोरी 24 घंटे तक दिखाई देती है और आपके दोस्त इसे देख सकते हैं',
      'add_caption': 'कैप्शन जोड़ें',
      'story_disappear_24h': 'आपकी स्टोरी 24 घंटे बाद गायब हो जाएगी',

      'about_us': 'हमारे बारे में',
      'create_stunning': 'आसानी से शानदार पोस्टर और लोगो बनाएं',
      'about_editezy': 'Editezy के बारे में',
      'about_description':
          'PosterNova शानदार पोस्टर, लोगो और प्रमोशनल कंटेंट बनाने के लिए आपका ऑल-इन-वन क्रिएटिव स्टूडियो है। चाहे आप बिज़नेस ओनर, इंफ्लुएंसर या डिज़ाइनर हों, PosterMaker तैयार टेम्पलेट्स और शक्तिशाली एडिटिंग टूल्स के साथ आपके आइडियाज़ को हकीकत में बदलने में मदद करता है।',
      'custom_templates': 'कस्टम टेम्पलेट्स',
      'choose_thousands':
          'हर जरूरत के लिए बनाए गए हजारों टेम्पलेट्स में से चुनें।',
      'easy_sharing': 'आसान शेयरिंग',
      'share_instantly': 'अपने डिज़ाइनों को तुरंत सोशल मीडिया पर शेयर करें।',
      'version_made': 'संस्करण 1.0.0\nEditezy टीम द्वारा ❤️ से बनाया गया',

      'about': 'हमारे बारे में',
      'text_remover': 'टेक्स्ट हटाएं',
      'chicha_ai': 'चिचा एआई',
      'featured': 'प्रमुख',

      'online_punchang': 'ऑनलाइन पंचांग',
      'edit_poster': 'पोस्टर संपादित करें',
      'invoices': 'इनवॉइस',
      'background_remover': 'बैकग्राउंड रिमूवर',
      'browse_or_voice_search': 'श्रेणियाँ ब्राउज़ करें या आवाज़ से खोजें',

      'seasonal_celebrations': 'मौसमी उत्सव',
      'never_miss_celebration': 'कोई भी उत्सव न चूकें',
      'celebration_templates': 'उत्सव टेम्पलेट',
      'perfect_every_occasion': 'हर अवसर के लिए परफेक्ट',
      'weekly_templates': 'साप्ताहिक टेम्पलेट',
      'fresh_designs_everyday': 'हर दिन नए डिज़ाइन',
      'design_studio': 'डिज़ाइन स्टूडियो',

      'share_referral_earn':
          'दोस्तों के साथ अपना रेफरल कोड साझा करें और उनके अपग्रेड करने पर इनाम पाएं',
      'your_referral_code': 'आपका रेफरल कोड',
      'how_it_works': 'यह कैसे काम करता है',
      'send_referral_any_platform':
          'किसी भी प्लेटफ़ॉर्म के जरिए अपना रेफरल कोड दोस्तों को भेजें',
      'share_your_code': 'अपना कोड साझा करें',
      'friend_signs_up': 'दोस्त साइन अप करता है',
      'enter_code_during_signup':
          'वे रजिस्ट्रेशन के दौरान आपका कोड दर्ज करते हैं',
      'earn_rewards': 'इनाम पाएं',
      'get_200_on_upgrade': 'उनके अकाउंट अपग्रेड करने पर ₹200 पाएं',

      'customers': 'ग्राहक',
      'no_customers_yet': 'अभी तक कोई ग्राहक नहीं',
      'no_customers_found': 'कोई ग्राहक नहीं मिला',
      'add_first_customer_start': 'शुरू करने के लिए अपना पहला ग्राहक जोड़ें',
      'adjust_search': 'अपनी खोज में बदलाव करके देखें',

      'create_amazing_content': 'शानदार कंटेंट बनाएं',
      'what_do_you_want_create': 'आप क्या बनाना चाहते हैं?',
      'choose_tool_get_started': 'शुरू करने के लिए एक टूल चुनें',
      'poster_maker_title': 'पोस्टर मेकर',
      'design_beautiful_posters': 'सुंदर पोस्टर डिज़ाइन करें',
      'customer_logo': 'ग्राहक लोगो',
      'create_logo_customers': 'ग्राहकों के लिए लोगो बनाएं',

      'reels': 'रील्स',
      'amazing_video_editezy': 'Editezy का शानदार वीडियो! इसे देखें',
      'create_invoice': 'इनवॉइस बनाएं',


      // NEW KEYS
      'categories': 'श्रेणियाँ',
      'create_template': 'टेम्पलेट बनाएँ',
      'logo_design': 'लोगो डिज़ाइन',
      'image_to_video': 'चित्र से वीडियो',
      'create_poster': 'पोस्टर बनाएँ',
      'get_invoice': 'इनवॉइस प्राप्त करें',
      'no_invoice_yet': 'अभी तक कोई इनवॉइस नहीं',
      'create_first_invoice': 'अपना पहला इनवॉइस बनाएं!',
      'create_new_invoice': 'नया इनवॉइस बनाएं',
      'add_customers': 'ग्राहक जोड़ें',
      'add_first_customer': 'शुरू करने के लिए पहला ग्राहक जोड़ें',
      'add_new_customer': 'नया ग्राहक जोड़ें',
      'chooose_plan': 'अपना प्लान चुनें',
      'your_story': 'आपकी कहानी',
      'add_user_data': 'उपयोगकर्ता डेटा जोड़ें',
      'business_name': 'व्यवसाय का नाम',
      'mobile_number': 'मोबाइल नंबर',
      'email_id': 'ईमेल आईडी',
      'gst': 'GST',
      'business_type': 'व्यवसाय का प्रकार',
      'home': 'होम',
      'category': 'श्रेणी',
      'create': 'बनाएं',
      'invoice': 'इनवॉइस',
      'add_customer': 'ग्राहक जोड़ें',
      'custom_post': 'कस्टम पोस्ट बनाएं',
      'square_post': 'वर्ग पोस्ट',
      'story_post': 'स्टोरी पोस्ट',
      'cover_picture': 'कवर चित्र',
      'display_picture': 'प्रदर्शन चित्र',
      'instagram_post': 'इंस्टाग्राम पोस्ट',
      'youtube_thumbnail': 'यूट्यूब थंबनेल',
      'a4_size': 'A4 आकार',
      'certificate': 'प्रमाणपत्र',
      'poster_maker': 'पोस्टर मेकर',
      'add_image': 'छवि जोड़ें',
      'logo_maker': 'लोगो मेकर',
      'create_invoice': 'इनवॉइस बनाएं',
      'logo': 'लोगो',
      'choose_logo': 'लोगो चुनें',
      'customer_name': 'ग्राहक का नाम',
      'customer_mobile': 'ग्राहक मोबाइल',
      'customer_address': 'ग्राहक पता',
      'product_name': 'उत्पाद का नाम',
      'quantity': 'मात्रा',
      'description': 'विवरण',
      'price': 'मूल्य',
      'offer_price': 'ऑफ़र मूल्य',
      'hsn': 'HSN',
      'add_more': 'और जोड़ें',
      'logo_editor': 'लोगो संपादक',
      'text': 'पाठ',
      'image': 'छवि',
      'shapes': 'आकृतियाँ',
      'elements': 'तत्व',
      'choose_shape': 'आकार चुनें',
      'circle': 'वृत्त',
      'rectangle': 'आयत',
      'triangle': 'त्रिभुज',
      'star': 'तारा',
      'choose_element': 'तत्व चुनें',
      'heart': 'दिल',
      'bulb': 'बल्ब',
      'music': 'संगीत',
      'camera': 'कैमरा',
      'phone': 'फ़ोन',
      'email': 'ईमेल',
      'location': 'स्थान',
      'name': 'नाम',
      'email_optional': 'ईमेल (वैकल्पिक)',
      'address': 'पता',
      'gender': 'लिंग',
      'date_of_birth': 'जन्म तिथि',
      'date_of_anniversary': 'विवाह वर्षगांठ की तिथि',
      'background': 'पृष्ठभूमि',
      'profile': 'प्रोफ़ाइल',
      'filter': 'फ़िल्टर',
      'color': 'रंग',
      'add_text': 'टेक्स्ट जोड़ें',
      'stickers': 'स्टिकर',
      'contact': 'संपर्क करें',
      'save': 'सहेजें',

      //
      'plan_details': 'योजना विवरण',
      'login_number': 'लॉगिन नंबर',
      'current_plan': 'वर्तमान योजना',
      'media_credits': 'मीडिया क्रेडिट्स',
      'expires_on': 'समाप्ति तिथि',
      'how_to_use': 'कैसे उपयोग करें',
      'change_industry': 'उद्योग बदलें',
      'refer_earn': 'रेफर करें और कमाएं',
      'settings': 'सेटिंग्स',
      'delete_account': 'खाता हटाएं',
      'add_business': 'व्यवसाय जोड़ें',
      'contact_us': 'संपर्क करें',
      'partner_with_us': 'हमारे साथ साझेदारी करें',
      'rate_app': 'ऐप को रेट करें',
      'policies': 'नीतियाँ',
      'terms_conditions': 'नियम और शर्तें',
      'chat_with_ai': 'AI से बात करें',
      'logout': 'लॉगआउट',
      'back': 'वापस',
      'bday_greetings': 'जन्मदिन की शुभकामनाएँ',
      'brand_info': 'ब्रांड जानकारी',
      'remove_background': 'बैकग्राउंड हटाएं',
      'caption': 'कैप्शन',
      'whatsapp_sticker': 'व्हाट्सएप स्टिकर',
      'auto_product_ad': 'स्वचालित उत्पाद विज्ञापन',
      'ask_me_anything': 'मुझसे कुछ भी पूछें',
      'privacy_policy': 'गोपनीयता नीति',
      'terms_and_conditions': 'नियम और शर्तें',

      'create_business_post': 'व्यवसाय पोस्ट बनाएं',
      'add_business_logo': 'व्यवसाय लोगो जोड़ें',
      'owner_name': 'मालिक का नाम',
      'designation': 'पदनाम',
      'phone_number': 'फोन नंबर',
      'whatsapp_number': 'व्हाट्सएप नंबर',
      'email_address': 'ईमेल पता',
      'website': 'वेबसाइट',
      'gst_number': 'GST नंबर',
      'add_supporting_image': 'सहायक छवि जोड़ें',
      'submit_post': 'पोस्ट सबमिट करें',
      'virtual_business_card': 'वर्चुअल बिजनेस कार्ड',

      'upload_brand_details': 'अपनी ब्रांड जानकारी अपलोड करें',
      'upload_logo': 'लोगो अपलोड करें',
      'extra_elements': 'अतिरिक्त तत्व',

      'select_social_icons': 'पोस्ट पर दिखाने के लिए सोशल मीडिया आइकन चुनें',

      'how_to_use_title': 'कैसे उपयोग करें',
      'how_to_use_intro':
          '🖼️ पोस्टर बनाने वाला ऐप – अवलोकन\n\nयह ऐप क्या है?\n\nपोस्टर मेकर ऐप एक सरल और शक्तिशाली टूल है जो उपयोगकर्ताओं को जन्मदिन और वर्षगांठ जैसे विशेष अवसरों के लिए व्यक्तिगत पोस्टर बनाने में मदद करता है। यह व्यवसायों और व्यक्तिगत उपयोग दोनों के लिए उपयोगी है।',
      'how_to_use_features':
          'मुख्य विशेषताएं:\n• ✅ ग्राहक विवरण जोड़ें और प्रबंधित करें\n• 🎂 जन्मदिन और वर्षगांठ टेम्पलेट्स चुनें\n• ✍️ संदेशों को संपादित करें\n• 🖼️ टेम्पलेट्स को बदलें\n• 💾 SharedPreferences में संदेश सेव करें\n• 📤 ग्राहक डेटा आयात करें (योजना में है)',
      'how_to_use_steps':
          '👨‍🏫 ऐप का उपयोग कैसे करें:\n\n1. ग्राहक विवरण जोड़ें\n   “Add Customer Details” पर टैप करें और नाम, जन्मतिथि या वर्षगांठ दर्ज करें\n\n2. टेम्पलेट चुनें\n   इमेज वाले या बिना इमेज वाले टेम्पलेट्स में से चुनें\n\n3. अपना संदेश संपादित करें\n   कस्टम संदेश टाइप करें और Save दबाएं\n\n4. टेम्पलेट बदलें\n   “Change Template” टैप करें और नया टेम्पलेट चुनें\n\n5. प्रीव्यू या शेयर करें\n   (विकसित की जा रही सुविधा): अंतिम पोस्टर डाउनलोड या शेयर करें',
      'how_to_use_stack':
          '🛠️ तकनीकी स्टैक:\n• UI के लिए Flutter\n• लोकल स्टोरेज के लिए SharedPreferences\n• टेम्पलेट्स लोड करने के लिए Image.network\n• स्क्रीन नेविगेशन के लिए Routing और Navigation',

      'bank_details': 'बैंक विवरण',
      'add_bank_details': 'अपने बैंक विवरण जोड़ें',
      'secure_bank_info':
          'लेनदेन के लिए अपने बैंकिंग जानकारी को सुरक्षित रूप से जोड़ें',
      'bank_info': 'बैंक जानकारी',
      'account_holder_name': 'खाता धारक का नाम',
      'bank_name': 'बैंक का नाम',
      'account_type': 'खाते का प्रकार',
      'checking': 'चेकिंग',
      'savings': 'सेविंग्स',
      'account_number': 'खाता संख्या',
      'routing_number': 'रूटिंग नंबर',
      'cancel': 'रद्द करें',
      'save_details': 'विवरण सहेजें',
      'bank_details_saved': 'बैंक विवरण सफलतापूर्वक सहेजा गया!',

      'describe_poster': 'अपने पोस्टर का वर्णन करें...',

      'total_earning': 'अब तक की कुल कमाई',
      'current_balance': 'वर्तमान बैलेंस',
      'redeem_now': 'अब रिडीम करें',
      'refer_earn_big': 'बड़ी कमाई करें रेफर करके!',
      'introduce_friend': 'एक दोस्त को आमंत्रित करें और तुरंत 30 क्रेडिट पाएं!',
      'bonus_credit': 'बोनस! उनके खरीदारी करने पर अतिरिक्त 50 क्रेडिट पाएं!',
      'earn_now': 'अभी कमाएँ',
      'referral_info':
          'आप 3 दोस्तों को रेफ़र करके वार्षिक सदस्यता कमा सकते हैं',

      'bday_anniversary': 'जन्मदिन और वर्षगांठ शुभकामनाएँ',
      'add_customer_details': 'ग्राहक\nविवरण जोड़ें',
      'select_birthday_templates': 'जन्मदिन टेम्पलेट चुनें',
      'with_images': 'छवियों के साथ',
      'without_images': 'बिना छवियों के',
      'birthday_captions': 'जन्मदिन कैप्शन',
      'select_anniversary_templates': 'वर्षगांठ टेम्पलेट चुनें',
      'anniversary_captions': 'वर्षगांठ कैप्शन',
      'change': 'बदलें',
      'message_with_image': 'यह संदेश आपकी छवि के साथ\nभेजा जाएगा।',
      'product_details': 'उत्पाद विवरण',


      'birth_date': 'जन्म तिथि',
      'anniversary_date': 'विवाह वर्षगांठ की तिथि',
      'upload_profile_photo': 'प्रोफ़ाइल फ़ोटो अपलोड करें',
      'submit': 'जमा करें',

      'notifications': 'सूचनाएं',
      'dark_mode': 'डार्क मोड',

      'contact_us_intro': 'हम आपसे सुनना पसंद करेंगे!',
      'contact_us_message':
          'कृपया कोई भी प्रश्न या प्रतिक्रिया साझा करने में संकोच न करें।',
      'message': 'संदेश',
      'send_message': 'संदेश भेजें',

      'user': 'उपयोगकर्ता',
      'search_poster_by_topic': 'विषय के द्वारा पोस्टर खोजें',
      'username': 'उपयोगकर्ता नाम',

      'share_invite_code': 'आमंत्रण कोड साझा करें',
      'copy': 'कॉपी करें',
      'select_business_industry': 'अपना व्यवसाय उद्योग चुनें',
      'search_posters': 'पोस्टर खोजें',

      'delete_your_account': 'अपना खाता हटाएं',
      'delete_warning':
          'यह क्रिया स्थायी है और पूर्ववत नहीं की जा सकती। आपका सारा डेटा मिटा दिया जाएगा',
      'delete_my_account': 'मेरा खाता हटाएं',

      'join_content_creator': 'एक कंटेंट क्रिएटर के रूप में हमसे जुड़ें',
      'join_product_dealer': 'एक प्रोडक्ट डीलर के रूप में हमसे जुड़ें',
    },
    'ta': {
      'app_title': 'போஸ்டர் மேக்கர்',
      'search_placeholder': 'தலைப்பின் மூலம் போஸ்டரைத் தேடுங்கள்',
      'upcoming_festivals': 'வரவிருக்கும் திருவிழாக்கள்',
      'festivals': 'திருவிழாக்கள்',
      'new_poster': 'புதிய போஸ்டர்',
      'no_festivals_found': 'திருவிழாக்கள் எதுவும் கிடைக்கவில்லை',
      'try_different_date': 'வேறு தேதியைத் தேர்ந்தெடுக்க முயற்சிக்கவும்',
      'check_other_dates': 'மற்ற தேதிகளைச் சரிபார்க்கவும்',
      'no_new_posters': 'புதிய போஸ்டர்கள் எதுவும் கிடைக்கவில்லை',
      'view_all': 'அனைத்தையும் பார்க்கவும்',
      'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'language_switched': 'மொழி வெற்றிகரமாக மாற்றப்பட்டது!',
      'ugadi': 'உகாதி',
      'clothing': 'ஆடைகள்',
      'beauty': 'அழகு',
      'chemical': 'இரசாயன',
      'subscription_plans': 'சந்தா திட்டங்கள்',
      'choose_plan': 'உங்கள் திட்டத்தைத் தேர்ந்தெடுக்கவும்',
      'payment_options': 'கட்டண விருப்பங்கள்',
      'free': 'இலவசம்',
      'activate_plan': 'திட்டத்தை செயல்படுத்தவும்',
      'pay_now': 'இப்போது செலுத்தவும்',
      'welcome_back': 'மீண்டும் வரவேற்கிறோம்!',
      'choose_canvas_size': 'கேன்வாஸ் அளவைத் தேர்வுசெய்க',
      'select_perfect_size':
          'உங்கள் வடிவமைப்புக்கு பொருத்தமான அளவைத் தேர்வுசெய்க',
      'logo_categories': 'லோகோ வகைகள்',
      'logo_templates': 'லோகோ டெம்ப்ளேட்கள்',

      'seasonal_celebrations': 'பருவகால கொண்டாட்டங்கள்',
      'never_miss_celebration': 'எந்த கொண்டாட்டத்தையும் தவறவிடாதீர்கள்',
      'celebration_templates': 'கொண்டாட்ட டெம்ப்ளேட்கள்',
      'perfect_every_occasion': 'ஒவ்வொரு நிகழ்விற்கும் சரியானது',
      'weekly_templates': 'வாரந்தோறும் டெம்ப்ளேட்கள்',
      'fresh_designs_everyday': 'ஒவ்வொரு நாளும் புதிய வடிவமைப்புகள்',

      'explore_templates': 'டெம்ப்ளேட்களை பார்க்கவும்',
      'design_studio': 'டிசைன் ஸ்டூடியோ',

      'today': 'இன்று',

      'important_dates': 'முக்கியமான தேதிகள்',

      'chat_with_chicha': 'சிச்சாவுடன் அரட்டை அடிக்கவும்',
      'start_chat_with_chicha': 'சிச்சாவுடன் அரட்டை தொடங்கவும்',
      'ask_me_anything': 'என்ன வேண்டுமானாலும் கேளுங்கள்',
      'poster': 'போஸ்டர்',

      'no_celebration_found': 'எந்த கொண்டாட்டமும் கிடைக்கவில்லை',
      'try_select_different_date': 'வேறு தேதியைத் தேர்ந்தெடுக்கவும்',

      'save_poster': 'போஸ்டரை சேமிக்கவும்',
      'share_poster': 'போஸ்டரை பகிரவும்',
      'share_to_customers': 'வாடிக்கையாளர்களுடன் பகிரவும்',

      'enter_full_name': 'முழு பெயரை உள்ளிடவும்',
      'enter_mobile_number': 'மொபைல் எண்ணை உள்ளிடவும்',
      'enter_email_optional': 'மின்னஞ்சல் முகவரியை உள்ளிடவும் (விருப்பம்)',
      'select_gender': 'பாலினத்தைத் தேர்வுசெய்க',
      'select_religion': 'மதத்தைத் தேர்வுசெய்க',
      'enter_address_optional': 'முகவரியை உள்ளிடவும் (விருப்பம்)',

      'Monday': 'திங்கள்',
      'Tuesday': 'செவ்வாய்',
      'Wednesday': 'புதன்',
      'Thursday': 'வியாழன்',
      'Friday': 'வெள்ளி',
      'Saturday': 'சனி',
      'Sunday': 'ஞாயிறு',
      'today_prefix': 'இன்று',

      'home': 'முகப்பு',
      'category': 'வகை',
      'poster': 'போஸ்டர்',
      'reels': 'ரீல்ஸ்',
      'customer': 'வாடிக்கையாளர்',

      'save_logo': 'லோகோவை சேமிக்கவும்',

      'happy_birthday': 'பிறந்தநாள் வாழ்த்துக்கள்',
      'happy_anniversary': 'திருமண நாள் வாழ்த்துக்கள்',
      'loading_wishes': 'வாழ்த்துக்கள் ஏற்றப்படுகின்றன...',
      'loading_celebrations': 'கொண்டாட்டங்கள் ஏற்றப்படுகின்றன...',

      'invoices': 'விலைப்பட்டியல்கள்',
      'no_invoices_yet': 'இன்னும் விலைப்பட்டியல்கள் இல்லை',
      'start_creating_invoices':
          'தொழில்முறை விலைப்பட்டியல்கள் உருவாக்கத் தொடங்குங்கள்',
      'all_invoices': 'அனைத்து விலைப்பட்டியல்கள்',

      'customers': 'வாடிக்கையாளர்கள்',
      'no_customers_yet': 'இன்னும் வாடிக்கையாளர்கள் இல்லை',
      'no_customers_found': 'வாடிக்கையாளர்கள் எவரும் கிடைக்கவில்லை',
      'add_first_customer_start':
          'தொடங்க உங்கள் முதல் வாடிக்கையாளரை சேர்க்கவும்',
      'adjust_search': 'உங்கள் தேடலை மாற்றி முயற்சிக்கவும்',

      'new_customer': 'புதிய வாடிக்கையாளர்',
      'fill_customer_details': 'வாடிக்கையாளர் விவரங்களை நிரப்பவும்',
      'basic_information': 'அடிப்படை தகவல்',

      'share_referral_earn':
          'உங்கள் பரிந்துரை குறியீட்டை நண்பர்களுடன் பகிர்ந்து, அவர்கள் மேம்படுத்தும் போது பரிசுகளை பெறுங்கள்',
      'your_referral_code': 'உங்கள் பரிந்துரை குறியீடு',
      'how_it_works': 'இது எப்படி செயல்படுகிறது',
      'send_referral_any_platform':
          'எந்த தளத்தின் மூலமாகவும் உங்கள் பரிந்துரை குறியீட்டை நண்பர்களுக்கு அனுப்புங்கள்',
      'share_your_code': 'உங்கள் குறியீட்டை பகிருங்கள்',
      'friend_signs_up': 'நண்பர் பதிவு செய்கிறார்',
      'enter_code_during_signup':
          'பதிவு செய்யும் போது அவர்கள் உங்கள் குறியீட்டை உள்ளிடுகிறார்கள்',
      'earn_rewards': 'பரிசுகளைப் பெறுங்கள்',
      'get_200_on_upgrade': 'அவர்கள் கணக்கை மேம்படுத்தும் போது ₹200 பெறுங்கள்',
      'featured': 'சிறப்பு',
      'additional_information': 'கூடுதல் தகவல்',

      'chat': 'அரட்டை',

      'text': 'உரை',
      'image': 'படம்',
      'shapes': 'வடிவங்கள்',
      'elements': 'உறுப்புகள்',

      'update_profile': 'சுயவிவரத்தை புதுப்பிக்கவும்',

      'background_remover': 'பின்னணி நீக்கி',
      'no_image_selected': 'எந்த படமும் தேர்வு செய்யப்படவில்லை',
      'tap_gallery_camera':
          'தொடங்க கீழே உள்ள கேலரி அல்லது கேமரா பொத்தானை தட்டவும்',

      'about_us': 'எங்களை பற்றி',
      'create_stunning': 'எளிதாக அழகான போஸ்டர்கள் & லோகோக்களை உருவாக்குங்கள்',
      'about_editezy': 'Editezy பற்றி',
      'about_description':
          'PosterNova அழகான போஸ்டர்கள், லோகோக்கள் மற்றும் விளம்பர உள்ளடக்கங்களை வடிவமைக்க உங்கள் அனைத்தும்-ஒரே-இடத்தில் கிடைக்கும் கிரியேட்டிவ் ஸ்டூடியோ. நீங்கள் வணிக உரிமையாளர், இன்ஃப்ளூயன்சர் அல்லது டிசைனர் எவராக இருந்தாலும், PosterMaker தயார் டெம்ப்ளேட்கள் மற்றும் சக்திவாய்ந்த எடிட்டிங் கருவிகளால் உங்கள் யோசனைகளை நனவாக்க உதவுகிறது.',
      'custom_templates': 'தனிப்பயன் டெம்ப்ளேட்கள்',
      'choose_thousands':
          'ஒவ்வொரு தேவைக்கும் வடிவமைக்கப்பட்ட ஆயிரக்கணக்கான டெம்ப்ளேட்களில் இருந்து தேர்வு செய்யுங்கள்.',
      'easy_sharing': 'எளிய பகிர்வு',
      'share_instantly':
          'உங்கள் வடிவமைப்புகளை உடனே சமூக ஊடகங்களில் பகிருங்கள்.',
      'version_made':
          'பதிப்பு 1.0.0\nEditezy குழுவினரால் ❤️ உடன் உருவாக்கப்பட்டது',
      'edit_profile': 'சுயவிவரத்தைத் திருத்தவும்',
      'tap_change_photo': 'புகைப்படத்தை மாற்ற தட்டவும்',
      'personal_information': 'தனிப்பட்ட தகவல்',
      'marriage_anniversary': 'திருமண ஆண்டு விழா',
      'poster_making': 'போஸ்டர் உருவாக்கம்',
      'add_filter': 'வடிகட்டி சேர்க்கவும்',
      'add_color': 'நிறம் சேர்க்கவும்',

      'search_customers': 'வாடிக்கையாளர்களை தேடுங்கள்',

      'select_contact': 'தொடர்பைத் தேர்ந்தெடுக்கவும்',

      'text_remover': 'உரை நீக்கி',
      'remove_text_ai':
          'AI துல்லியத்துடன் உங்கள் படங்களில் இருந்து தேவையற்ற உரையை நீக்குங்கள்',
      'select_image': 'படத்தைத் தேர்ந்தெடுக்கவும்',

      'invite_friend': 'நண்பரை அழைக்கவும்',
      'share_code_button':
          'பகிர்வு பொத்தானைப் பயன்படுத்தி உங்கள் குறியீட்டை பகிருங்கள்.',
      'enter_code_signup_settings':
          'அவர்கள் பதிவு செய்யும் போது அல்லது அமைப்புகளில் உங்கள் குறியீட்டை உள்ளிடுகிறார்கள்',
      'both_get_rewards': 'இருவரும் பரிசுகளைப் பெறுவர்',
      'credits_after_purchase':
          'முதல் வெற்றிகரமான கொள்முதல் பிறகு கிரெடிட்கள் சேர்க்கப்படும்',

      'create_story': 'ஸ்டோரி உருவாக்கவும்',
      'new_story': 'புதிய ஸ்டோரி',
      'create_your_story': 'உங்கள் ஸ்டோரியை உருவாக்கவும்',
      'share_story_prompt':
          'நீங்கள் என்ன செய்கிறீர்கள் என்பதை உங்கள்\nநண்பர்கள் அறிய புகைப்படம் அல்லது வீடியோவை பகிருங்கள்',
      'add_photo': 'புகைப்படம் சேர்க்கவும்',
      'story_visible_24h':
          'ஸ்டோரி 24 மணி நேரம் தெரியும் மற்றும் உங்கள் நண்பர்கள் பார்க்கலாம்',
      'add_caption': 'விளக்கத்தைச் சேர்க்கவும்',
      'story_disappear_24h': 'உங்கள் ஸ்டோரி 24 மணி நேரத்திற்கு பிறகு மறையும்',
      'choose_perfect_design':
          'உங்களுக்கு பொருத்தமான வடிவமைப்பைத் தேர்ந்தெடுக்கவும்',
      'total_customers': 'மொத்த வாடிக்கையாளர்கள்',

      // NEW KEYS
      'categories': 'வகைகள்',
      'create_template': 'டெம்ப்ளேட்டை உருவாக்கவும்',
      'logo_design': 'லோகோ வடிவமைப்பு',
      'image_to_video': 'படத்தை வீடியோவாக்கு',
      'create_poster': 'போஸ்டரை உருவாக்குங்கள்',
      'get_invoice': 'விலைப்பட்டியலைப் பெறுங்கள்',
      'no_invoice_yet': 'இன்னும் விலைப்பட்டியல் இல்லை',
      'create_first_invoice': 'உங்கள் முதல் விலைப்பட்டியலை உருவாக்குங்கள்!',
      'create_new_invoice': 'புதிய விலைப்பட்டியல் உருவாக்குங்கள்',
      'add_customers': 'வாடிக்கையாளர்களைச் சேர்க்கவும்',
      'add_first_customer': 'தொடங்க உங்கள் முதல் வாடிக்கையாளரைச் சேர்க்கவும்',
      'add_new_customer': 'புதிய வாடிக்கையாளரைச் சேர்க்கவும்',
      'chooose_plan': 'உங்கள் திட்டத்தைத் தேர்ந்தெடுக்கவும்',
      'your_story': 'உங்கள் கதை',
      'add_user_data': 'பயனர் தரவுகளைச் சேர்க்கவும்',
      'business_name': 'வணிகப் பெயர்',
      'mobile_number': 'மொபைல் எண்',
      'email_id': 'மின்னஞ்சல் ஐடி',
      'gst': 'GST',
      'business_type': 'வணிக வகை',
      'home': 'முகப்பு',
      'category': 'வகை',
      'create': 'உருவாக்கு',
      'invoice': 'விலைப்பட்டியல்',
      'add_customer': 'வாடிக்கையாளரைச் சேர்க்கவும்',
      'custom_post': 'தனிப்பயன் பதிவு உருவாக்கவும்',
      'square_post': 'சதுரப் பதிவு',
      'story_post': 'கதைப்பட பதிவு',
      'cover_picture': 'கவர் படம்',
      'display_picture': 'காட்சி படம்',
      'instagram_post': 'இன்ஸ்டாகிராம் பதிவு',
      'youtube_thumbnail': 'யூடியூப் சிறுபடம்',
      'a4_size': 'A4 அளவு',
      'certificate': 'சான்றிதழ்',
      'poster_maker': 'போஸ்டர் மேக்கர்',
      'add_image': 'படத்தைச் சேர்க்கவும்',
      'logo_maker': 'லோகோ மேக்கர்',
      'create_invoice': 'விலைப்பட்டியல் உருவாக்கவும்',
      'logo': 'லோகோ',
      'choose_logo': 'லோகோவைத் தேர்வுசெய்க',
      'customer_name': 'வாடிக்கையாளர் பெயர்',
      'customer_mobile': 'வாடிக்கையாளர் கைபேசி',
      'customer_address': 'வாடிக்கையாளர் முகவரி',
      'product_name': 'தயாரிப்பு பெயர்',
      'quantity': 'அளவு',
      'description': 'விவரம்',
      'price': 'விலை',
      'offer_price': 'சலுகை விலை',
      'hsn': 'HSN',
      'add_more': 'மேலும் சேர்க்கவும்',
      'logo_editor': 'லோகோ எடிட்டர்',
      'text': 'உரைத்தொகை',
      'image': 'படம்',
      'shapes': 'வடிவங்கள்',
      'elements': 'உறுப்புகள்',
      'choose_shape': 'வடிவத்தைத் தேர்ந்தெடுக்கவும்',
      'circle': 'வட்டம்',
      'rectangle': 'செவ்வகம்',
      'triangle': 'முக்கோணம்',
      'star': 'நட்சத்திரம்',
      'choose_element': 'உறுப்பைத் தேர்ந்தெடுக்கவும்',
      'heart': 'இதயம்',
      'bulb': 'பல்பு',
      'music': 'இசை',
      'camera': 'கேமரா',
      'phone': 'தொலைபேசி',
      'email': 'மின்னஞ்சல்',
      'location': 'இருப்பிடம்',
      'name': 'பெயர்',
      'email_optional': 'மின்னஞ்சல் (விருப்பத்தேர்வு)',
      'address': 'முகவரி',
      'gender': 'பாலினம்',
      'date_of_birth': 'பிறந்த தேதி',
      'date_of_anniversary': 'திருமண ஆண்டு தேதி',
      'edit_poster': 'போஸ்டரைத் திருத்தவும்',
      'background': 'பின்னணி',
      'profile': 'சுயவிவரம்',
      'filter': 'வடிகட்டி',
      'color': 'நிறம்',
      'add_text': 'உரையைச் சேர்க்கவும்',
      'stickers': 'ஸ்டிக்கர்கள்',
      'contact': 'தொடர்புக்கு',
      'save': 'சேமிக்கவும்',
      'browse_or_voice_search': 'வகைகளை பார்க்கவும் அல்லது குரல் மூலம் தேடவும்',
      'reels': 'ரீல்ஸ்',
      'amazing_video_editezy': 'Editezy வழங்கும் அற்புதமான வீடியோ! பாருங்கள்',

      'online_punchang': 'ஆன்லைன் பஞ்சாங்கம்',
      'invoices': 'விலைப்பட்டியல்கள்',
      'background_remover': 'பின்னணி நீக்கி',

      'create_amazing_content': 'அற்புதமான உள்ளடக்கத்தை உருவாக்குங்கள்',
      'what_do_you_want_create': 'நீங்கள் என்ன உருவாக்க விரும்புகிறீர்கள்?',
      'choose_tool_get_started': 'தொடங்க ஒரு கருவியைத் தேர்ந்தெடுக்கவும்',
      'poster_maker_title': 'போஸ்டர் மேக்கர்',
      'design_beautiful_posters': 'அழகான போஸ்டர்களை வடிவமைக்கவும்',
      'customer_logo': 'வாடிக்கையாளர் லோகோ',
      'create_logo_customers': 'வாடிக்கையாளர்களுக்கான லோகோ உருவாக்கவும்',
      'about': 'பற்றி',
      'text_remover': 'உரை நீக்கி',
      'chicha_ai': 'Chicha AI',

      'delete_account': 'கணக்கை நீக்கவும்',
      'sorry_to_see_you_go':
          'நீங்கள் விலகுவது எங்களுக்கு வருத்தமாக உள்ளது. தொடர்வதற்கு முன் கீழே உள்ள தகவலைப் பாருங்கள்.',
      'warning': 'எச்சரிக்கை',
      'action_permanent': 'இந்த செயல் நிரந்தரமானது மற்றும் மாற்ற முடியாது',
      'before_you_go': 'நீங்கள் செல்லும் முன்',
      'delete_confirm_understand':
          'என் கணக்கை நீக்குவது நிரந்தரமானது மற்றும் என் அனைத்து தரவும் இழக்கப்படும் என்பதை நான் புரிந்துகொள்கிறேன்',

      //new
      'plan_details': 'திட்ட விவரங்கள்',
      'login_number': 'உள்நுழைவு எண்',
      'current_plan': 'தற்போதைய திட்டம்',
      'media_credits': 'மீடியா கிரெடிட்ஸ்',
      'expires_on': 'காலாவதி தேதி',
      'how_to_use': 'பயன்படுத்தும் முறை',
      'change_industry': 'தொழிலை மாற்றவும்',
      'refer_earn': 'பரிந்துரை செய்து சம்பாதிக்கவும்',
      'settings': 'அமைப்புகள்',
      'delete_account': 'கணக்கை நீக்கவும்',
      'add_business': 'வணிகத்தைச் சேர்க்கவும்',
      'contact_us': 'எங்களை தொடர்புகொள்ளுங்கள்',
      'partner_with_us': 'எங்களுடன் கூட்டிணையுங்கள்',
      'rate_app': 'அப்பை மதிப்பீடு செய்யவும்',
      'policies': 'கொள்கைகள்',
      'terms_conditions': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
      'chat_with_ai': 'AI உடன் உரையாடவும்',
      'logout': 'வெளியேறு',
      'back': 'மீண்டும்',
      'bday_greetings': 'பிறந்தநாள் வாழ்த்துகள்',
      'brand_info': 'பிராண்ட் தகவல்',
      'remove_background': 'பின்னணியை அகற்றவும்',
      'caption': 'பொருள் விளக்கம்',
      'whatsapp_sticker': 'வாட்ஸ்அப் ஸ்டிக்கர்',
      'auto_product_ad': 'தானியங்கு தயாரிப்பு விளம்பரம்',
      'ask_me_anything': 'என்னையென்று ஏதும் கேளுங்கள்',
      'privacy_policy': 'தனியுரிமைக் கொள்கை',
      'terms_and_conditions': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',

      'create_business_post': 'வணிகப் பதிவை உருவாக்கவும்',
      'add_business_logo': 'வணிக லோகோவைச் சேர்க்கவும்',

      'owner_name': 'உரிமையாளர் பெயர்',
      'designation': 'பதவி',
      'phone_number': 'தொலைபேசி எண்',
      'whatsapp_number': 'வாட்ஸ்அப் எண்',
      'email_address': 'மின்னஞ்சல் முகவரி',
      'website': 'இணையதளம்',

      'gst_number': 'GST எண்',
      'add_supporting_image': 'ஆதரவளிக்கும் படத்தைச் சேர்க்கவும்',
      'submit_post': 'பதிவைச் சமர்ப்பிக்கவும்',
      'virtual_business_card': 'மெய்நிகர் வணிக அட்டை',

      'upload_brand_details': 'உங்கள் பிராண்ட் விவரங்களை பதிவேற்றவும்',
      'upload_logo': 'லோகோவை பதிவேற்றவும்',
      'extra_elements': 'கூடுதல் கூறுகள்',

      'select_social_icons':
          'போஸ்டில் தெறிவிக்க சமூக ஊடக ஐகான்களைத் தேர்வுசெய்க',
      'how_to_use_title': 'எப்படி பயன்படுத்துவது',
      'how_to_use_intro':
          '🖼️ போஸ்டர் உருவாக்கும் பயன்பாடு – மேலோட்டம்\n\nஇந்த பயன்பாடு என்றால் என்ன?\n\nபோஸ்டர் மேக்கர் ஒரு எளிமையான மற்றும் சக்திவாய்ந்த கருவி. இது பிறந்தநாள் மற்றும் திருமண நாளுக்கு தனிப்பயனாக்கப்பட்ட வாழ்த்து போஸ்டர்களை உருவாக்க உதவுகிறது. வணிகங்களும், தனிப்பட்ட நபர்களும் விரைவாக உருவாக்கலாம்.',
      'how_to_use_features':
          'முக்கிய அம்சங்கள்:\n• ✅ வாடிக்கையாளர் விவரங்களைச் சேர் மற்றும் நிர்வகி\n• 🎂 பிறந்த நாள் மற்றும் திருமண நாள் டெம்ப்ளேட்களைத் தேர்ந்தெடுக்கவும்\n• ✍️ உங்கள் செய்திகளைத் திருத்தவும்\n• 🖼️ டெம்ப்ளேட்களை மாற்ற சுலபமான தொடுதல்\n• 💾 SharedPreferences-ஐ பயன்படுத்தி சேமி\n• 📤 வாடிக்கையாளர் தரவை இறக்குமதி செய்யவும் (விரைவில்)',
      'how_to_use_steps':
          '👨‍🏫 பயன்பாட்டைப் பயன்படுத்தும் முறை:\n\n1. வாடிக்கையாளர் விவரங்களைச் சேர்\n   “Add Customer Details” ஐத் தட்டவும் மற்றும் பெயர், பிறந்த நாள் அல்லது திருமண நாளை உள்ளிடவும்\n\n2. டெம்ப்ளேட் தேர்ந்தெடுக்கவும்\n   படம் உள்ளதும் இல்லாததும் தேர்வு செய்யவும்\n\n3. உங்கள் செய்தியைத் திருத்தவும்\n   உங்கள் செய்தியை உள்ளிட்டு Save செய்யவும்\n\n4. டெம்ப்ளேட்டை மாற்றவும்\n   “Change Template” ஐத் தட்டவும் மற்றும் புதியதை தேர்வுசெய்யவும்\n\n5. முன்னோட்டம் காண்க அல்லது பகிரவும்\n   (விரைவில் வரவிருக்கும் அம்சம்): இறுதிப் போஸ்டரை பதிவிறக்கவும் அல்லது பகிரவும்',
      'how_to_use_stack':
          '🛠️ தொழில்நுட்பங்கள்:\n• UIக்காக Flutter\n• SharedPreferences மூலம் சேமிக்கவும்\n• Image.network மூலம் படங்களை ஏற்றவும்\n• திரை மாற்றத்திற்கான Navigation & Routing',

      'bank_details': 'வங்கி விவரங்கள்',
      'add_bank_details': 'உங்கள் வங்கி விவரங்களைச் சேர்க்கவும்',
      'secure_bank_info':
          'பரிவர்த்தனைகளுக்கான வங்கி தகவலை பாதுகாப்பாக சேர்க்கவும்',
      'bank_info': 'வங்கி தகவல்',
      'account_holder_name': 'கணக்கு வைத்திருப்பவர் பெயர்',
      'bank_name': 'வங்கி பெயர்',
      'account_type': 'கணக்கு வகை',
      'checking': 'செக்கிங்',
      'savings': 'சேமிப்பு',
      'account_number': 'கணக்கு எண்',
      'routing_number': 'ரவுடிங் எண்',
      'cancel': 'ரத்துசெய்',
      'save_details': 'விவரங்களை சேமிக்கவும்',
      'bank_details_saved': 'வங்கி விவரங்கள் வெற்றிகரமாக சேமிக்கப்பட்டன!',

      'total_earning': 'இதுவரை கிடைத்த மொத்த வருமானம்',
      'current_balance': 'தற்போதைய இருப்பு',
      'redeem_now': 'இப்போதே பரிசளிக்கவும்',
      'refer_earn_big': 'பெரிய அளவில் பரிந்துரை செய்து சம்பாதிக்கவும்!',
      'introduce_friend':
          'நண்பரை அறிமுகப்படுத்துங்கள் மற்றும் உடனடியாக 30 கிரெடிட் பெறுங்கள்!',
      'bonus_credit':
          'போனஸ்! அவர்கள் வாங்கும் போது மேலும் 50 கிரெடிட் பெறுங்கள்!',
      'earn_now': 'இப்போதே சம்பாதிக்கவும்',
      'referral_info':
          'ஒரே மாதத்தில் 10 நண்பர்களை பரிந்துரை செய்து நீங்கள்\nAED 3000 வரை சம்பாதிக்கலாம் என்பதைத் தெரியுமா?\nஇது ஒரு மாத சந்தாவிற்குச் சமம்.',

      'bday_anniversary': 'பிறந்தநாள் & ஆண்டு விழா வாழ்த்துக்கள்',
      'add_customer_details': 'வாடிக்கையாளர்\nவிவரங்களைச் சேர்க்கவும்',
      'select_birthday_templates': 'பிறந்தநாள் டெம்ப்ளேட்டுகளைத் தேர்வுசெய்க',
      'with_images': 'படங்களுடன்',
      'without_images': 'படங்கள் இல்லாமல்',
      'birthday_captions': 'பிறந்தநாள் தலைப்புகள்',
      'select_anniversary_templates':
          'திருமண ஆண்டு டெம்ப்ளேட்டுகளைத் தேர்வுசெய்க',
      'anniversary_captions': 'திருமண ஆண்டு தலைப்புகள்',
      'change': 'மாற்றவும்',
      'message_with_image': 'இந்த செய்தி உங்கள் படத்துடன்\nஅனுப்பப்படும்.',

      'birth_date': 'பிறந்த தேதி',
      'anniversary_date': 'திருமண நாள்',
      'upload_profile_photo': 'சுயவிவர புகைப்படத்தை பதிவேற்றவும்',
      'submit': 'சமர்ப்பிக்கவும்',

      'notifications': 'அறிவிப்புகள்',
      'dark_mode': 'இருள் பயன்முறை',

      'contact_us_intro':
          'உங்களிடம் இருந்து கேட்பதற்காக நாங்கள் உற்சாகமாக இருக்கிறோம்!',
      'contact_us_message':
          'ஏதேனும் கேள்விகள் அல்லது கருத்துகள் இருந்தால் தயங்காமல் தொடர்புகொள்ளுங்கள்.',
      'message': 'செய்தி',
      'send_message': 'செய்தியை அனுப்பவும்',

      'user': 'பயனர்',
      'search_poster_by_topic': 'தலைப்பின் மூலம் போஸ்டரைத் தேடுங்கள்',
      'username': 'பயனர் பெயர்',
      'share_invite_code': 'அழைப்புக் குறியீட்டைப் பகிரவும்',
      'copy': 'நகலெடுக்கவும்',
      'select_business_industry': 'உங்கள் வணிகத் துறையைத் தேர்வுசெய்க',
      'search_posters': 'போஸ்டர்களைத் தேடுங்கள்',

      'delete_your_account': 'உங்கள் கணக்கை நீக்கவும்',
      'delete_warning':
          'இந்த செயல் நிரந்தரமானது மற்றும் ரத்து செய்ய முடியாதது. உங்கள் அனைத்து தரவுகளும் அழிக்கப்படும்',
      'delete_my_account': 'என் கணக்கை நீக்கு',

      'join_content_creator': 'உள்ளடக்க உருவாக்குபவராக எங்களைச் சேருங்கள்',
      'join_product_dealer': 'தயாரிப்பு வியாபாரியாக எங்களைச் சேருங்கள்',
    },
  };

  static String translate(String key, String languageCode) {
    return _localizedStrings[languageCode]?[key] ??
        _localizedStrings['en']?[key] ??
        key;
  }
}

// 3. Create a translation helper widget (widgets/app_text.dart)

class AppText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.textKey, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  static String translate(BuildContext context, String key) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    return LocalizationService.translate(
      key,
      languageProvider.locale.languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final translatedText = LocalizationService.translate(
      textKey,
      languageProvider.locale.languageCode,
    );

    return Text(
      translatedText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
