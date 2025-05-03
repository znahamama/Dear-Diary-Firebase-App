import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/diary_entry_model.dart';
import '../services/diary_entry_service.dart';
import '../services/storage_service.dart';

class AddEditDiaryEntryView extends StatefulWidget {
  final DiaryEntry? entry;

  const AddEditDiaryEntryView({super.key, this.entry});

  @override
  State<AddEditDiaryEntryView> createState() => _AddEditDiaryEntryViewState();
}

class _AddEditDiaryEntryViewState extends State<AddEditDiaryEntryView> {
  final TextEditingController _descriptionController = TextEditingController();
  final DiaryEntryService _diaryService = DiaryEntryService();
  final StorageService _storageService = StorageService();
  DateTime _selectedDate = DateTime.now();
  double _rating = 3;
  List<File> _selectedImages = [];
  List<String> _existingImageUrls = [];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _selectedDate = widget.entry!.date;
      _descriptionController.text = widget.entry!.description;
      _rating = widget.entry!.rating.toDouble();
      _existingImageUrls = List.from(widget.entry!.imageUrls);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  Future<void> _saveEntry() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save entries.')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty.')),
      );
      return;
    }

    List<String> updatedImageUrls = List.from(_existingImageUrls);
    for (var image in _selectedImages) {
      String imageUrl = await _storageService.uploadImage(image, user.uid);
      updatedImageUrls.add(imageUrl);
    }

    final newEntry = DiaryEntry(
      id: widget.entry?.id ?? const Uuid().v4(),
      userId: user.uid,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      rating: _rating.toInt(),
      imageUrls: updatedImageUrls, 
    );

    if (widget.entry == null) {
      await _diaryService.addDiaryEntry(newEntry);
    } else {
      await _diaryService.updateDiaryEntry(newEntry);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved successfully!')),
    );

    Navigator.pop(context);
  }

  Future<void> _deleteEntry() async {
    if (widget.entry == null) return;

    await _diaryService.deleteDiaryEntry(widget.entry!.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry deleted successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.entry == null
            ? const Text('New Diary Entry')
            : const Text('Edit Diary Entry'),
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteEntry,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Date', style: TextStyle(fontSize: 16)),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                DateFormat('yyyy-MM-dd').format(_selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const Text('Describe your day', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _descriptionController,
              maxLength: 140,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Write about your day...",
              ),
            ),

            const SizedBox(height: 20),
            const Text('Rate your day:', style: TextStyle(fontSize: 16)),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: '${_rating.toInt()} ⭐',
              onChanged: (double value) {
                setState(() {
                  _rating = value;
                });
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),

            if (_existingImageUrls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Existing Images:", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _existingImageUrls.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                _existingImageUrls[index],
                                width: 100,
                                height: 100,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeExistingImage(index),
                                child: Container(
                                  color: Colors.black54,
                                  child: const Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

            if (_selectedImages.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Newly Selected Images:", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                _selectedImages[index],
                                width: 100,
                                height: 100,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeSelectedImage(index),
                                child: Container(
                                  color: Colors.black54,
                                  child: const Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
