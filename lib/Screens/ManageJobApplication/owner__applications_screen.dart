import 'package:flutter/material.dart';
import '../../Controllers/job_application_controller.dart';
import '../../Controllers/job_vacancy_controller.dart';
import '../../Models/job_application_model.dart';
import '../../Models/job_vacancy_model.dart';

class OwnerApplicationsScreen extends StatelessWidget {
  const OwnerApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = JobApplicationController();
    final vacancyController = JobVacancyController();

    return Scaffold(
      appBar: AppBar(title: const Text('Applications Received')),
      body: StreamBuilder<List<JobApplicationModel>>(
        stream: appController.getOwnerApplications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final applications = snapshot.data!;
          if (applications.isEmpty)
            return const Center(child: Text('No applications received'));

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];

              return FutureBuilder(
                future: vacancyController.getVacancyById(app.vacancyId),
                builder: (context, jobSnapshot) {
                  if (!jobSnapshot.hasData)
                    return const ListTile(title: Text('Loading job info...'));
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
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.jobTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Workshop: ${job.workshopName}'),
                          Text(
                            'Salary: ${job.currency} ${job.salary.toStringAsFixed(0)} / ${job.payType}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Application Status: ${app.status.toUpperCase()}',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed:
                                    app.status == 'pending'
                                        ? () => appController.updateStatus(
                                          app.id,
                                          'accepted',
                                        )
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Accept'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed:
                                    app.status == 'pending'
                                        ? () => appController.updateStatus(
                                          app.id,
                                          'rejected',
                                        )
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                        ],
                      ),
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
