class ApiConstants {
  static const String baseUrl = 'http://194.164.148.244:4061/api/users';

  static const String login = '$baseUrl/login';
  static const String editProfile = '$baseUrl/edit-profile';

  static String uploadProfileImage(String userId) => '$editProfile/$userId';

  static String addCustomer(String userId) => '$baseUrl/addcustomer/$userId';

  static String fetchUser(String userId) => '$baseUrl/allcustomers/$userId';

  static String deleteCustomer(String userId, String customerId) =>
      '$baseUrl/delete-customers/$userId/$customerId';

  static String updateCustomer(String userId, String customerId) =>
      '$baseUrl/update-customers/$userId/$customerId';

  static const String getAllCategories =
      '$baseUrl/api/category/getall-cateogry';

  static const String festivalTemplates = '$baseUrl/api/poster/festival';

  static const String getAllPlans = 'http://194.164.148.244:4061/api/plans/getallplan';

  static const String getLogos = 'http://194.164.148.244:4061/api/admin/getlogos';

  static String getMyPlan(String userId) => 'http://194.164.148.244:4061/api/users/myplan/$userId';

  static String canvaPosters = 'http://194.164.148.244:4061/api/poster/canvasposters';

  static String getAllPosters = 'http://194.164.148.244:4061/api/poster/getallposter';

  static const String purchasePlan = '$baseUrl/api/payment/phonepe';

  static String redeem(String userId) => '$baseUrl/redeem/$userId';

  static String reportUser(String userId, String reportedUserId) =>
      'http://194.164.148.244:4061/api/users/report/$userId/$reportedUserId';

  static String blockUser(String userId, String blockedUserId) =>
      'http://194.164.148.244:4061/api/block/$userId/$blockedUserId';

  static const String registerUser = '$baseUrl/register';

  static const String singleCanvasPosters =
      '$baseUrl/poster/singlecanvasposters';

  static const String singlePlan = 'http://194.164.148.244:4061/api/users/plans/singleplan';

  static const String verifyOtp = '$baseUrl/verify-otp';

  static const String resendOtp = '$baseUrl/resend-otp';

  static const String getposterbyCategory =
      'http://194.164.148.244:4061/api/poster/getposterbycategory';

  static const String getUserProfile = '$baseUrl/get-profile/userId';

  static const String apiKey = "AIzaSyA8Sp_taG6U6AXoUMvp3TvS2KvmWVUlWWE";
}
