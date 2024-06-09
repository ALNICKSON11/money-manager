import 'package:flutter/material.dart';
import 'package:money_management_project/database/balance/balancedb_impl.dart';
import 'package:money_management_project/database/transaction/transactiondb_impl.dart';

class TransactionReport extends StatelessWidget {
  const TransactionReport({super.key});

  @override
  Widget build(BuildContext context) {
    BalanceDb.instance.refreshBalance();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Card(
              color: Colors.blue.shade100,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: ValueListenableBuilder<double>(
                  valueListenable: BalanceDb().updateBalanceNotifier,
                  builder: (BuildContext ctx, double updatedAmount, Widget? _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(' '),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Balance Amount:',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800),
                            ),
                            Text(
                              '${updatedAmount.toStringAsFixed(2)} ₹',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: updatedAmount <= 0.0
                                    ? Colors.red
                                    : Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                double? newBalance =
                                    await _showEditBalanceDialog(
                                        context, updatedAmount);
                                if (newBalance != null) {
                                  BalanceDb().modifyBalance(newBalance);
                                }
                              },
                              child: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.indigo.shade100,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Spending Report',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Total: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                          ValueListenableBuilder<double>(
                              valueListenable:
                                  TransactionDb.instance.todayNotifier,
                              builder: (BuildContext ctx, double todayValue,
                                  Widget? _) {
                                return Text(
                                  '${todayValue.toString()} ₹',
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                );
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "This Week's Total: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800),
                          ),
                          ValueListenableBuilder(
                              valueListenable:
                                  TransactionDb.instance.currentWeekNotifier,
                              builder: (BuildContext ctx, double weekValue,
                                  Widget? _) {
                                return Text(
                                  '${weekValue.toString()} ₹',
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                );
                              })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("This Month's Total: ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800)),
                          ValueListenableBuilder(
                              valueListenable: TransactionDb
                                  .instance.currrentMonthSpendNotifier,
                              builder: (BuildContext ctx, double monthValue,
                                  Widget? _) {
                                return Text(
                                  '${monthValue.toString()} ₹',
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                );
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<double?> _showEditBalanceDialog(BuildContext context, double currentBalance) {
    final editBalanceController =
        TextEditingController(text: currentBalance.toString());

    final _formKey = GlobalKey<FormState>();

    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Edit Balance'),
            content: TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter the amount';
                }
                final double? parsedAmount = double.tryParse(editBalanceController.text);
                if(parsedAmount == null){
                  return 'Only numbers are allowed';
                }
                return null;
              },
              controller: editBalanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Current Balance: $currentBalance',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue
                  )
                )
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  final newBalance = double.tryParse(editBalanceController.text);

                  if(_formKey.currentState?.validate() ?? false){
                    Navigator.of(context).pop(newBalance);
                  }
                },
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
