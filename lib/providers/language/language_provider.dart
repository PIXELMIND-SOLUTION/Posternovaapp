// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class LanguageProvider extends ChangeNotifier {
// //   Locale _locale = const Locale('en');

// //   Locale get locale => _locale;

// //   LanguageProvider() {
// //     _loadLanguagePreference();
// //   }

// //   // Load saved language from SharedPreferences
// //   Future<void> _loadLanguagePreference() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final String languageCode = prefs.getString('language_code') ?? 'en';

// //     _locale = Locale(languageCode);
// //     notifyListeners();
// //   }

// //   // Change and save the language
// //   Future<void> setLanguage(String languageCode) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('language_code', languageCode);

// //     _locale = Locale(languageCode);
// //     notifyListeners();
// //   }
// // }

// // lib/providers/language_provider.dart
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class LanguageProvider extends ChangeNotifier {
// //   Locale _locale = const Locale('en');

// //   Locale get locale => _locale;

// //   LanguageProvider() {
// //     _loadSavedLanguage();
// //   }

// //   Future<void> _loadSavedLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final String languageCode = prefs.getString('language_code') ?? 'en';

// //     setLocale(Locale(languageCode));
// //   }

// //   Future<void> setLocale(Locale newLocale) async {
// //     if (_locale == newLocale) return;

// //     _locale = newLocale;

// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('language_code', newLocale.languageCode);

// //     notifyListeners();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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

// // 2. Create a localization service (services/localization_service.dart)
// // class LocalizationService {
// //   static final Map<String, Map<String, String>> _localizedStrings = {
// //     'en': {
// //       'app_title': 'Poster Maker',
// //       'search_placeholder': 'Search Poster by Topic',
// //       'upcoming_festivals': 'Upcoming Festivals',
// //       'festivals': 'Festivals',
// //       'new_poster': 'New Poster',
// //       'no_festivals_found': 'No Festivals Found',
// //       'try_different_date': 'Try selecting a different date',
// //       'check_other_dates': 'Check Other Dates',
// //       'no_new_posters': 'No New posters available',
// //       'view_all': 'View All',
// //       'select_language': 'Select Language',
// //       'language_switched': 'Language switched successfully!',
// //       'ugadi': 'Ugadi',
// //       'clothing': 'Clothing',
// //       'beauty': 'Beauty',
// //       'chemical': 'Chemical',
// //       'subscription_plans': 'Subscription Plans',
// //       'choose_plan': 'Choose Your Plan',
// //       'payment_options': 'Payment Options',
// //       'free': 'Free',
// //       'activate_plan': 'ACTIVATE PLAN',
// //       'pay_now': 'PAY NOW',
// //     },
// //     'te': {
// //       'app_title': 'పోస్టర్ మేకర్',
// //       'search_placeholder': 'విషయం ద్వారా పోస్టర్ వెతకండి',
// //       'upcoming_festivals': 'రాబోయే పండుగలు',
// //       'festivals': 'పండుగలు',
// //       'new_poster': 'కొత్త పోస్టర్',
// //       'no_festivals_found': 'పండుగలు కనుగొనబడలేదు',
// //       'try_different_date': 'వేరే తేదీని ఎంచుకోవడానికి ప్రయత్నించండి',
// //       'check_other_dates': 'ఇతర తేదీలను తనిఖీ చేయండి',
// //       'no_new_posters': 'కొత్త పోస్టర్లు అందుబాటులో లేవు',
// //       'view_all': 'అన్నీ చూడండి',
// //       'select_language': 'భాషను ఎంచుకోండి',
// //       'language_switched': 'భాష విజయవంతంగా మార్చబడింది!',
// //       'ugadi': 'ఉగాది',
// //       'clothing': 'వస్త్రాలు',
// //       'beauty': 'అందం',
// //       'chemical': 'రసాయనిక',
// //       'subscription_plans': 'సబ్‌స్క్రిప్షన్ ప్లాన్‌లు',
// //       'choose_plan': 'మీ ప్లాన్‌ను ఎంచుకోండి',
// //       'payment_options': 'చెల్లింపు ఎంపికలు',
// //       'free': 'ఉచితం',
// //       'activate_plan': 'ప్లాన్ యాక్టివేట్ చేయండి',
// //       'pay_now': 'ఇప్పుడు చెల్లించండి',
// //     },
// //     'hi': {
// //       'app_title': 'पोस्टर मेकर',
// //       'search_placeholder': 'विषय के द्वారा पोस्टर खोजें',
// //       'upcoming_festivals': 'आगामी त्योहार',
// //       'festivals': 'त्योहार',
// //       'new_poster': 'नया पोस्टर',
// //       'no_festivals_found': 'कोई त्योहार नहीं मिला',
// //       'try_different_date': 'अलग तारीख चुनने की कोशिश करें',
// //       'check_other_dates': 'अन्य तारीखें जांचें',
// //       'no_new_posters': 'कोई नए पोस्टर उपलब्ध नहीं',
// //       'view_all': 'सभी देखें',
// //       'select_language': 'भाषा चुनें',
// //       'language_switched': 'भाषा सफलतापूर्वक बदल गई!',
// //       'ugadi': 'उगादी',
// //       'clothing': 'कपड़े',
// //       'beauty': 'सुंदरता',
// //       'chemical': 'रासायनिक',
// //       'subscription_plans': 'सब्सक्रिप्शन प्लान',
// //       'choose_plan': 'अपना प्लान चुनें',
// //       'payment_options': 'भुगतान विकल्प',
// //       'free': 'मुफ्त',
// //       'activate_plan': 'प्लान सक्रिय करें',
// //       'pay_now': 'अभी भुगतान करें',
// //     },
// //     'ta': {
// //       'app_title': 'போஸ்டர் மேக்கர்',
// //       'search_placeholder': 'தலைப்பின் மூலம் போஸ்டரைத் தேடுங்கள்',
// //       'upcoming_festivals': 'வரவிருக்கும் திருவிழாக்கள்',
// //       'festivals': 'திருவிழாக்கள்',
// //       'new_poster': 'புதிய போஸ்டர்',
// //       'no_festivals_found': 'திருவிழாக்கள் எதுவும் கிடைக்கவில்லை',
// //       'try_different_date': 'வேறு தேதியைத் தேர்ந்தெடுக்க முயற்சிக்கவும்',
// //       'check_other_dates': 'மற்ற தேதிகளைச் சரிபார்க்கவும்',
// //       'no_new_posters': 'புதிய போஸ்டர்கள் எதுவும் கிடைக்கவில்லை',
// //       'view_all': 'அனைத்தையும் பார்க்கவும்',
// //       'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
// //       'language_switched': 'மொழி வெற்றிகரமாக மாற்றப்பட்டது!',
// //       'ugadi': 'உகாதி',
// //       'clothing': 'ஆடைகள்',
// //       'beauty': 'அழகு',
// //       'chemical': 'இரசாயன',
// //       'subscription_plans': 'சந்தா திட்டங்கள்',
// //       'choose_plan': 'உங்கள் திட்டத்தைத் தேர்ந்தெடுக்கவும்',
// //       'payment_options': 'கட்டண விருப்பங்கள்',
// //       'free': 'இலவசம்',
// //       'activate_plan': 'திட்டத்தை செயல்படுத்தவும்',
// //       'pay_now': 'இப்போது செலுத்தவும்',
// //     },
// //   };

// //   static String translate(String key, String languageCode) {
// //     return _localizedStrings[languageCode]?[key] ??
// //            _localizedStrings['en']?[key] ??
// //            key;
// //   }
// // }

// class LocalizationService {
//   static final Map<String, Map<String, String>> _localizedStrings = {
//     'en': {
//       'app_title': 'Poster Maker',
//       'search_placeholder': 'Search Poster by Topic',
//       'upcoming_festivals': 'Upcoming Festivals',
//       'festivals': 'Festivals',
//       'new_poster': 'New Poster',
//       'no_festivals_found': 'No Festivals Found',
//       'try_different_date': 'Try selecting a different date',
//       'check_other_dates': 'Check Other Dates',
//       'no_new_posters': 'No New posters available',
//       'view_all': 'View All',
//       'select_language': 'Select Language',
//       'language_switched': 'Language switched successfully!',
//       'ugadi': 'Ugadi',
//       'clothing': 'Clothing',
//       'beauty': 'Beauty',
//       'chemical': 'Chemical',
//       'subscription_plans': 'Subscription Plans',
//       'choose_plan': 'Choose Your Plan',
//       'payment_options': 'Payment Options',
//       'free': 'Free',
//       'activate_plan': 'ACTIVATE PLAN',
//       'pay_now': 'PAY NOW',

//       // NEW KEYS
//       'categories': 'Categories',
//       'create_template': 'Create Template',
//       'logo_design': 'Logo Design',
//       'image_to_video': 'Image to Video',
//       'create_poster': 'Create Poster',
//       'get_invoice': 'Get Invoice',
//       'no_invoice_yet': 'No invoice Yet',
//       'create_first_invoice': 'Create your first invoice!',
//       'create_new_invoice': 'Create New Invoice',
//       'add_customers': 'Add customers',
//       'no_customers_found': 'No customers found',
//       'add_first_customer': 'Add your first customer to get started',
//       'add_new_customer': 'Add new Customer',
//       'chooose_plan': 'Choose Plan',
//       'your_story': 'Your Story',
//       'add_user_data': 'Add User Data',
//       'business_name': 'Business Name',
//       'mobile_number': 'Mobile Number',
//       'email_id': 'Email ID',
//       'gst': 'GST',
//       'business_type': 'Business Type',
//       'home': 'Home',
//       'category': 'Category',
//       'create': 'Create',
//       'invoice': 'Invoice',
//       'add_customer': 'Add Customer',
//       'custom_post': 'Create Custom Post',
//       'square_post': 'Square Post',
//       'story_post': 'Story Post',
//       'cover_picture': 'Cover Picture',
//       'display_picture': 'Display Picture',
//       'instagram_post': 'Instagram Post',
//       'youtube_thumbnail': 'YouTube Thumbnail',
//       'a4_size': 'A4 Size',
//       'certificate': 'Certificate',
//       'poster_maker': 'Poster Maker',
//       'add_image': 'Add Image',
//       'logo_maker': 'Logo Maker',
//       'create_invoice': 'Create Invoice',
//       'logo': 'Logo',
//       'choose_logo': 'Choose Logo',
//       'customer_name': 'Customer Name',
//       'customer_mobile': 'Customer Mobile',
//       'customer_address': 'Customer Address',
//       'product_name': 'Product Name',
//       'quantity': 'Quantity',
//       'description': 'Description',
//       'price': 'Price',
//       'offer_price': 'Offer Price',
//       'hsn': 'HSN',
//       'add_more': 'Add More',
//       'logo_editor': 'Logo Editor',
//       'text': 'Text',
//       'image': 'Image',
//       'shapes': 'Shapes',
//       'elements': 'Elements',
//       'choose_shape': 'Choose Shape',
//       'circle': 'Circle',
//       'rectangle': 'Rectangle',
//       'triangle': 'Triangle',
//       'star': 'Star',
//       'choose_element': 'Choose Element',
//       'heart': 'Heart',
//       'bulb': 'Bulb',
//       'music': 'Music',
//       'camera': 'Camera',
//       'phone': 'Phone',
//       'email': 'Email',
//       'location': 'Location',
//       'name': 'Name',
//       'email_optional': 'E-Mail (Optional)',
//       'address': 'Address',
//       'gender': 'Gender',
//       'date_of_birth': 'Date of Birth',
//       'date_of_anniversary': 'Date of Anniversary',
//       'edit_poster': 'Edit Poster',

//       'background': 'Background',
//       'profile': 'Profile',
//       'filter': 'Filter',
//       'color': 'Color',
//       'add_text': 'Add Text',
//       'stickers': 'Stickers',
//       'contact': 'Contact',
//       'save': 'Save',

//       //new ones
//       'plan_details': 'Plan Details',
//       'login_number': 'Login Number',
//       'current_plan': 'Current Plan',
//       'media_credits': 'Media Credits',
//       'expires_on': 'Expires on',
//       'how_to_use': 'How To Use',
//       'change_industry': 'Change Industry',
//       'refer_earn': 'Refer & Earn',
//       'settings': 'Settings',
//       'delete_account': 'Delete Account',
//       'add_business': 'Add Business',
//       'contact_us': 'Contact Us',
//       'partner_with_us': 'Partner With Us',
//       'rate_app': 'Rate App',
//       'policies': 'Policies',
//       'terms_conditions': 'Terms and Conditions',
//       'chat_with_ai': 'Chat With AI',
//       'logout': 'Logout',
//       'back': 'Back',
//       'bday_greetings': 'B\'day Greetings',
//       'brand_info': 'Brand Info',
//       'remove_background': 'Remove Background',
//       'caption': 'Caption',
//       'whatsapp_sticker': 'WhatsApp Sticker',
//       'auto_product_ad': 'Auto Product Ad',
//       'ask_me_anything': 'Ask me anything',
//       'privacy_policy': 'Privacy Policy',
//       'terms_and_conditions': 'Terms & Conditions',

//       'create_business_post': 'Create Business Post',
//       'add_business_logo': 'Add Business Logo',

//       'owner_name': 'Owner Name',
//       'designation': 'Designation',
//       'phone_number': 'Phone Number',
//       'whatsapp_number': 'WhatsApp Number',
//       'email_address': 'Email Address',
//       'website': 'Website',

//       'gst_number': 'GST Number',
//       'add_supporting_image': 'Add Supporting Image',
//       'submit_post': 'Submit Post',
//       'virtual_business_card': 'Virtual Business Card',

//       'upload_brand_details': 'Upload Your Brand Details',
//       'upload_logo': 'Upload Logo',
//       'extra_elements': 'Extra Elements',
//       'select_social_icons': 'Select Social Media Icons to Highlight on Post',

//       'how_to_use_title': 'How to Use',
//       'how_to_use_intro':
//           '🖼️ Poster Making Application – Overview\n\nWhat is this App?\n\nThe Poster Making App is a simple and powerful tool designed to help users create personalized greeting posters for special occasions like birthdays and anniversaries. Whether you\'re a business wanting to send client wishes or an individual crafting messages for friends and family, this app makes it fast and easy.',
//       'how_to_use_features':
//           'Key Features\n• ✅ Add & manage customer details\n• 🎂 Select from birthday and anniversary templates\n• ✍️ Customize messages with editable captions\n• 🖼️ Choose and change templates with a tap\n• 💾 Save messages using SharedPreferences\n• 📤 Import customer data (planned feature)',
//       'how_to_use_steps':
//           '👨‍🏫 How to Use the App\n\n1. Add Customer Details\n   Tap on “Add Customer Details” to input name, date of birth, or anniversary.\n\n2. Select a Template\n   Choose between templates with or without images.\n\n3. Customize Your Caption\n   Type a custom message and hit Save.\n\n4. Change Templates\n   Tap “Change Template” to browse and select a new one.\n\n5. Preview or Share\n   (Optional feature to be added): Download or share the final poster.',
//       'how_to_use_stack':
//           '🛠️ Technology Stack\n• Flutter for UI\n• SharedPreferences for local storage\n• Image.network to load templates\n• Navigation & Routing for screen transitions',

//       'bank_details': 'Bank Details',
//       'add_bank_details': 'Add Your Bank Details',
//       'secure_bank_info':
//           'Securely add your banking information for transactions',
//       'bank_info': 'Bank Information',
//       'account_holder_name': 'Account Holder Name',
//       'bank_name': 'Bank Name',
//       'account_type': 'Account Type',
//       'checking': 'Checking',
//       'savings': 'Savings',
//       'account_number': 'Account Number',
//       'routing_number': 'Routing Number',
//       'cancel': 'Cancel',
//       'save_details': 'Save Details',
//       'bank_details_saved': 'Bank details saved successfully!',

//       'total_earning': 'Total Earning till date',
//       'current_balance': 'Current Balance',
//       'redeem_now': 'Redeem Now',
//       'refer_earn_big': 'Refer & Earn BIG!',
//       'introduce_friend': 'Introduce a Friend & Get 30 Credit INSTANTLY!',
//       'bonus_credit': 'Bonus! Get 50 Credit More When They Make a Purchase!',
//       'earn_now': 'Earn Now',
//       'referral_info':
//           'Did you know you can earn up to AED 3000 by\nreferring 10 friends in a month? That\'s equal to a\nmonth\'s subscription.',

//       'bday_anniversary': "B'day Anniversary Greetings",
//       'add_customer_details': 'Add Customer\nDetails',
//       'select_birthday_templates': 'Select Birthday Templates',
//       'with_images': 'With Images',
//       'without_images': 'Without Images',
//       'birthday_captions': 'Birthday Captions',
//       'select_anniversary_templates': 'Select Anniversary Templates',
//       'anniversary_captions': 'Anniversary Captions',
//       'change': 'Change',
//       'message_with_image': 'This message will be sent with\nyour image.',

//       'birth_date': 'BirthDate',
//       'anniversary_date': 'Anniversary Date',
//       'upload_profile_photo': 'Upload Profile Photo',
//       'submit': 'Submit',

//       'notifications': 'Notifications',
//       'dark_mode': 'Dark Mode',

//       'contact_us_intro': 'We’d love to hear from you!',
//       'contact_us_message':
//           'Feel free to reach out with any questions or feedback.',
//       'message': 'Message',
//       'send_message': 'Send Message',

//       'user': 'User',
//       'search_poster_by_topic': 'Search Poster by Topic',
//       'username': 'Username',
//       'share_invite_code': 'Share invite code',
//       'copy': 'Copy',
//       'select_business_industry': 'Select Your Business Industry',
//       'search_posters': 'Search Posters',

//       'delete_your_account': 'Delete Your Account',
//       'delete_warning':
//           'This action is permanent and cannot be undone. All your data will be erased',
//       'delete_my_account': 'Delete My Account',

//       'join_content_creator': 'Join Us As A Content Creator',
//       'join_product_dealer': 'Join Us As A Product Dealer',
//     },
//     'te': {
//       'app_title': 'పోస్టర్ మేకర్',
//       'search_placeholder': 'విషయం ద్వారా పోస్టర్ వెతకండి',
//       'upcoming_festivals': 'రాబోయే పండుగలు',
//       'festivals': 'పండుగలు',
//       'new_poster': 'కొత్త పోస్టర్',
//       'no_festivals_found': 'పండుగలు కనుగొనబడలేదు',
//       'try_different_date': 'వేరే తేదీని ఎంచుకోవడానికి ప్రయత్నించండి',
//       'check_other_dates': 'ఇతర తేదీలను తనిఖీ చేయండి',
//       'no_new_posters': 'కొత్త పోస్టర్లు అందుబాటులో లేవు',
//       'view_all': 'అన్నీ చూడండి',
//       'select_language': 'భాషను ఎంచుకోండి',
//       'language_switched': 'భాష విజయవంతంగా మార్చబడింది!',
//       'ugadi': 'ఉగాది',
//       'clothing': 'వస్త్రాలు',
//       'beauty': 'అందం',
//       'chemical': 'రసాయనిక',
//       'subscription_plans': 'సబ్‌స్క్రిప్షన్ ప్లాన్‌లు',
//       'choose_plan': 'మీ ప్లాన్‌ను ఎంచుకోండి',
//       'payment_options': 'చెల్లింపు ఎంపికలు',
//       'free': 'ఉచితం',
//       'activate_plan': 'ప్లాన్ యాక్టివేట్ చేయండి',
//       'pay_now': 'ఇప్పుడు చెల్లించండి',

//       // NEW KEYS
//       'categories': 'వర్గాలు',
//       'create_template': 'టెంప్లేట్ సృష్టించండి',
//       'logo_design': 'లోగో డిజైన్',
//       'image_to_video': 'చిత్రాన్ని వీడియోగా మార్చండి',
//       'create_poster': 'పోస్టర్ సృష్టించండి',
//       'get_invoice': 'ఇన్వాయిస్ పొందండి',
//       'no_invoice_yet': 'ఇన్వాయిస్ ఏదీ లేదు',
//       'create_first_invoice': 'మీ మొదటి ఇన్వాయిస్ సృష్టించండి!',
//       'create_new_invoice': 'కొత్త ఇన్వాయిస్ సృష్టించండి',
//       'add_customers': 'గ్రాహులను జోడించండి',
//       'no_customers_found': 'గ్రాహకులు కనుగొనబడలేదు',
//       'add_first_customer': 'ప్రారంభించేందుకు మీ మొదటి గ్రాహకుడిని జోడించండి',
//       'add_new_customer': 'కొత్త గ్రాహకుడిని జోడించండి',
//       'chooose_plan': 'మీ ప్లాన్‌ను ఎంచుకోండి',
//       'your_story': 'మీ కథ',
//       'add_user_data': 'వినియోగదారు డేటాను జోడించండి',
//       'business_name': 'బిజినెస్ పేరు',
//       'mobile_number': 'మొబైల్ నంబర్',
//       'email_id': 'ఈమెయిల్ ID',
//       'gst': 'GST',
//       'business_type': 'వ్యాపార రకం',
//       'home': 'హోమ్',
//       'category': 'వర్గం',
//       'create': 'సృష్టించండి',
//       'invoice': 'ఇన్వాయిస్',
//       'add_customer': 'గ్రాహకుడిని జోడించండి',
//       'custom_post': 'కస్టమ్ పోస్ట్ సృష్టించండి',
//       'square_post': 'చతురస్ర పోస్ట్',
//       'story_post': 'స్టోరీ పోస్ట్',
//       'cover_picture': 'కవర్ చిత్రం',
//       'display_picture': 'ప్రదర్శన చిత్రం',
//       'instagram_post': 'ఇన్‌స్టాగ్రామ్ పోస్ట్',
//       'youtube_thumbnail': 'యూట్యూబ్ థంబ్‌నెయిల్',
//       'a4_size': 'A4 పరిమాణం',
//       'certificate': 'సర్టిఫికేట్',
//       'poster_maker': 'పోస్టర్ మేకర్',
//       'add_image': 'చిత్రాన్ని జోడించండి',
//       'logo_maker': 'లోగో మేకర్',
//       'create_invoice': 'ఇన్వాయిస్ సృష్టించండి',
//       'logo': 'లోగో',
//       'choose_logo': 'లోగో ఎంచుకోండి',
//       'customer_name': 'గ్రాహకుని పేరు',
//       'customer_mobile': 'గ్రాహక మొబైల్',
//       'customer_address': 'గ్రాహక చిరునామా',
//       'product_name': 'ఉత్పత్తి పేరు',
//       'quantity': 'పరిమాణం',
//       'description': 'వివరణ',
//       'price': 'ధర',
//       'offer_price': 'ఆఫర్ ధర',
//       'hsn': 'HSN',
//       'add_more': 'మరిన్ని జోడించండి',
//       'logo_editor': 'లోగో ఎడిటర్',
//       'text': 'పాఠ్యం',
//       'image': 'చిత్రం',
//       'shapes': 'ఆకారాలు',
//       'elements': 'అంశాలు',
//       'choose_shape': 'ఆకారం ఎంచుకోండి',
//       'circle': 'వృత్తం',
//       'rectangle': 'చతురస్రం',
//       'triangle': 'త్రిభుజం',
//       'star': 'నక్షత్రం',
//       'choose_element': 'అంశాన్ని ఎంచుకోండి',
//       'heart': 'హృదయం',
//       'bulb': 'బల్బ్',
//       'music': 'సంగీతం',
//       'camera': 'కెమెరా',
//       'phone': 'ఫోన్',
//       'email': 'ఇమెయిల్',
//       'location': 'ప్రాంతం',
//       'name': 'పేరు',
//       'email_optional': 'ఈమెయిల్ (ఐచ్ఛికం)',
//       'address': 'చిరునామా',
//       'gender': 'లింగం',
//       'date_of_birth': 'పుట్టిన తేది',
//       'date_of_anniversary': 'వివాహ వార్షికోత్సవ తేది',
//       'edit_poster': 'పోస్టర్‌ను సవరించండి',
//       'background': 'నేపథ్యం',
//       'profile': 'ప్రొఫైల్',
//       'filter': 'ఫిల్టర్',
//       'color': 'రంగు',
//       'add_text': 'పాఠ్యాన్ని జోడించండి',
//       'stickers': 'స్టిక్కర్లు',
//       'contact': 'సంప్రదించండి',
//       'save': 'సేవ్ చేయండి',

//       //
//       'plan_details': 'ప్లాన్ వివరాలు',
//       'login_number': 'లాగిన్ నంబర్',
//       'current_plan': 'ప్రస్తుత ప్లాన్',
//       'media_credits': 'మీడియా క్రెడిట్స్',
//       'expires_on': 'గడువు తేదీ',
//       'how_to_use': 'వినియోగించే విధానం',
//       'change_industry': 'పరిశ్రమ మార్చండి',
//       'refer_earn': 'రిఫర్ చేసి సంపాదించండి',
//       'settings': 'సెట్టింగ్స్',
//       'delete_account': 'ఖాతాను తొలగించు',
//       'add_business': 'వ్యాపారాన్ని జోడించండి',
//       'contact_us': 'మమ్మల్ని సంప్రదించండి',
//       'partner_with_us': 'మాతో భాగస్వామ్యం అవ్వండి',
//       'rate_app': 'యాప్‌కి రేటింగ్ ఇవ్వండి',
//       'policies': 'పాలసీలు',
//       'terms_conditions': 'నిబంధనలు మరియు షరతులు',
//       'chat_with_ai': 'AI తో చాట్ చేయండి',
//       'logout': 'లాగ్ అవుట్',
//       'back': 'వెనుకకు',
//       'bday_greetings': 'పుట్టినరోజు శుభాకాంక్షలు',
//       'brand_info': 'బ్రాండ్ సమాచారం',
//       'remove_background': 'నేపథ్యాన్ని తొలగించండి',
//       'caption': 'శీర్షిక',
//       'whatsapp_sticker': 'వాట్సాప్ స్టికర్',
//       'auto_product_ad': 'ఆటో ఉత్పత్తి ప్రకటన',
//       'ask_me_anything': 'ఏదైనా అడగండి',
//       'privacy_policy': 'గోప్యతా విధానం',
//       'terms_and_conditions': 'నియమాలు మరియు షరతులు',

//       'create_business_post': 'బిజినెస్ పోస్ట్ సృష్టించండి',
//       'add_business_logo': 'బిజినెస్ లోగోను జోడించండి',
//       'owner_name': 'యజమాని పేరు',
//       'designation': 'హోదా',
//       'phone_number': 'ఫోన్ నంబర్',
//       'whatsapp_number': 'వాట్సాప్ నంబర్',
//       'email_address': 'ఈమెయిల్ చిరునామా',
//       'website': 'వెబ్‌సైట్',
//       'gst_number': 'GST నంబర్',
//       'add_supporting_image': 'మద్దతిచెప్పే చిత్రం జోడించండి',
//       'submit_post': 'పోస్ట్ సమర్పించండి',
//       'virtual_business_card': 'వర్చువల్ బిజినెస్ కార్డు',

//       'upload_brand_details': 'మీ బ్రాండ్ వివరాలను అప్‌లోడ్ చేయండి',
//       'upload_logo': 'లోగోను అప్‌లోడ్ చేయండి',
//       'extra_elements': 'అదనపు అంశాలు',

//       'select_social_icons':
//           'పోస్ట్‌పై హైలైట్ చేయడానికి సామాజిక మాధ్యమ చిహ్నాలను ఎంచుకోండి',

//       'how_to_use_title': 'వినియోగించుకునే విధానం',
//       'how_to_use_intro':
//           '🖼️ పోస్టర్ మేకింగ్ యాప్ – అవలోకనం\n\nఈ యాప్ అంటే ఏమిటి?\n\nపోస్టర్ మేకింగ్ యాప్ అనేది పుట్టినరోజులు, వార్షికోత్సవాలు వంటి ప్రత్యేక సందర్భాలకు వ్యక్తిగత శుభాకాంక్షల పోస్టర్లు సృష్టించేందుకు రూపొందించబడిన సాధారణమైన మరియు శక్తివంతమైన సాధనం. వ్యాపారాలు తమ క్లయింట్లకు శుభాకాంక్షలు పంపడానికైనా లేదా వ్యక్తిగతంగా కుటుంబం, స్నేహితులకు సందేశాలు రూపొందించడానికైనా ఇది ఉపయోగపడుతుంది.',
//       'how_to_use_features':
//           'ముఖ్యమైన ఫీచర్లు:\n• ✅ కస్టమర్ వివరాలు జోడించండి & నిర్వహించండి\n• 🎂 పుట్టినరోజు మరియు వార్షికోత్సవ టెంప్లేట్లు ఎంచుకోండి\n• ✍️ మీ సందేశాలను ఎడిట్ చేయండి\n• 🖼️ టెంప్లేట్లను తడిపి మార్చండి\n• 💾 SharedPreferences ద్వారా స్థానికంగా సేవ్ చేయండి\n• 📤 కస్టమర్ డేటా ఇంపోర్ట్ (భవిష్యత్ ఫీచర్)',
//       'how_to_use_steps':
//           '👨‍🏫 యాప్‌ని ఎలా ఉపయోగించాలి:\n\n1. కస్టమర్ వివరాలు జోడించండి\n   పేరు, జన్మదినం లేదా వార్షికోత్సవ తేదీని నమోదు చేయండి\n\n2. టెంప్లేట్‌ను ఎంచుకోండి\n   చిత్రాలతో లేదా లేకుండా టెంప్లేట్లను ఎంచుకోండి\n\n3. మీ సందేశాన్ని ఎడిట్ చేయండి\n   వ్యక్తిగత మెసేజ్ టైప్ చేసి Save చేయండి\n\n4. టెంప్లేట్ మార్చండి\n   కొత్త టెంప్లేట్ బ్రౌజ్ చేసి ఎంచుకోండి\n\n5. ప్రీవ్యూ లేదా షేర్ చేయండి\n   (భవిష్యత్ ఫీచర్): పోస్టర్‌ను డౌన్‌లోడ్ చేయండి లేదా షేర్ చేయండి',
//       'how_to_use_stack':
//           '🛠️ టెక్నాలజీ స్టాక్:\n• UI కోసం Flutter\n• డేటా నిల్వ కోసం SharedPreferences\n• టెంప్లేట్ల కోసం Image.network\n• స్క్రీన్ మార్పులకు నావిగేషన్ & రూటింగ్',

//       'bank_details': 'బ్యాంక్ వివరాలు',
//       'add_bank_details': 'మీ బ్యాంక్ వివరాలను జోడించండి',
//       'secure_bank_info':
//           'లావాదేవీల కోసం మీ బ్యాంక్ సమాచారాన్ని సురక్షితంగా జోడించండి',
//       'bank_info': 'బ్యాంక్ సమాచారం',
//       'account_holder_name': 'ఖాతాదారు పేరు',
//       'bank_name': 'బ్యాంక్ పేరు',
//       'account_type': 'ఖాతా రకం',
//       'checking': 'చెకింగ్',
//       'savings': 'సేవింగ్స్',
//       'account_number': 'ఖాతా సంఖ్య',
//       'routing_number': 'రౌటింగ్ నంబర్',
//       'cancel': 'రద్దు చేయండి',
//       'save_details': 'వివరాలు సేవ్ చేయండి',
//       'bank_details_saved': 'బ్యాంక్ వివరాలు విజయవంతంగా సేవ్ చేయబడ్డాయి!',

//       'total_earning': 'ఇప్పటివరకు సంపాదించిన మొత్తం',
//       'current_balance': 'ప్రస్తుత బ్యాలెన్స్',
//       'redeem_now': 'ఇప్పుడు రీడీమ్ చేయండి',
//       'refer_earn_big': 'సూచించండి & పెద్దగా సంపాదించండి!',
//       'introduce_friend':
//           'స్నేహితుడిని పరిచయం చేయండి మరియు వెంటనే 30 క్రెడిట్ పొందండి!',
//       'bonus_credit':
//           'బోనస్! వారు కొనుగోలు చేసినప్పుడు అదనంగా 50 క్రెడిట్ పొందండి!',
//       'earn_now': 'ఇప్పుడు సంపాదించండి',
//       'referral_info':
//           'మీరు నెలలో 10 మంది స్నేహితులను సూచించడం ద్వారా\nAED 3000 వరకు సంపాదించవచ్చు తెలుసా?\nఇది నెలవారీ సబ్‌స్క్రిప్షన్‌కు సమానం.',

//       'bday_anniversary': 'పుట్టినరోజు & వార్షికోత్సవ శుభాకాంక్షలు',
//       'add_customer_details': 'గ్రాహక\nవివరాలు జోడించండి',
//       'select_birthday_templates': 'పుట్టినరోజు టెంప్లేట్లను ఎంచుకోండి',
//       'with_images': 'చిత్రాలతో',
//       'without_images': 'చిత్రాలు లేకుండా',
//       'birthday_captions': 'పుట్టినరోజు క్యాప్షన్లు',
//       'select_anniversary_templates':
//           'వివాహ వార్షికోత్సవ టెంప్లేట్లను ఎంచుకోండి',
//       'anniversary_captions': 'వివాహ వార్షికోత్సవ క్యాప్షన్లు',
//       'change': 'మార్చు',
//       'message_with_image': 'ఈ సందేశం మీ చిత్రంతో\nకలిపి పంపబడుతుంది.',

//       'birth_date': 'పుట్టిన తేది',
//       'anniversary_date': 'వివాహ వార్షికోత్సవ తేది',
//       'upload_profile_photo': 'ప్రొఫైల్ ఫోటోను అప్‌లోడ్ చేయండి',
//       'submit': 'సమర్పించండి',

//       'notifications': 'నోటిఫికేషన్లు',
//       'dark_mode': 'డార్క్ మోడ్',

//       'contact_us_intro': 'మా నుండి వినడానికి మేము ఉత్సుకతగా ఎదురుచూస్తున్నాం!',
//       'contact_us_message':
//           'ఏవైనా ప్రశ్నలు లేదా అభిప్రాయాలతో మమ్మల్ని నిశ్చింతగా సంప్రదించండి.',
//       'message': 'సందేశం',
//       'send_message': 'సందేశం పంపండి',

//       'user': 'వినియోగదారు',
//       'search_poster_by_topic': 'విషయం ద్వారా పోస్టర్ వెతకండి',
//       'username': 'వినియోగదారుని పేరు',
//       'share_invite_code': 'ఆహ్వాన కోడ్‌ను షేర్ చేయండి',
//       'copy': 'కాపీ చేయండి',
//       'select_business_industry': 'మీ వ్యాపార రంగాన్ని ఎంచుకోండి',
//       'search_posters': 'పోస్టర్లను వెతకండి',

//       'delete_your_account': 'మీ ఖాతాను తొలగించండి',
//       'delete_warning':
//           'ఈ చర్య శాశ్వతమైనది మరియు తిరగలేని పని. మీ అన్ని డేటా తొలగించబడుతుంది',
//       'delete_my_account': 'నా ఖాతాను తొలగించండి',

//       'join_content_creator': 'కంటెంట్ క్రియేటర్‌గా మమ్మల్ని చేరండి',
//       'join_product_dealer': 'ఉత్పత్తి డీలర్‌గా మమ్మల్ని చేరండి',
//     },
//     'hi': {
//       'app_title': 'पोस्टर मेकर',
//       'search_placeholder': 'विषय के द्वारा पोस्टर खोजें',
//       'upcoming_festivals': 'आगामी त्योहार',
//       'festivals': 'त्योहार',
//       'new_poster': 'नया पोस्टर',
//       'no_festivals_found': 'कोई त्योहार नहीं मिला',
//       'try_different_date': 'अलग तारीख चुनने की कोशिश करें',
//       'check_other_dates': 'अन्य तारीखें जांचें',
//       'no_new_posters': 'कोई नए पोस्टर उपलब्ध नहीं',
//       'view_all': 'सभी देखें',
//       'select_language': 'भाषा चुनें',
//       'language_switched': 'भाषा सफलतापूर्वक बदल गई!',
//       'ugadi': 'उगादी',
//       'clothing': 'कपड़े',
//       'beauty': 'सुंदरता',
//       'chemical': 'रासायनिक',
//       'subscription_plans': 'सब्सक्रिप्शन प्लान',
//       'choose_plan': 'अपना प्लान चुनें',
//       'payment_options': 'भुगतान विकल्प',
//       'free': 'मुफ्त',
//       'activate_plan': 'प्लान सक्रिय करें',
//       'pay_now': 'अभी भुगतान करें',

//       // NEW KEYS
//       'categories': 'श्रेणियाँ',
//       'create_template': 'टेम्पलेट बनाएँ',
//       'logo_design': 'लोगो डिज़ाइन',
//       'image_to_video': 'चित्र से वीडियो',
//       'create_poster': 'पोस्टर बनाएँ',
//       'get_invoice': 'इनवॉइस प्राप्त करें',
//       'no_invoice_yet': 'अभी तक कोई इनवॉइस नहीं',
//       'create_first_invoice': 'अपना पहला इनवॉइस बनाएं!',
//       'create_new_invoice': 'नया इनवॉइस बनाएं',
//       'add_customers': 'ग्राहक जोड़ें',
//       'no_customers_found': 'कोई ग्राहक नहीं मिला',
//       'add_first_customer': 'शुरू करने के लिए पहला ग्राहक जोड़ें',
//       'add_new_customer': 'नया ग्राहक जोड़ें',
//       'chooose_plan': 'अपना प्लान चुनें',
//       'your_story': 'आपकी कहानी',
//       'add_user_data': 'उपयोगकर्ता डेटा जोड़ें',
//       'business_name': 'व्यवसाय का नाम',
//       'mobile_number': 'मोबाइल नंबर',
//       'email_id': 'ईमेल आईडी',
//       'gst': 'GST',
//       'business_type': 'व्यवसाय का प्रकार',
//       'home': 'होम',
//       'category': 'श्रेणी',
//       'create': 'बनाएं',
//       'invoice': 'इनवॉइस',
//       'add_customer': 'ग्राहक जोड़ें',
//       'custom_post': 'कस्टम पोस्ट बनाएं',
//       'square_post': 'वर्ग पोस्ट',
//       'story_post': 'स्टोरी पोस्ट',
//       'cover_picture': 'कवर चित्र',
//       'display_picture': 'प्रदर्शन चित्र',
//       'instagram_post': 'इंस्टाग्राम पोस्ट',
//       'youtube_thumbnail': 'यूट्यूब थंबनेल',
//       'a4_size': 'A4 आकार',
//       'certificate': 'प्रमाणपत्र',
//       'poster_maker': 'पोस्टर मेकर',
//       'add_image': 'छवि जोड़ें',
//       'logo_maker': 'लोगो मेकर',
//       'create_invoice': 'इनवॉइस बनाएं',
//       'logo': 'लोगो',
//       'choose_logo': 'लोगो चुनें',
//       'customer_name': 'ग्राहक का नाम',
//       'customer_mobile': 'ग्राहक मोबाइल',
//       'customer_address': 'ग्राहक पता',
//       'product_name': 'उत्पाद का नाम',
//       'quantity': 'मात्रा',
//       'description': 'विवरण',
//       'price': 'मूल्य',
//       'offer_price': 'ऑफ़र मूल्य',
//       'hsn': 'HSN',
//       'add_more': 'और जोड़ें',
//       'logo_editor': 'लोगो संपादक',
//       'text': 'पाठ',
//       'image': 'छवि',
//       'shapes': 'आकृतियाँ',
//       'elements': 'तत्व',
//       'choose_shape': 'आकार चुनें',
//       'circle': 'वृत्त',
//       'rectangle': 'आयत',
//       'triangle': 'त्रिभुज',
//       'star': 'तारा',
//       'choose_element': 'तत्व चुनें',
//       'heart': 'दिल',
//       'bulb': 'बल्ब',
//       'music': 'संगीत',
//       'camera': 'कैमरा',
//       'phone': 'फ़ोन',
//       'email': 'ईमेल',
//       'location': 'स्थान',
//       'name': 'नाम',
//       'email_optional': 'ईमेल (वैकल्पिक)',
//       'address': 'पता',
//       'gender': 'लिंग',
//       'date_of_birth': 'जन्म तिथि',
//       'date_of_anniversary': 'विवाह वर्षगांठ की तिथि',
//       'edit_poster': 'पोस्टर संपादित करें',
//       'background': 'पृष्ठभूमि',
//       'profile': 'प्रोफ़ाइल',
//       'filter': 'फ़िल्टर',
//       'color': 'रंग',
//       'add_text': 'टेक्स्ट जोड़ें',
//       'stickers': 'स्टिकर',
//       'contact': 'संपर्क करें',
//       'save': 'सहेजें',

//       //
//       'plan_details': 'योजना विवरण',
//       'login_number': 'लॉगिन नंबर',
//       'current_plan': 'वर्तमान योजना',
//       'media_credits': 'मीडिया क्रेडिट्स',
//       'expires_on': 'समाप्ति तिथि',
//       'how_to_use': 'कैसे उपयोग करें',
//       'change_industry': 'उद्योग बदलें',
//       'refer_earn': 'रेफर करें और कमाएं',
//       'settings': 'सेटिंग्स',
//       'delete_account': 'खाता हटाएं',
//       'add_business': 'व्यवसाय जोड़ें',
//       'contact_us': 'संपर्क करें',
//       'partner_with_us': 'हमारे साथ साझेदारी करें',
//       'rate_app': 'ऐप को रेट करें',
//       'policies': 'नीतियाँ',
//       'terms_conditions': 'नियम और शर्तें',
//       'chat_with_ai': 'AI से बात करें',
//       'logout': 'लॉगआउट',
//       'back': 'वापस',
//       'bday_greetings': 'जन्मदिन की शुभकामनाएँ',
//       'brand_info': 'ब्रांड जानकारी',
//       'remove_background': 'बैकग्राउंड हटाएं',
//       'caption': 'कैप्शन',
//       'whatsapp_sticker': 'व्हाट्सएप स्टिकर',
//       'auto_product_ad': 'स्वचालित उत्पाद विज्ञापन',
//       'ask_me_anything': 'मुझसे कुछ भी पूछें',
//       'privacy_policy': 'गोपनीयता नीति',
//       'terms_and_conditions': 'नियम और शर्तें',

//       'create_business_post': 'व्यवसाय पोस्ट बनाएं',
//       'add_business_logo': 'व्यवसाय लोगो जोड़ें',
//       'owner_name': 'मालिक का नाम',
//       'designation': 'पदनाम',
//       'phone_number': 'फोन नंबर',
//       'whatsapp_number': 'व्हाट्सएप नंबर',
//       'email_address': 'ईमेल पता',
//       'website': 'वेबसाइट',
//       'gst_number': 'GST नंबर',
//       'add_supporting_image': 'सहायक छवि जोड़ें',
//       'submit_post': 'पोस्ट सबमिट करें',
//       'virtual_business_card': 'वर्चुअल बिजनेस कार्ड',

//       'upload_brand_details': 'अपनी ब्रांड जानकारी अपलोड करें',
//       'upload_logo': 'लोगो अपलोड करें',
//       'extra_elements': 'अतिरिक्त तत्व',

//       'select_social_icons': 'पोस्ट पर दिखाने के लिए सोशल मीडिया आइकन चुनें',

//       'how_to_use_title': 'कैसे उपयोग करें',
//       'how_to_use_intro':
//           '🖼️ पोस्टर बनाने वाला ऐप – अवलोकन\n\nयह ऐप क्या है?\n\nपोस्टर मेकर ऐप एक सरल और शक्तिशाली टूल है जो उपयोगकर्ताओं को जन्मदिन और वर्षगांठ जैसे विशेष अवसरों के लिए व्यक्तिगत पोस्टर बनाने में मदद करता है। यह व्यवसायों और व्यक्तिगत उपयोग दोनों के लिए उपयोगी है।',
//       'how_to_use_features':
//           'मुख्य विशेषताएं:\n• ✅ ग्राहक विवरण जोड़ें और प्रबंधित करें\n• 🎂 जन्मदिन और वर्षगांठ टेम्पलेट्स चुनें\n• ✍️ संदेशों को संपादित करें\n• 🖼️ टेम्पलेट्स को बदलें\n• 💾 SharedPreferences में संदेश सेव करें\n• 📤 ग्राहक डेटा आयात करें (योजना में है)',
//       'how_to_use_steps':
//           '👨‍🏫 ऐप का उपयोग कैसे करें:\n\n1. ग्राहक विवरण जोड़ें\n   “Add Customer Details” पर टैप करें और नाम, जन्मतिथि या वर्षगांठ दर्ज करें\n\n2. टेम्पलेट चुनें\n   इमेज वाले या बिना इमेज वाले टेम्पलेट्स में से चुनें\n\n3. अपना संदेश संपादित करें\n   कस्टम संदेश टाइप करें और Save दबाएं\n\n4. टेम्पलेट बदलें\n   “Change Template” टैप करें और नया टेम्पलेट चुनें\n\n5. प्रीव्यू या शेयर करें\n   (विकसित की जा रही सुविधा): अंतिम पोस्टर डाउनलोड या शेयर करें',
//       'how_to_use_stack':
//           '🛠️ तकनीकी स्टैक:\n• UI के लिए Flutter\n• लोकल स्टोरेज के लिए SharedPreferences\n• टेम्पलेट्स लोड करने के लिए Image.network\n• स्क्रीन नेविगेशन के लिए Routing और Navigation',

//       'bank_details': 'बैंक विवरण',
//       'add_bank_details': 'अपने बैंक विवरण जोड़ें',
//       'secure_bank_info':
//           'लेनदेन के लिए अपने बैंकिंग जानकारी को सुरक्षित रूप से जोड़ें',
//       'bank_info': 'बैंक जानकारी',
//       'account_holder_name': 'खाता धारक का नाम',
//       'bank_name': 'बैंक का नाम',
//       'account_type': 'खाते का प्रकार',
//       'checking': 'चेकिंग',
//       'savings': 'सेविंग्स',
//       'account_number': 'खाता संख्या',
//       'routing_number': 'रूटिंग नंबर',
//       'cancel': 'रद्द करें',
//       'save_details': 'विवरण सहेजें',
//       'bank_details_saved': 'बैंक विवरण सफलतापूर्वक सहेजा गया!',

//       'total_earning': 'अब तक की कुल कमाई',
//       'current_balance': 'वर्तमान बैलेंस',
//       'redeem_now': 'अब रिडीम करें',
//       'refer_earn_big': 'बड़ी कमाई करें रेफर करके!',
//       'introduce_friend': 'एक दोस्त को आमंत्रित करें और तुरंत 30 क्रेडिट पाएं!',
//       'bonus_credit': 'बोनस! उनके खरीदारी करने पर अतिरिक्त 50 क्रेडिट पाएं!',
//       'earn_now': 'अभी कमाएँ',
//       'referral_info':
//           'क्या आप जानते हैं कि आप एक महीने में 10 दोस्तों को रेफर करके\nAED 3000 तक कमा सकते हैं?\nयह एक महीने की सदस्यता के बराबर है।',

//       'bday_anniversary': 'जन्मदिन और वर्षगांठ शुभकामनाएँ',
//       'add_customer_details': 'ग्राहक\nविवरण जोड़ें',
//       'select_birthday_templates': 'जन्मदिन टेम्पलेट चुनें',
//       'with_images': 'छवियों के साथ',
//       'without_images': 'बिना छवियों के',
//       'birthday_captions': 'जन्मदिन कैप्शन',
//       'select_anniversary_templates': 'वर्षगांठ टेम्पलेट चुनें',
//       'anniversary_captions': 'वर्षगांठ कैप्शन',
//       'change': 'बदलें',
//       'message_with_image': 'यह संदेश आपकी छवि के साथ\nभेजा जाएगा।',

//       'birth_date': 'जन्म तिथि',
//       'anniversary_date': 'विवाह वर्षगांठ की तिथि',
//       'upload_profile_photo': 'प्रोफ़ाइल फ़ोटो अपलोड करें',
//       'submit': 'जमा करें',

//       'notifications': 'सूचनाएं',
//       'dark_mode': 'डार्क मोड',

//       'contact_us_intro': 'हम आपसे सुनना पसंद करेंगे!',
//       'contact_us_message':
//           'कृपया कोई भी प्रश्न या प्रतिक्रिया साझा करने में संकोच न करें।',
//       'message': 'संदेश',
//       'send_message': 'संदेश भेजें',

//       'user': 'उपयोगकर्ता',
//       'search_poster_by_topic': 'विषय के द्वारा पोस्टर खोजें',
//       'username': 'उपयोगकर्ता नाम',

//       'share_invite_code': 'आमंत्रण कोड साझा करें',
//       'copy': 'कॉपी करें',
//       'select_business_industry': 'अपना व्यवसाय उद्योग चुनें',
//       'search_posters': 'पोस्टर खोजें',

//       'delete_your_account': 'अपना खाता हटाएं',
//       'delete_warning':
//           'यह क्रिया स्थायी है और पूर्ववत नहीं की जा सकती। आपका सारा डेटा मिटा दिया जाएगा',
//       'delete_my_account': 'मेरा खाता हटाएं',

//       'join_content_creator': 'एक कंटेंट क्रिएटर के रूप में हमसे जुड़ें',
//       'join_product_dealer': 'एक प्रोडक्ट डीलर के रूप में हमसे जुड़ें',
//     },
//     'ta': {
//       'app_title': 'போஸ்டர் மேக்கர்',
//       'search_placeholder': 'தலைப்பின் மூலம் போஸ்டரைத் தேடுங்கள்',
//       'upcoming_festivals': 'வரவிருக்கும் திருவிழாக்கள்',
//       'festivals': 'திருவிழாக்கள்',
//       'new_poster': 'புதிய போஸ்டர்',
//       'no_festivals_found': 'திருவிழாக்கள் எதுவும் கிடைக்கவில்லை',
//       'try_different_date': 'வேறு தேதியைத் தேர்ந்தெடுக்க முயற்சிக்கவும்',
//       'check_other_dates': 'மற்ற தேதிகளைச் சரிபார்க்கவும்',
//       'no_new_posters': 'புதிய போஸ்டர்கள் எதுவும் கிடைக்கவில்லை',
//       'view_all': 'அனைத்தையும் பார்க்கவும்',
//       'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
//       'language_switched': 'மொழி வெற்றிகரமாக மாற்றப்பட்டது!',
//       'ugadi': 'உகாதி',
//       'clothing': 'ஆடைகள்',
//       'beauty': 'அழகு',
//       'chemical': 'இரசாயன',
//       'subscription_plans': 'சந்தா திட்டங்கள்',
//       'choose_plan': 'உங்கள் திட்டத்தைத் தேர்ந்தெடுக்கவும்',
//       'payment_options': 'கட்டண விருப்பங்கள்',
//       'free': 'இலவசம்',
//       'activate_plan': 'திட்டத்தை செயல்படுத்தவும்',
//       'pay_now': 'இப்போது செலுத்தவும்',

//       // NEW KEYS
//       'categories': 'வகைகள்',
//       'create_template': 'டெம்ப்ளேட்டை உருவாக்கவும்',
//       'logo_design': 'லோகோ வடிவமைப்பு',
//       'image_to_video': 'படத்தை வீடியோவாக்கு',
//       'create_poster': 'போஸ்டரை உருவாக்குங்கள்',
//       'get_invoice': 'விலைப்பட்டியலைப் பெறுங்கள்',
//       'no_invoice_yet': 'இன்னும் விலைப்பட்டியல் இல்லை',
//       'create_first_invoice': 'உங்கள் முதல் விலைப்பட்டியலை உருவாக்குங்கள்!',
//       'create_new_invoice': 'புதிய விலைப்பட்டியல் உருவாக்குங்கள்',
//       'add_customers': 'வாடிக்கையாளர்களைச் சேர்க்கவும்',
//       'no_customers_found': 'வாடிக்கையாளர்கள் ஏதுமில்லை',
//       'add_first_customer': 'தொடங்க உங்கள் முதல் வாடிக்கையாளரைச் சேர்க்கவும்',
//       'add_new_customer': 'புதிய வாடிக்கையாளரைச் சேர்க்கவும்',
//       'chooose_plan': 'உங்கள் திட்டத்தைத் தேர்ந்தெடுக்கவும்',
//       'your_story': 'உங்கள் கதை',
//       'add_user_data': 'பயனர் தரவுகளைச் சேர்க்கவும்',
//       'business_name': 'வணிகப் பெயர்',
//       'mobile_number': 'மொபைல் எண்',
//       'email_id': 'மின்னஞ்சல் ஐடி',
//       'gst': 'GST',
//       'business_type': 'வணிக வகை',
//       'home': 'முகப்பு',
//       'category': 'வகை',
//       'create': 'உருவாக்கு',
//       'invoice': 'விலைப்பட்டியல்',
//       'add_customer': 'வாடிக்கையாளரைச் சேர்க்கவும்',
//       'custom_post': 'தனிப்பயன் பதிவு உருவாக்கவும்',
//       'square_post': 'சதுரப் பதிவு',
//       'story_post': 'கதைப்பட பதிவு',
//       'cover_picture': 'கவர் படம்',
//       'display_picture': 'காட்சி படம்',
//       'instagram_post': 'இன்ஸ்டாகிராம் பதிவு',
//       'youtube_thumbnail': 'யூடியூப் சிறுபடம்',
//       'a4_size': 'A4 அளவு',
//       'certificate': 'சான்றிதழ்',
//       'poster_maker': 'போஸ்டர் மேக்கர்',
//       'add_image': 'படத்தைச் சேர்க்கவும்',
//       'logo_maker': 'லோகோ மேக்கர்',
//       'create_invoice': 'விலைப்பட்டியல் உருவாக்கவும்',
//       'logo': 'லோகோ',
//       'choose_logo': 'லோகோவைத் தேர்வுசெய்க',
//       'customer_name': 'வாடிக்கையாளர் பெயர்',
//       'customer_mobile': 'வாடிக்கையாளர் கைபேசி',
//       'customer_address': 'வாடிக்கையாளர் முகவரி',
//       'product_name': 'தயாரிப்பு பெயர்',
//       'quantity': 'அளவு',
//       'description': 'விவரம்',
//       'price': 'விலை',
//       'offer_price': 'சலுகை விலை',
//       'hsn': 'HSN',
//       'add_more': 'மேலும் சேர்க்கவும்',
//       'logo_editor': 'லோகோ எடிட்டர்',
//       'text': 'உரைத்தொகை',
//       'image': 'படம்',
//       'shapes': 'வடிவங்கள்',
//       'elements': 'உறுப்புகள்',
//       'choose_shape': 'வடிவத்தைத் தேர்ந்தெடுக்கவும்',
//       'circle': 'வட்டம்',
//       'rectangle': 'செவ்வகம்',
//       'triangle': 'முக்கோணம்',
//       'star': 'நட்சத்திரம்',
//       'choose_element': 'உறுப்பைத் தேர்ந்தெடுக்கவும்',
//       'heart': 'இதயம்',
//       'bulb': 'பல்பு',
//       'music': 'இசை',
//       'camera': 'கேமரா',
//       'phone': 'தொலைபேசி',
//       'email': 'மின்னஞ்சல்',
//       'location': 'இருப்பிடம்',
//       'name': 'பெயர்',
//       'email_optional': 'மின்னஞ்சல் (விருப்பத்தேர்வு)',
//       'address': 'முகவரி',
//       'gender': 'பாலினம்',
//       'date_of_birth': 'பிறந்த தேதி',
//       'date_of_anniversary': 'திருமண ஆண்டு தேதி',
//       'edit_poster': 'போஸ்டரைத் திருத்தவும்',
//       'background': 'பின்னணி',
//       'profile': 'சுயவிவரம்',
//       'filter': 'வடிகட்டி',
//       'color': 'நிறம்',
//       'add_text': 'உரையைச் சேர்க்கவும்',
//       'stickers': 'ஸ்டிக்கர்கள்',
//       'contact': 'தொடர்புக்கு',
//       'save': 'சேமிக்கவும்',

//       //new
//       'plan_details': 'திட்ட விவரங்கள்',
//       'login_number': 'உள்நுழைவு எண்',
//       'current_plan': 'தற்போதைய திட்டம்',
//       'media_credits': 'மீடியா கிரெடிட்ஸ்',
//       'expires_on': 'காலாவதி தேதி',
//       'how_to_use': 'பயன்படுத்தும் முறை',
//       'change_industry': 'தொழிலை மாற்றவும்',
//       'refer_earn': 'பரிந்துரை செய்து சம்பாதிக்கவும்',
//       'settings': 'அமைப்புகள்',
//       'delete_account': 'கணக்கை நீக்கவும்',
//       'add_business': 'வணிகத்தைச் சேர்க்கவும்',
//       'contact_us': 'எங்களை தொடர்புகொள்ளுங்கள்',
//       'partner_with_us': 'எங்களுடன் கூட்டிணையுங்கள்',
//       'rate_app': 'அப்பை மதிப்பீடு செய்யவும்',
//       'policies': 'கொள்கைகள்',
//       'terms_conditions': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
//       'chat_with_ai': 'AI உடன் உரையாடவும்',
//       'logout': 'வெளியேறு',
//       'back': 'மீண்டும்',
//       'bday_greetings': 'பிறந்தநாள் வாழ்த்துகள்',
//       'brand_info': 'பிராண்ட் தகவல்',
//       'remove_background': 'பின்னணியை அகற்றவும்',
//       'caption': 'பொருள் விளக்கம்',
//       'whatsapp_sticker': 'வாட்ஸ்அப் ஸ்டிக்கர்',
//       'auto_product_ad': 'தானியங்கு தயாரிப்பு விளம்பரம்',
//       'ask_me_anything': 'என்னையென்று ஏதும் கேளுங்கள்',
//       'privacy_policy': 'தனியுரிமைக் கொள்கை',
//       'terms_and_conditions': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',

//       'create_business_post': 'வணிகப் பதிவை உருவாக்கவும்',
//       'add_business_logo': 'வணிக லோகோவைச் சேர்க்கவும்',

//       'owner_name': 'உரிமையாளர் பெயர்',
//       'designation': 'பதவி',
//       'phone_number': 'தொலைபேசி எண்',
//       'whatsapp_number': 'வாட்ஸ்அப் எண்',
//       'email_address': 'மின்னஞ்சல் முகவரி',
//       'website': 'இணையதளம்',

//       'gst_number': 'GST எண்',
//       'add_supporting_image': 'ஆதரவளிக்கும் படத்தைச் சேர்க்கவும்',
//       'submit_post': 'பதிவைச் சமர்ப்பிக்கவும்',
//       'virtual_business_card': 'மெய்நிகர் வணிக அட்டை',

//       'upload_brand_details': 'உங்கள் பிராண்ட் விவரங்களை பதிவேற்றவும்',
//       'upload_logo': 'லோகோவை பதிவேற்றவும்',
//       'extra_elements': 'கூடுதல் கூறுகள்',

//       'select_social_icons':
//           'போஸ்டில் தெறிவிக்க சமூக ஊடக ஐகான்களைத் தேர்வுசெய்க',
//       'how_to_use_title': 'எப்படி பயன்படுத்துவது',
//       'how_to_use_intro':
//           '🖼️ போஸ்டர் உருவாக்கும் பயன்பாடு – மேலோட்டம்\n\nஇந்த பயன்பாடு என்றால் என்ன?\n\nபோஸ்டர் மேக்கர் ஒரு எளிமையான மற்றும் சக்திவாய்ந்த கருவி. இது பிறந்தநாள் மற்றும் திருமண நாளுக்கு தனிப்பயனாக்கப்பட்ட வாழ்த்து போஸ்டர்களை உருவாக்க உதவுகிறது. வணிகங்களும், தனிப்பட்ட நபர்களும் விரைவாக உருவாக்கலாம்.',
//       'how_to_use_features':
//           'முக்கிய அம்சங்கள்:\n• ✅ வாடிக்கையாளர் விவரங்களைச் சேர் மற்றும் நிர்வகி\n• 🎂 பிறந்த நாள் மற்றும் திருமண நாள் டெம்ப்ளேட்களைத் தேர்ந்தெடுக்கவும்\n• ✍️ உங்கள் செய்திகளைத் திருத்தவும்\n• 🖼️ டெம்ப்ளேட்களை மாற்ற சுலபமான தொடுதல்\n• 💾 SharedPreferences-ஐ பயன்படுத்தி சேமி\n• 📤 வாடிக்கையாளர் தரவை இறக்குமதி செய்யவும் (விரைவில்)',
//       'how_to_use_steps':
//           '👨‍🏫 பயன்பாட்டைப் பயன்படுத்தும் முறை:\n\n1. வாடிக்கையாளர் விவரங்களைச் சேர்\n   “Add Customer Details” ஐத் தட்டவும் மற்றும் பெயர், பிறந்த நாள் அல்லது திருமண நாளை உள்ளிடவும்\n\n2. டெம்ப்ளேட் தேர்ந்தெடுக்கவும்\n   படம் உள்ளதும் இல்லாததும் தேர்வு செய்யவும்\n\n3. உங்கள் செய்தியைத் திருத்தவும்\n   உங்கள் செய்தியை உள்ளிட்டு Save செய்யவும்\n\n4. டெம்ப்ளேட்டை மாற்றவும்\n   “Change Template” ஐத் தட்டவும் மற்றும் புதியதை தேர்வுசெய்யவும்\n\n5. முன்னோட்டம் காண்க அல்லது பகிரவும்\n   (விரைவில் வரவிருக்கும் அம்சம்): இறுதிப் போஸ்டரை பதிவிறக்கவும் அல்லது பகிரவும்',
//       'how_to_use_stack':
//           '🛠️ தொழில்நுட்பங்கள்:\n• UIக்காக Flutter\n• SharedPreferences மூலம் சேமிக்கவும்\n• Image.network மூலம் படங்களை ஏற்றவும்\n• திரை மாற்றத்திற்கான Navigation & Routing',

//       'bank_details': 'வங்கி விவரங்கள்',
//       'add_bank_details': 'உங்கள் வங்கி விவரங்களைச் சேர்க்கவும்',
//       'secure_bank_info':
//           'பரிவர்த்தனைகளுக்கான வங்கி தகவலை பாதுகாப்பாக சேர்க்கவும்',
//       'bank_info': 'வங்கி தகவல்',
//       'account_holder_name': 'கணக்கு வைத்திருப்பவர் பெயர்',
//       'bank_name': 'வங்கி பெயர்',
//       'account_type': 'கணக்கு வகை',
//       'checking': 'செக்கிங்',
//       'savings': 'சேமிப்பு',
//       'account_number': 'கணக்கு எண்',
//       'routing_number': 'ரவுடிங் எண்',
//       'cancel': 'ரத்துசெய்',
//       'save_details': 'விவரங்களை சேமிக்கவும்',
//       'bank_details_saved': 'வங்கி விவரங்கள் வெற்றிகரமாக சேமிக்கப்பட்டன!',

//       'total_earning': 'இதுவரை கிடைத்த மொத்த வருமானம்',
//       'current_balance': 'தற்போதைய இருப்பு',
//       'redeem_now': 'இப்போதே பரிசளிக்கவும்',
//       'refer_earn_big': 'பெரிய அளவில் பரிந்துரை செய்து சம்பாதிக்கவும்!',
//       'introduce_friend':
//           'நண்பரை அறிமுகப்படுத்துங்கள் மற்றும் உடனடியாக 30 கிரெடிட் பெறுங்கள்!',
//       'bonus_credit':
//           'போனஸ்! அவர்கள் வாங்கும் போது மேலும் 50 கிரெடிட் பெறுங்கள்!',
//       'earn_now': 'இப்போதே சம்பாதிக்கவும்',
//       'referral_info':
//           'ஒரே மாதத்தில் 10 நண்பர்களை பரிந்துரை செய்து நீங்கள்\nAED 3000 வரை சம்பாதிக்கலாம் என்பதைத் தெரியுமா?\nஇது ஒரு மாத சந்தாவிற்குச் சமம்.',

//       'bday_anniversary': 'பிறந்தநாள் & ஆண்டு விழா வாழ்த்துக்கள்',
//       'add_customer_details': 'வாடிக்கையாளர்\nவிவரங்களைச் சேர்க்கவும்',
//       'select_birthday_templates': 'பிறந்தநாள் டெம்ப்ளேட்டுகளைத் தேர்வுசெய்க',
//       'with_images': 'படங்களுடன்',
//       'without_images': 'படங்கள் இல்லாமல்',
//       'birthday_captions': 'பிறந்தநாள் தலைப்புகள்',
//       'select_anniversary_templates':
//           'திருமண ஆண்டு டெம்ப்ளேட்டுகளைத் தேர்வுசெய்க',
//       'anniversary_captions': 'திருமண ஆண்டு தலைப்புகள்',
//       'change': 'மாற்றவும்',
//       'message_with_image': 'இந்த செய்தி உங்கள் படத்துடன்\nஅனுப்பப்படும்.',

//       'birth_date': 'பிறந்த தேதி',
//       'anniversary_date': 'திருமண நாள்',
//       'upload_profile_photo': 'சுயவிவர புகைப்படத்தை பதிவேற்றவும்',
//       'submit': 'சமர்ப்பிக்கவும்',

//       'notifications': 'அறிவிப்புகள்',
//       'dark_mode': 'இருள் பயன்முறை',

//       'contact_us_intro':
//           'உங்களிடம் இருந்து கேட்பதற்காக நாங்கள் உற்சாகமாக இருக்கிறோம்!',
//       'contact_us_message':
//           'ஏதேனும் கேள்விகள் அல்லது கருத்துகள் இருந்தால் தயங்காமல் தொடர்புகொள்ளுங்கள்.',
//       'message': 'செய்தி',
//       'send_message': 'செய்தியை அனுப்பவும்',

//       'user': 'பயனர்',
//       'search_poster_by_topic': 'தலைப்பின் மூலம் போஸ்டரைத் தேடுங்கள்',
//       'username': 'பயனர் பெயர்',
//       'share_invite_code': 'அழைப்புக் குறியீட்டைப் பகிரவும்',
//       'copy': 'நகலெடுக்கவும்',
//       'select_business_industry': 'உங்கள் வணிகத் துறையைத் தேர்வுசெய்க',
//       'search_posters': 'போஸ்டர்களைத் தேடுங்கள்',

//       'delete_your_account': 'உங்கள் கணக்கை நீக்கவும்',
//       'delete_warning':
//           'இந்த செயல் நிரந்தரமானது மற்றும் ரத்து செய்ய முடியாதது. உங்கள் அனைத்து தரவுகளும் அழிக்கப்படும்',
//       'delete_my_account': 'என் கணக்கை நீக்கு',

//       'join_content_creator': 'உள்ளடக்க உருவாக்குபவராக எங்களைச் சேருங்கள்',
//       'join_product_dealer': 'தயாரிப்பு வியாபாரியாக எங்களைச் சேருங்கள்',
//     },
//   };

//   static String translate(String key, String languageCode) {
//     return _localizedStrings[languageCode]?[key] ??
//         _localizedStrings['en']?[key] ??
//         key;
//   }
// }

// // 3. Create a translation helper widget (widgets/app_text.dart)

// class AppText extends StatelessWidget {
//   final String textKey;
//   final TextStyle? style;
//   final TextAlign? textAlign;
//   final int? maxLines;
//   final TextOverflow? overflow;

//   const AppText(
//     this.textKey, {
//     Key? key,
//     this.style,
//     this.textAlign,
//     this.maxLines,
//     this.overflow,
//   }) : super(key: key);

//   static String translate(BuildContext context, String key) {
//     final languageProvider =
//         Provider.of<LanguageProvider>(context, listen: false);
//     return LocalizationService.translate(
//         key, languageProvider.locale.languageCode);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final languageProvider = Provider.of<LanguageProvider>(context);
//     final translatedText = LocalizationService.translate(
//         textKey, languageProvider.locale.languageCode);

//     return Text(
//       translatedText,
//       style: style,
//       textAlign: textAlign,
//       maxLines: maxLines,
//       overflow: overflow,
//     );
//   }
// }