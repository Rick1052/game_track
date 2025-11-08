import '../models/video_model.dart';

abstract class VideoRepository {
  Stream<List<VideoModel>> getVideos({
    int limit = 10,
    DateTime? startAfter,
    String? orderBy,
  });
  
  Future<VideoModel> getVideoById(String videoId);
  Future<List<VideoModel>> getUserVideos(String userId);
  Future<VideoModel> uploadVideo({
    required String filePath,
    required String title,
    String? description,
    String? game,
    bool compress = false,
  });
  Future<void> deleteVideo(String videoId);
  Future<String> generateThumbnail(String videoPath);
  Future<void> likeVideo(String videoId, String userId);
  Future<void> unlikeVideo(String videoId, String userId);
  Future<bool> hasUserLikedVideo(String videoId, String userId);
  Future<void> incrementViews(String videoId);
}

