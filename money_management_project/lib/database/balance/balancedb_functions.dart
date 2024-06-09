

abstract class BalancedbFunctions{

  Future<double> getBalance();

  Future<void> addBalance(double amount);

  Future<void> substractBalance(double amount);

  Future<void> modifyBalance(double amount);

}