class AppConstants {
  // Points system
  static const int pointsPerVideo = 10;
  static const int pointsPerLike = 1;
  static const int pointsPerFollower = 5;

  // Pagination
  static const int videosPerPage = 10;
  static const int usersPerPage = 20;

  // Video
  static const double videoAutoPlayThreshold = 0.5; // 50% visible
  static const int maxVideoDurationSeconds = 60;
  static const int maxVideoSizeMB = 100;

  // Storage paths
  static const String videosStoragePath = 'videos';
  static const String thumbnailsStoragePath = 'thumbnails';
  static const String avatarsStoragePath = 'avatars';
}

