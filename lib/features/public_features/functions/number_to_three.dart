import 'package:intl/intl.dart';

final formatPattern = NumberFormat('#,###');

String getFormatPrice(String price){
  return formatPattern.format(double.parse(price));
}