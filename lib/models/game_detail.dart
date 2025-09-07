class GameDetail {
  final int appId;
  final String name;
  final String imageUrl;

  GameDetail({required this.appId, required this.name, required this.imageUrl});

  factory GameDetail.fromJson(int appId, Map<String, dynamic> json) {
    final data = json['data'];
    return GameDetail(
      appId: appId,
      name: data['name'] ?? 'Sem nome',
      imageUrl: data['header_image'] ?? '',
    );
  }
}
