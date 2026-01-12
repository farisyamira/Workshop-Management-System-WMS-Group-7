import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Controllers/job_vacancy_controller.dart';
import '../../Models/job_vacancy_model.dart';

class CreateJobVacancyScreen extends StatefulWidget {
  const CreateJobVacancyScreen({super.key});

  @override
  State<CreateJobVacancyScreen> createState() => _CreateJobVacancyScreenState();
}

class _CreateJobVacancyScreenState extends State<CreateJobVacancyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _workshopController = TextEditingController();
  final _salaryController = TextEditingController();
  final _currencyController = TextEditingController(text: 'RM');
  final _payTypeController = TextEditingController(text: 'day');
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();

  final vacancyController = JobVacancyController();

  bool _isSubmitting = false;

  void _submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final job = JobVacancyModel(
        id: '',
        ownerId: FirebaseAuth.instance.currentUser!.uid,
        jobTitle: _titleController.text.trim(),
        workshopName: _workshopController.text.trim(),
        salary: double.parse(_salaryController.text.trim()),
        currency: _currencyController.text.trim(),
        payType: _payTypeController.text.trim(),
        status: 'open',
        jobDescription: _descriptionController.text.trim(),
        requiredSkills: _skillsController.text.trim(),
      );

      await vacancyController.createVacancy(job);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Job posted successfully!')));

      _formKey.currentState!.reset();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _workshopController.dispose();
    _salaryController.dispose();
    _currencyController.dispose();
    _payTypeController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Job Vacancy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Job Title',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter job title'
                                : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _workshopController,
                    decoration: const InputDecoration(
                      labelText: 'Workshop Name',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter workshop name'
                                : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Salary',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter salary';
                      if (double.tryParse(value) == null)
                        return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _currencyController,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _payTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Pay Type (day/month)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Job Description',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter job description'
                                : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _skillsController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Required Skills',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter required skills'
                                : null,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitJob,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          _isSubmitting
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Post Job',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
