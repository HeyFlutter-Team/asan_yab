import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sign_in_email => 'Email';

  @override
  String get sign_in_email_hintText => 'Enter your email';

  @override
  String get sign_in_email_1_valid => 'please enter your Email';

  @override
  String get sign_in_email_2_valid => 'Your email is incorrect';

  @override
  String get sign_in_email_3_valid => 'Your email format is incorrect';

  @override
  String get sign_in_password => 'Password';

  @override
  String get sign_in_password_hintText => 'Enter your password';

  @override
  String get sign_in_password_1_valid => 'Enter your password';

  @override
  String get sign_in_password_2_valid => 'The password must be 6 characters or more';

  @override
  String get sign_in_checkBox => 'Remember me';

  @override
  String get sign_in_elbT => '  Sign In';

  @override
  String get sig_in_account_text => 'Don\'t have a previous account?';

  @override
  String get sign_in_2_elbT => 'Register';

  @override
  String get sign_in_method_1_if => 'Your email is not registered in the database';

  @override
  String get sign_in_method_2_if => 'Your password is incorrect';

  @override
  String get sign_in_method_3_if => 'For repeated error requests, your account has been blocked. Please try again later';

  @override
  String get sign_up_confirm_p => 'Confirm password';

  @override
  String get sign_up_confirm_p_hint_text => 'Repeat password';

  @override
  String get sign_up_confirm_p_1_valid => 'Enter your password repeatedly';

  @override
  String get sign_up_confirm_p_2_valid => 'Passwords are not equal';

  @override
  String get sign_up_account_text => 'Did you already have an account?';

  @override
  String get sign_up_account_text1 => 'Sign In';

  @override
  String get sign_up_elbT => 'Sign Up';

  @override
  String get sign_up_method => 'This email has already been used';

  @override
  String get verify_appBar_title => 'Email confirmation';

  @override
  String get verify_body_text => 'A confirmation link has been sent to your email!\n   Please click on it to confirm your email.\n If you press the link,\n press send again!';

  @override
  String get verify_elb_text => 'Resend';

  @override
  String get verify_tbt_text => 'Cancel';

  @override
  String get verify_email_dialog => 'An Asan Yab account has been \n created to the following email address.\n If you leave this page\n (without confirming your email and filling\n out the introduction form on the next page),\n you will no longer be able to\n enter Asan Yab with this email.';

  @override
  String get verify_email_give_up => 'Give Up';

  @override
  String get verify_email_continue => 'Continue';

  @override
  String get buttonNvB_1 => 'Home';

  @override
  String get buttonNvB_2 => 'New Place';

  @override
  String get buttonNvB_3 => 'Message';

  @override
  String get buttonNvB_4 => 'Profile';

  @override
  String get proFile_type => 'Account';

  @override
  String get category_title => 'Categories';

  @override
  String get nearbyPlaces_title => 'Nearby places';

  @override
  String get nearbyPlaces_meter_title => 'meters away';

  @override
  String get favorite_page_title => 'Favorites';

  @override
  String get findingFriendById => 'Finding your new friend by Id';

  @override
  String get searchById => 'Search by Id ';

  @override
  String get suggestion_appBar_title => 'Request a new location';

  @override
  String get suggestion_1_tf_labelName => 'Name of the place';

  @override
  String get suggestion_1_tf_valid => 'Enter your address!';

  @override
  String get suggestion_2_tf_labelName => 'Address Location';

  @override
  String get suggestion_2_tf_valid => 'Write address of the location';

  @override
  String get suggestion_3_tf_labelName => 'Location description';

  @override
  String get suggestion_3_tf_valid => 'Write a description of the location';

  @override
  String get suggestion_4_tf_labelName => 'Phone number';

  @override
  String get suggestion_4_tf_valid => 'Enter your number!';

  @override
  String get suggestion_custom_card_title => 'Note';

  @override
  String get suggestion_custom_card_text => 'In this section, you can request us about the place you want, so that we include it in Asan Yab \n\n Also, you can ask us to update the information of the places listed in Asan Yab.';

  @override
  String get suggestion_button => 'Submit request';

  @override
  String get suggestion_customDialog_title => 'Submit a location request';

  @override
  String get suggestion_customDialog_content => 'Your request has been registered';

  @override
  String get suggestion_customDialog_textButton => 'Return to the previous page';

  @override
  String get profile_future_error => 'Information not available';

  @override
  String get profile_copy_id_snack_bar => 'Your ID was copied to the clipboard';

  @override
  String get profile_about_us_listTile => 'About Us';

  @override
  String get profile_edit_button_text => 'Edit';

  @override
  String get profile_buttonSheet_camera => 'Camera';

  @override
  String get profile_buttonSheet_gallery => 'Gallery';

  @override
  String get profile_language_listTile => 'Change Language';

  @override
  String get profile_snackBar_catch => 'Your internet is down';

  @override
  String get profile_dark_mode => 'Dark Mode';

  @override
  String get profile_rate_score => 'ُScore';

  @override
  String get profile_followers => 'Followers';

  @override
  String get profile_following => 'Following';

  @override
  String get edit_appBar_leading => 'Save';

  @override
  String get edit_1_txf_label => 'Name';

  @override
  String get edit_2_txf_label => 'Last Name';

  @override
  String get container_text => 'Search in';

  @override
  String get search_bar_hint_text => 'Search';

  @override
  String get first_text_field_label => 'Name';

  @override
  String get first_text_field_hint => 'Enter your Name';

  @override
  String get first_text_field_valid => 'Your name is empty';

  @override
  String get second_text_field_label => 'Last Name';

  @override
  String get second_text_field_hint => 'Enter your Last Name';

  @override
  String get second_text_field_valid => 'Your last name is empty';

  @override
  String get inviter_ID => 'Inviter ID';

  @override
  String get third_text_field_hint => 'ID of the person who introduced Asan Yab to you';

  @override
  String get elevated_text => 'Enter';

  @override
  String get rating_widget_dialog => 'Please leave a star rating';

  @override
  String get done_click => 'Done';

  @override
  String get details_page_snack_bar => 'To add to favorites you must first log in to your account';

  @override
  String get details_page_1_custom_card => 'Description';

  @override
  String get details_page_2_custom_card => 'Gallery';

  @override
  String get details_page_3_custom_card => 'Specifications';

  @override
  String get details_page_4_custom_card => 'New Items';

  @override
  String get details_page_5_custom_card => 'Name';

  @override
  String get details_page_6_custom_card => 'Price';

  @override
  String get details_page_7_custom_card => 'ِDoctor';

  @override
  String get details_page_8_custom_card => 'ٍExpert';

  @override
  String get details_page_9_custom_card => 'Time';

  @override
  String get about_us_page_appbar_title => 'About Us';

  @override
  String get nearby_place_page_title => 'NearBy Places';

  @override
  String get nearby_place_page_active_location => 'Activate your location';

  @override
  String get nearby_place_page_distances => 'Choose the distance you want';

  @override
  String get nearby_place_page_meter => 'Meter';

  @override
  String get nearby_place_page_km => 'km';

  @override
  String get nearby_place_page_meter_away => 'Meters away';

  @override
  String get nearby_place_page_km_away => 'Km away';

  @override
  String get update_dialog_page_new_version => 'About the new version';

  @override
  String get firstComment => 'The last comment will be shown here';

  @override
  String get comment => 'Comments';

  @override
  String get more => 'More';

  @override
  String get add_a_comment => 'Add a Comment';

  @override
  String get chat_screen => 'To access the chat, your score must be 2 or more';

  @override
  String get chat_message => 'Message';

  @override
  String get message_check_user1 => 'To access the chat you must\n  Log in to your account...';

  @override
  String get message_check_user2 => 'Enter to Email';

  @override
  String get message_personal_score => 'current score';

  @override
  String get message_description => 'To get points, \n you must introduce Asan Yab \n to two of your friends \n and they must enter your personal ID in the field \n mentioned below during registration...>';

  @override
  String get message_your_id => 'Your Id...>';

  @override
  String get for_add_comment => 'for add comment';

  @override
  String get log_in => 'Log in';

  @override
  String get download_image_loading => 'Please waite...';

  @override
  String get menus_restaurant => 'Restaurant Menu';
}
