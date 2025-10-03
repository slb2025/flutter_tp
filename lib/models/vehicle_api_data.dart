class VehicleApiData {
  final int id;
  final String title;
  final bool completed;

  VehicleApiData({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory VehicleApiData.fromJson(Map<String, dynamic> json) {
    return VehicleApiData(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}