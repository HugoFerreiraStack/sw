class Order {
  final int id;
  final String description;
  final bool completed;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.description,
    required this.completed,
    required this.createdAt,
  });
}