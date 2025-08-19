import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/const.dart';
import 'package:todo_app/provider/task_provider.dart';

class AddTaskView extends StatefulWidget {
  final bool isEditing;
  final Task? task;

  AddTaskView({this.isEditing = false, this.task});

  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Task' : 'Add Task',
          style: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                // Title field
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: boxcolor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    style: TextStyle(color: onSurface, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'eg:Do Homework',
                      hintStyle: TextStyle(color: textcolor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Description field
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: boxcolor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(color: onSurface, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Description (Optional)',
                      hintStyle: TextStyle(color: textcolor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: 16),

                // Due date field
                InkWell(
                  onTap: _selectDate,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: boxcolor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, color: textcolor),
                        SizedBox(width: 12),
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Due Date',
                          style: TextStyle(
                            color: _selectedDate != null ? onSurface : textcolor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitTask,
                    child: _isLoading
                        ? CircularProgressIndicator(color: onSurface)
                        : Text(
                            widget.isEditing ? 'Update Task' : 'Add Task',
                            style: TextStyle(
                              color: onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: primary,
              onPrimary: onSurface,
              surface: surface,
              onSurface: onSurface,
            ),
            dialogBackgroundColor: surface,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a due date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (widget.isEditing) {
        await taskProvider.updateTask(
          widget.task!.id,
          _titleController.text.trim(),
          _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          _selectedDate!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task updated successfully!')),
        );
      } else {
        await taskProvider.addTask(
          _titleController.text.trim(),
          _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          _selectedDate!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );
      }
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
