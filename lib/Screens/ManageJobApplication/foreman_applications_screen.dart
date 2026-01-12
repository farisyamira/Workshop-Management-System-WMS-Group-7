import 'package:flutter/material.dart';
import '../../Controllers/job_application_controller.dart';
import '../../Controllers/job_vacancy_controller.dart';
import '../../Models/job_application_model.dart';
import '../../Models/job_vacancy_model.dart';

class ForemanApplicationsScreen extends StatelessWidget {
  const ForemanApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = JobApplicationController();
    final vacancyController = JobVacancyController();

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: StreamBuilder<List<JobApplicationModel>>(
        stream: appController.getForemanApplications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final apps = snapshot.data!;
          if (apps.isEmpty) return const Center(child: Text('No applications'));

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];

              return FutureBuilder(
                future: vacancyController.getVacancyById(app.vacancyId),
                builder: (context, jobSnapshot) {
                  if (!jobSnapshot.hasData)
                    return const ListTile(title: Text('Loading...'));
                  if (!jobSnapshot.data!.exists)
                    return const ListTile(
                      title: Text('Job no longer available'),
                    );

                  final jobData =
                      jobSnapshot.data!.data() as Map<String, dynamic>;
                  final job = JobVacancyModel.fromMap(
                    jobSnapshot.data!.id,
                    jobData,
                  );

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(job.jobTitle),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Workshop: ${job.workshopName}'),
                          Text(
                            'Salary: ${job.currency} ${job.salary.toStringAsFixed(0)} / ${job.payType}',
                          ),
                          Text('Status: ${app.status.toUpperCase()}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
