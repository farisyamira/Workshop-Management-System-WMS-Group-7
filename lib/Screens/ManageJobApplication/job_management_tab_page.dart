import 'package:flutter/material.dart';
import 'job_vacancy_list_screen.dart';
import 'foreman_applications_screen.dart';
import 'create_job_vacancy_screen.dart';
import 'owner__applications_screen.dart';

class JobManagementTabPage extends StatelessWidget {
  final String userRole;

  const JobManagementTabPage({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final isForeman = userRole == 'foreman';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Job Management'),
          bottom: TabBar(
            tabs:
                isForeman
                    ? const [
                      Tab(icon: Icon(Icons.work), text: 'Vacancies'),
                      Tab(
                        icon: Icon(Icons.assignment),
                        text: 'My Applications',
                      ),
                    ]
                    : const [
                      Tab(icon: Icon(Icons.post_add), text: 'Post Job'),
                      Tab(
                        icon: Icon(Icons.assignment_ind),
                        text: 'Applications',
                      ),
                    ],
          ),
        ),
        body: TabBarView(
          children:
              isForeman
                  ? [JobVacancyListScreen(), ForemanApplicationsScreen()]
                  : [const CreateJobVacancyScreen(), OwnerApplicationsScreen()],
        ),
      ),
    );
  }
}
