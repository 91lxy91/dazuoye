enum PlanStatus { completed, inProgress, notStarted }
enum FilterStatus { all, completed, inProgress, notStarted }

class Plan {
  final String title, subtitle, avatarUrl;
  final PlanStatus status;
  const Plan({required this.title, required this.subtitle, required this.status, required this.avatarUrl});
  Plan copyWith({PlanStatus? status}) => Plan(title: title, subtitle: subtitle, status: status ?? this.status, avatarUrl: avatarUrl);
}
