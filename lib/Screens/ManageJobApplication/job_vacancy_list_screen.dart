import 'package:flutter/material.dart';
import '../../Controllers/job_vacancy_controller.dart';
import '../../Controllers/job_application_controller.dart';
import '../../Controllers/foreman_controller.dart';
import '../../Models/job_vacancy_model.dart';
import '../../Models/foreman_model.dart';

class JobVacancyListScreen extends StatefulWidget {
  const JobVacancyListScreen({super.key});

  @override
  State<JobVacancyListScreen> createState() => _JobVacancyListScreenState();
}

class _JobVacancyListScreenState extends State<JobVacancyListScreen> {
  final vacancyController = JobVacancyController();
  final applicationController = JobApplicationController();
  final foremanController = ForemanController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JobVacancyModel>>(
      stream: vacancyController.getAllVacancies(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No job vacancies'));
        }

        final jobs = snapshot.data!;

        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job title
                    Text(
                      job.jobTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Workshop
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(job.workshopName)),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Salary
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${job.currency} ${job.salary.toStringAsFixed(0)} / ${job.payType}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(job.jobDescription)),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Skills
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.build_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(job.requiredSkills)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Apply button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            final foreman =
                                await foremanController.getForemanProfile();
                            if (foreman == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Foreman profile not found'),
                                ),
                              );
                              return;
                            }

                            final applied = await applicationController
                                .getForemanApplications()
                                .first
                                .then(
                                  (list) => list.any(
                                    (app) => app.vacancyId == job.id,
                                  ),
                                );

                            if (applied) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Already applied'),
                                ),
                              );
                              return;
                            }

                            await applicationController.applyJob(job);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Application submitted'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Apply'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
