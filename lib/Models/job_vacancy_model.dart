class JobVacancyModel {
  final String id;
  final String ownerId;
  final String jobTitle;
  final String workshopName;
  final double salary;
  final String currency;
  final String payType;
  final String status;
  final String jobDescription;
  final String requiredSkills;

  JobVacancyModel({
    required this.id,
    required this.ownerId,
    required this.jobTitle,
    required this.workshopName,
    required this.salary,
    required this.currency,
    required this.payType,
    required this.status,
    required this.jobDescription,
    required this.requiredSkills,
  });

  factory JobVacancyModel.fromMap(String id, Map<String, dynamic> map) {
    double salary = 0.0;
    if (map['salary'] is num) {
      salary = (map['salary'] as num).toDouble();
    } else if (map['salary'] is String) {
      salary = double.tryParse(map['salary']) ?? 0.0;
    }

    return JobVacancyModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      jobTitle: map['jobTitle'] ?? 'No Title',
      workshopName: map['workshopName'] ?? '',
      salary: salary,
      currency: map['currency'] ?? 'RM',
      payType: map['payType'] ?? 'day',
      status: map['status'] ?? 'open',
      jobDescription: map['jobDescription'] ?? '',
      requiredSkills: map['requiredSkills'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'jobTitle': jobTitle,
      'workshopName': workshopName,
      'salary': salary,
      'currency': currency,
      'payType': payType,
      'status': status,
      'jobDescription': jobDescription,
      'requiredSkills': requiredSkills,
    };
  }
}
