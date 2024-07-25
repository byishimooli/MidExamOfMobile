import 'package:flutter/material.dart';
import 'package:library_app/book.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _ratingController;
  late TextEditingController _priceController;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing book data if available
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _descriptionController = TextEditingController(text: widget.book?.description ?? '');
    _ratingController = TextEditingController(text: widget.book?.rating.toString() ?? '');
    _priceController = TextEditingController(text: widget.book?.price.toString() ?? '');
    _imageUrl = widget.book?.imageUrl ?? '';
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final updatedBook = Book(
        id: widget.book?.id ?? UniqueKey().toString(), // Use existing ID if editing, otherwise generate new
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text,
        rating: double.parse(_ratingController.text),
        price: double.parse(_priceController.text),
        filePath: widget.book?.filePath ?? '', // Use existing file path if editing
        isRead: widget.book?.isRead ?? false, // Default to false if not provided
        imageUrl: _imageUrl, // Include the image URL
      );
      Navigator.pop(context, updatedBook); // Return the updated book object to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Please enter a valid rating between 0 and 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              _imageUrl.isEmpty
                  ? Text('No image selected.')
                  : Image.file(File(_imageUrl)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
