import 'package:expenses/models/expense.dart';
import 'package:expenses/widgets/chart/chart.dart';
import 'package:expenses/widgets/expanses_list/expanses_list.dart';
import 'package:expenses/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _regesteredExpenses = [
    Expense(
      category: Category.work,
      title: 'Flutter Course',
      amount: 29.9,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.leisure,
      title: 'Cinema',
      amount: 9.71,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.food,
      title: 'Breakfast',
      amount: 31.3,
      date: DateTime.now(),
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _regesteredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _regesteredExpenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text(
        'No expenses found. Start adding some!',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    if (_regesteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        onRemoveExpense: _removeExpense,
        expenses: _regesteredExpenses,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Expense Tracker')),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (ctx) => NewExpense(onAddExpense: _addExpense),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Chart(expenses: _regesteredExpenses)),
                  Expanded(child: mainContent),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Chart(expenses: _regesteredExpenses)),
                  Expanded(child: mainContent),
                ],
              ),
      ),
    );
  }
}
