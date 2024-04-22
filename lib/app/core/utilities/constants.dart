import 'package:cloudwalk_assessment/env/env.dart';

class Constants {
  // string constants
  static String fontFamily = 'DMSans';
  static String baseUrl = "https://api.nasa.gov";
  static String apiPath =
      "$baseUrl/planetary/apod?api_key=${Env.apiKey}&start_date=2023-06-20";
  static String serverError = "Error retrieving images";
  static String socketError = "No Internet Connection";
  static String unknownError = "Something went wrong";
  static String lostConnection = "Please check your internet connection.";
  static String timeout = "Request timed out. Please try again later.";
  static String backupImage =
      "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3270&q=80";

  // double constants
  static double imageHeight = 240;
}
