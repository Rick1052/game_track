// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GameTrack';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get username => 'Username';

  @override
  String get displayName => 'Display name';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get upload => 'Upload';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get likes => 'Likes';

  @override
  String get comments => 'Comments';

  @override
  String get views => 'Views';

  @override
  String get followers => 'Followers';

  @override
  String get videos => 'Videos';

  @override
  String get score => 'Score';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get myVideos => 'My videos';

  @override
  String get catalog => 'Catalog';

  @override
  String get redeem => 'Redeem';

  @override
  String pointsCost(int points) {
    return 'Cost: $points points';
  }

  @override
  String get privacy => 'Privacy';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get system => 'System';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get noVideos => 'No videos found';

  @override
  String get noUsers => 'No users found';

  @override
  String get uploadVideo => 'Upload video';

  @override
  String get selectVideo => 'Select video';

  @override
  String get compressVideo => 'Compress video';

  @override
  String get videoTitle => 'Video title';

  @override
  String get videoDescription => 'Description (optional)';

  @override
  String get gameName => 'Game name (optional)';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploadSuccess => 'Video uploaded successfully!';

  @override
  String get uploadError => 'Error uploading video';

  @override
  String get like => 'Like';

  @override
  String get unlike => 'Unlike';

  @override
  String get alreadyLiked => 'You already liked this video';

  @override
  String get searchUsers => 'Search users';

  @override
  String get noResults => 'No results found';

  @override
  String pointsEarned(int points) {
    return 'Points earned: $points';
  }

  @override
  String get insufficientPoints => 'Insufficient points';

  @override
  String get redemptionSuccess => 'Redemption successful!';

  @override
  String get redemptionError => 'Error redeeming voucher';
}
