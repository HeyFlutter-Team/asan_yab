import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @sign_in_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get sign_in_email;

  /// No description provided for @sign_in_email_hintText.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get sign_in_email_hintText;

  /// No description provided for @sign_in_email_1_valid.
  ///
  /// In en, this message translates to:
  /// **'please enter your Email'**
  String get sign_in_email_1_valid;

  /// No description provided for @sign_in_email_2_valid.
  ///
  /// In en, this message translates to:
  /// **'Your email is incorrect'**
  String get sign_in_email_2_valid;

  /// No description provided for @sign_in_email_3_valid.
  ///
  /// In en, this message translates to:
  /// **'Your email format is incorrect'**
  String get sign_in_email_3_valid;

  /// No description provided for @sign_in_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get sign_in_password;

  /// No description provided for @sign_in_password_hintText.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get sign_in_password_hintText;

  /// No description provided for @sign_in_password_1_valid.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get sign_in_password_1_valid;

  /// No description provided for @sign_in_password_2_valid.
  ///
  /// In en, this message translates to:
  /// **'The password must be 6 characters or more'**
  String get sign_in_password_2_valid;

  /// No description provided for @sign_in_checkBox.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get sign_in_checkBox;

  /// No description provided for @sign_in_elbT.
  ///
  /// In en, this message translates to:
  /// **'  Sign In'**
  String get sign_in_elbT;

  /// No description provided for @sig_in_account_text.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a previous account?'**
  String get sig_in_account_text;

  /// No description provided for @sign_in_2_elbT.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get sign_in_2_elbT;

  /// No description provided for @sign_in_method_1_if.
  ///
  /// In en, this message translates to:
  /// **'Your email is not registered in the database'**
  String get sign_in_method_1_if;

  /// No description provided for @sign_in_method_2_if.
  ///
  /// In en, this message translates to:
  /// **'Your password is incorrect'**
  String get sign_in_method_2_if;

  /// No description provided for @sign_in_method_3_if.
  ///
  /// In en, this message translates to:
  /// **'For repeated error requests, your account has been blocked. Please try again later'**
  String get sign_in_method_3_if;

  /// No description provided for @sign_up_confirm_p.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get sign_up_confirm_p;

  /// No description provided for @sign_up_confirm_p_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get sign_up_confirm_p_hint_text;

  /// No description provided for @sign_up_confirm_p_1_valid.
  ///
  /// In en, this message translates to:
  /// **'Enter your password repeatedly'**
  String get sign_up_confirm_p_1_valid;

  /// No description provided for @sign_up_confirm_p_2_valid.
  ///
  /// In en, this message translates to:
  /// **'Passwords are not equal'**
  String get sign_up_confirm_p_2_valid;

  /// No description provided for @sign_up_account_text.
  ///
  /// In en, this message translates to:
  /// **'Did you already have an account?'**
  String get sign_up_account_text;

  /// No description provided for @sign_up_account_text1.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_up_account_text1;

  /// No description provided for @sign_up_elbT.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up_elbT;

  /// No description provided for @sign_up_method.
  ///
  /// In en, this message translates to:
  /// **'This email has already been used'**
  String get sign_up_method;

  /// No description provided for @verify_appBar_title.
  ///
  /// In en, this message translates to:
  /// **'Email confirmation'**
  String get verify_appBar_title;

  /// No description provided for @verify_body_text.
  ///
  /// In en, this message translates to:
  /// **'A confirmation link has been sent to your email!\nPlease click on it to confirm your email.\n If you press the link,\n press send again!'**
  String get verify_body_text;

  /// No description provided for @verify_elb_text.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get verify_elb_text;

  /// No description provided for @verify_tbt_text.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get verify_tbt_text;

  /// No description provided for @verify_email_dialog.
  ///
  /// In en, this message translates to:
  /// **'An Asan Yab account has been \n created to the following email address.\n If you leave this page\n'**
  String get verify_email_dialog;

  /// No description provided for @verify_email_dialog_red.
  ///
  /// In en, this message translates to:
  /// **'without confirming your email and filling\n out the introduction form on the next page,'**
  String get verify_email_dialog_red;

  /// No description provided for @verify_email_dialog_2.
  ///
  /// In en, this message translates to:
  /// **'you will no longer be able to\n enter Asan Yab with this email.'**
  String get verify_email_dialog_2;

  /// No description provided for @verify_email_give_up.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get verify_email_give_up;

  /// No description provided for @verify_email_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get verify_email_continue;

  /// No description provided for @buttonNvB_1.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get buttonNvB_1;

  /// No description provided for @buttonNvB_2.
  ///
  /// In en, this message translates to:
  /// **'New Place'**
  String get buttonNvB_2;

  /// No description provided for @buttonNvB_3.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get buttonNvB_3;

  /// No description provided for @buttonNvB_4.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get buttonNvB_4;

  /// No description provided for @proFile_type.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get proFile_type;

  /// No description provided for @category_title.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get category_title;

  /// No description provided for @nearbyPlaces_title.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get nearbyPlaces_title;

  /// No description provided for @nearbyPlaces_meter_title.
  ///
  /// In en, this message translates to:
  /// **'meters away'**
  String get nearbyPlaces_meter_title;

  /// No description provided for @favorite_page_title.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorite_page_title;

  /// No description provided for @findingFriendById.
  ///
  /// In en, this message translates to:
  /// **'Finding your new friend by Id'**
  String get findingFriendById;

  /// No description provided for @searchById.
  ///
  /// In en, this message translates to:
  /// **'Search by Id '**
  String get searchById;

  /// No description provided for @suggestion_appBar_title.
  ///
  /// In en, this message translates to:
  /// **'Request a new location'**
  String get suggestion_appBar_title;

  /// No description provided for @suggestion_1_tf_labelName.
  ///
  /// In en, this message translates to:
  /// **'Name of the place'**
  String get suggestion_1_tf_labelName;

  /// No description provided for @suggestion_1_tf_valid.
  ///
  /// In en, this message translates to:
  /// **'Enter your address!'**
  String get suggestion_1_tf_valid;

  /// No description provided for @suggestion_2_tf_labelName.
  ///
  /// In en, this message translates to:
  /// **'Address Location'**
  String get suggestion_2_tf_labelName;

  /// No description provided for @suggestion_2_tf_valid.
  ///
  /// In en, this message translates to:
  /// **'Write address of the location'**
  String get suggestion_2_tf_valid;

  /// No description provided for @suggestion_3_tf_labelName.
  ///
  /// In en, this message translates to:
  /// **'Location description'**
  String get suggestion_3_tf_labelName;

  /// No description provided for @suggestion_3_tf_valid.
  ///
  /// In en, this message translates to:
  /// **'Write a description of the location'**
  String get suggestion_3_tf_valid;

  /// No description provided for @suggestion_4_tf_labelName.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get suggestion_4_tf_labelName;

  /// No description provided for @suggestion_4_tf_valid.
  ///
  /// In en, this message translates to:
  /// **'Enter your number!'**
  String get suggestion_4_tf_valid;

  /// No description provided for @suggestion_custom_card_title.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get suggestion_custom_card_title;

  /// No description provided for @suggestion_custom_card_text.
  ///
  /// In en, this message translates to:
  /// **'In this section, you can request us about the place you want, so that we include it in Asan Yab \n\n Also, you can ask us to update the information of the places listed in Asan Yab.'**
  String get suggestion_custom_card_text;

  /// No description provided for @suggestion_button.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get suggestion_button;

  /// No description provided for @suggestion_customDialog_title.
  ///
  /// In en, this message translates to:
  /// **'Submit a location request'**
  String get suggestion_customDialog_title;

  /// No description provided for @suggestion_customDialog_content.
  ///
  /// In en, this message translates to:
  /// **'Your request has been registered'**
  String get suggestion_customDialog_content;

  /// No description provided for @suggestion_customDialog_textButton.
  ///
  /// In en, this message translates to:
  /// **'Return to the previous page'**
  String get suggestion_customDialog_textButton;

  /// No description provided for @suggestion_check_user.
  ///
  /// In en, this message translates to:
  /// **'To submit a request, you must log in to your Asan Yab account'**
  String get suggestion_check_user;

  /// No description provided for @profile_future_error.
  ///
  /// In en, this message translates to:
  /// **'Information not available'**
  String get profile_future_error;

  /// No description provided for @profile_copy_id_snack_bar.
  ///
  /// In en, this message translates to:
  /// **'ID was copied to the clipboard'**
  String get profile_copy_id_snack_bar;

  /// No description provided for @profile_about_us_listTile.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get profile_about_us_listTile;

  /// No description provided for @profile_edit_button_text.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profile_edit_button_text;

  /// No description provided for @profile_buttonSheet_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get profile_buttonSheet_camera;

  /// No description provided for @profile_buttonSheet_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profile_buttonSheet_gallery;

  /// No description provided for @profile_language_listTile.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get profile_language_listTile;

  /// No description provided for @profile_snackBar_catch.
  ///
  /// In en, this message translates to:
  /// **'Your internet is down'**
  String get profile_snackBar_catch;

  /// No description provided for @profile_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profile_dark_mode;

  /// No description provided for @profile_rate_score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get profile_rate_score;

  /// No description provided for @profile_followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profile_followers;

  /// No description provided for @profile_following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profile_following;

  /// No description provided for @profile_wall_paper.
  ///
  /// In en, this message translates to:
  /// **'Chat WallPapers'**
  String get profile_wall_paper;

  /// No description provided for @edit_appBar_leading.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get edit_appBar_leading;

  /// No description provided for @edit_1_txf_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get edit_1_txf_label;

  /// No description provided for @edit_2_txf_label.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get edit_2_txf_label;

  /// No description provided for @edit_3_txf_label.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get edit_3_txf_label;

  /// No description provided for @edit_dialog.
  ///
  /// In en, this message translates to:
  /// **'Will the changes be saved or not?'**
  String get edit_dialog;

  /// No description provided for @edit_dialog_do_not_save.
  ///
  /// In en, this message translates to:
  /// **'Don\'t save'**
  String get edit_dialog_do_not_save;

  /// No description provided for @edit_name_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Name is empty'**
  String get edit_name_is_empty;

  /// No description provided for @edit_last_name_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Last Name is empty'**
  String get edit_last_name_is_empty;

  /// No description provided for @edit_id_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Username is empty'**
  String get edit_id_is_empty;

  /// No description provided for @edit_id_validation_is_empty.
  ///
  /// In en, this message translates to:
  /// **'This Username has already been used'**
  String get edit_id_validation_is_empty;

  /// No description provided for @container_text.
  ///
  /// In en, this message translates to:
  /// **'Search in'**
  String get container_text;

  /// No description provided for @search_bar_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_bar_hint_text;

  /// No description provided for @first_text_field_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get first_text_field_label;

  /// No description provided for @first_text_field_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Name'**
  String get first_text_field_hint;

  /// No description provided for @first_text_field_valid.
  ///
  /// In en, this message translates to:
  /// **'Your name is empty'**
  String get first_text_field_valid;

  /// No description provided for @second_text_field_label.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get second_text_field_label;

  /// No description provided for @second_text_field_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Last Name'**
  String get second_text_field_hint;

  /// No description provided for @second_text_field_valid.
  ///
  /// In en, this message translates to:
  /// **'Your last name is empty'**
  String get second_text_field_valid;

  /// No description provided for @inviter_ID.
  ///
  /// In en, this message translates to:
  /// **'Inviter ID'**
  String get inviter_ID;

  /// No description provided for @third_text_field_hint.
  ///
  /// In en, this message translates to:
  /// **'ID of the person who introduced Asan Yab to you'**
  String get third_text_field_hint;

  /// No description provided for @elevated_text.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get elevated_text;

  /// No description provided for @rating_widget_dialog.
  ///
  /// In en, this message translates to:
  /// **'Please leave a star rating'**
  String get rating_widget_dialog;

  /// No description provided for @done_click.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done_click;

  /// No description provided for @details_page_snack_bar.
  ///
  /// In en, this message translates to:
  /// **'To add to favorites you must first log in to your account'**
  String get details_page_snack_bar;

  /// No description provided for @details_page_1_custom_card.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get details_page_1_custom_card;

  /// No description provided for @details_page_2_custom_card.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get details_page_2_custom_card;

  /// No description provided for @details_page_3_custom_card.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get details_page_3_custom_card;

  /// No description provided for @details_page_4_custom_card.
  ///
  /// In en, this message translates to:
  /// **'New Items'**
  String get details_page_4_custom_card;

  /// No description provided for @details_page_5_custom_card.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get details_page_5_custom_card;

  /// No description provided for @details_page_6_custom_card.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get details_page_6_custom_card;

  /// No description provided for @details_page_7_custom_card.
  ///
  /// In en, this message translates to:
  /// **'ِDoctor'**
  String get details_page_7_custom_card;

  /// No description provided for @details_page_8_custom_card.
  ///
  /// In en, this message translates to:
  /// **'ٍExpert'**
  String get details_page_8_custom_card;

  /// No description provided for @details_page_9_custom_card.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get details_page_9_custom_card;

  /// No description provided for @about_us_page_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_us_page_appbar_title;

  /// No description provided for @nearby_place_page_title.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get nearby_place_page_title;

  /// No description provided for @nearby_place_page_active_location.
  ///
  /// In en, this message translates to:
  /// **'Activate your location'**
  String get nearby_place_page_active_location;

  /// No description provided for @nearby_place_page_distances.
  ///
  /// In en, this message translates to:
  /// **'Desired distance'**
  String get nearby_place_page_distances;

  /// No description provided for @nearby_place_page_meter.
  ///
  /// In en, this message translates to:
  /// **'Meter'**
  String get nearby_place_page_meter;

  /// No description provided for @nearby_place_page_km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get nearby_place_page_km;

  /// No description provided for @nearby_place_page_meter_away.
  ///
  /// In en, this message translates to:
  /// **'Meters away'**
  String get nearby_place_page_meter_away;

  /// No description provided for @nearby_place_page_km_away.
  ///
  /// In en, this message translates to:
  /// **'Km away'**
  String get nearby_place_page_km_away;

  /// No description provided for @update_dialog_page_new_version.
  ///
  /// In en, this message translates to:
  /// **'About the new version'**
  String get update_dialog_page_new_version;

  /// No description provided for @firstComment.
  ///
  /// In en, this message translates to:
  /// **'The last comment will be shown here'**
  String get firstComment;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comment;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @add_a_comment.
  ///
  /// In en, this message translates to:
  /// **'Add a Comment'**
  String get add_a_comment;

  /// No description provided for @chat_screen.
  ///
  /// In en, this message translates to:
  /// **'To access the chat, your score must be 2 or more'**
  String get chat_screen;

  /// No description provided for @chat_message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get chat_message;

  /// No description provided for @message_check_user1.
  ///
  /// In en, this message translates to:
  /// **'To access the chat you must\n  Log in to your account...'**
  String get message_check_user1;

  /// No description provided for @message_check_user2.
  ///
  /// In en, this message translates to:
  /// **'Enter to Email'**
  String get message_check_user2;

  /// No description provided for @message_personal_score.
  ///
  /// In en, this message translates to:
  /// **'Current score'**
  String get message_personal_score;

  /// No description provided for @message_description.
  ///
  /// In en, this message translates to:
  /// **'To get points, \n you must introduce Asan Yab \n to two of your friends \n and they must enter your personal ID in the field \n mentioned below during registration ='**
  String get message_description;

  /// No description provided for @message_your_id.
  ///
  /// In en, this message translates to:
  /// **'Your Id'**
  String get message_your_id;

  /// No description provided for @for_add_comment.
  ///
  /// In en, this message translates to:
  /// **'for add comment'**
  String get for_add_comment;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get log_in;

  /// No description provided for @emoji_recent.
  ///
  /// In en, this message translates to:
  /// **'There are no recent emojis'**
  String get emoji_recent;

  /// No description provided for @download_image_loading.
  ///
  /// In en, this message translates to:
  /// **'Please waite...'**
  String get download_image_loading;

  /// No description provided for @user_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get user_delete_account;

  /// No description provided for @wrong_email.
  ///
  /// In en, this message translates to:
  /// **'Your email or password is wrong, please check first and then try again'**
  String get wrong_email;

  /// No description provided for @wrong_password.
  ///
  /// In en, this message translates to:
  /// **'Your Password is wrong'**
  String get wrong_password;

  /// No description provided for @menus_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menus_restaurant;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
