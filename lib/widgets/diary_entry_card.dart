import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/diary_entry_model.dart';
import '../services/diary_entry_service.dart';

class DiaryEntryCard extends StatefulWidget {
  final DiaryEntry entry;
  const DiaryEntryCard({super.key, required this.entry});

  @override
  State<DiaryEntryCard> createState() => _DiaryEntryCardState();
}

class _DiaryEntryCardState extends State<DiaryEntryCard> {
  int _currentImageIndex = 0;

  void _deleteEntry(BuildContext context) async {
    await DiaryEntryService().deleteDiaryEntry(widget.entry.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry deleted successfully!')),
    );
  }

  void _nextImage() {
    setState(() {
      if (widget.entry.imageUrls.isNotEmpty) {
        _currentImageIndex = (_currentImageIndex + 1) % widget.entry.imageUrls.length;
      }
    });
  }

  void _previousImage() {
    setState(() {
      if (widget.entry.imageUrls.isNotEmpty) {
        _currentImageIndex = (_currentImageIndex - 1 + widget.entry.imageUrls.length) %
            widget.entry.imageUrls.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentImageIndex >= widget.entry.imageUrls.length) {
      _currentImageIndex = widget.entry.imageUrls.isNotEmpty ? 0 : -1;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/addEditDiary',
          arguments: widget.entry,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEE, MMM d').format(widget.entry.date), 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(widget.entry.description, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 10),

              if (widget.entry.imageUrls.isNotEmpty && _currentImageIndex >= 0)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.entry.imageUrls[_currentImageIndex], 
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (widget.entry.imageUrls.length > 1)
                      Positioned(
                        left: 10,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                          onPressed: _previousImage,
                        ),
                      ),
                    if (widget.entry.imageUrls.length > 1)
                      Positioned(
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24),
                          onPressed: _nextImage,
                        ),
                      ),
                  ],
                ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < widget.entry.rating ? Icons.star : Icons.star_border,
                        color: Colors.purple,
                        size: 18,
                      );
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEntry(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
