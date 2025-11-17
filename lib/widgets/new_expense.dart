import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final formatter = DateFormat.yMd();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.travel;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  void _showDialog(){
 Platform.isIOS?
                            showCupertinoDialog(context: context, builder: (ctx)=> CupertinoAlertDialog(
                            title: const Text('Invalid input'),
                            content: const Text(
                              'please make sure valid title, amount, date and category was entered.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Okay'),
                              ),
                            ],
                          ),):
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Invalid input'),
                            content: const Text(
                              'please make sure valid title, amount, date and category was entered.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Okay'),
                              ),
                            ],
                          ),
                        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                        prefixText: "\$",
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No Date Selected'
                              : formatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final firstDate = DateTime(
                              now.year - 1,
                              now.month,
                              now.day,
                            );
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: firstDate,
                              lastDate: now,
                            );
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (newCat) {
                      if (newCat == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = newCat;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final enteredAmount = double.tryParse(_amountController.text);
                      final bool amountIsInvalid =
                          enteredAmount == null || enteredAmount <= 0;
        
                      if (_titleController.text.trim().isEmpty ||
                          amountIsInvalid ||
                          _selectedDate == null) {
                            _showDialog();
                      } else {
                        widget.onAddExpense(
                          Expense(
                            title: _titleController.text,
                            amount: enteredAmount,
                            date: _selectedDate!,
                            category: _selectedCategory,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save Expense'),
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
