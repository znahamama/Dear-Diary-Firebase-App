import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/diary_entry_model.dart';
import '../services/diary_entry_service.dart';
import '../widgets/diary_entry_card.dart';
import '../providers/theme_provider.dart';

class DiaryListView extends StatefulWidget {
  DiaryListView({super.key});

  @override
  State<DiaryListView> createState() => _DiaryListViewState();
}

class _DiaryListViewState extends State<DiaryListView> {
  final DiaryEntryService _diaryService = DiaryEntryService();
  String _searchQuery = '';  
  double? _selectedRating;

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (user == null) {
      return const Center(child: Text("You need to be logged in to see your diary."));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dear Diary'),
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addEditDiary'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search entries...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<double>(
                    value: _selectedRating,
                    decoration: InputDecoration(
                      labelText: 'Filter by rating',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Ratings')),
                      for (double i = 1; i <= 5; i++)
                        DropdownMenuItem(value: i, child: Text('$i ⭐')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRating = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<DiaryEntry>>(
              stream: _diaryService.getUserEntries(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading entries: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No diary entries yet. Add one!'));
                }

                List<DiaryEntry> entries = snapshot.data!;

                entries = entries.where((entry) {
                  bool matchesSearch = _searchQuery.isEmpty ||
                      entry.description.toLowerCase().contains(_searchQuery);
                  bool matchesRating = _selectedRating == null ||
                      entry.rating.toDouble() == _selectedRating;
                  return matchesSearch && matchesRating;
                }).toList();

                Map<String, List<DiaryEntry>> groupedEntries = {};
                for (var entry in entries) {
                  String key = DateFormat('MMMM yyyy').format(entry.date);
                  if (!groupedEntries.containsKey(key)) {
                    groupedEntries[key] = [];
                  }
                  groupedEntries[key]!.add(entry);
                }

                return ListView(
                  children: groupedEntries.entries.map((group) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Text(
                            group.key,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...group.value.map((entry) => DiaryEntryCard(entry: entry)).toList(),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
