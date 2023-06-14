class Voucherclass {
  final String voucherName;
  final String amount;
  final DateTime startDate;
  final DateTime expiryDate;
  final String vstatus;

  Voucherclass({
    required this.voucherName,
    required this.amount,
    required this.startDate,
    required this.expiryDate,
    required this.vstatus,  
  });
}