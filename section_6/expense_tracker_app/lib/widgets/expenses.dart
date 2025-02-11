import 'package:conditional_parent_widget/conditional_parent_widget.dart';
import 'package:expense_tracker_app/data/expenses.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expenses_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../model/expense.dart';

final List<Expense> _dummyExpenses = [...registeredExpenses];

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _dummyExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _dummyExpenses.indexOf(expense);
    setState(() {
      _dummyExpenses.removeAt(expenseIndex);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _dummyExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isPortrait = width < 600;

    Widget mainContent = Center(
      child: Text('No expenses found. Start Adding some!'),
    );

    if (_dummyExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Flex(
        // if width is below 600, render Column
        // otherwise, render Row
        direction: isPortrait ? Axis.vertical : Axis.horizontal,
        children: [
          ConditionalParentWidget(
            condition: !isPortrait,
            parentBuilder: (child) => Expanded(child: child),
            child: Chart(expenses: _dummyExpenses),
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
