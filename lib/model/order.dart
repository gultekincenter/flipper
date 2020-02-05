import 'package:built_value/built_value.dart';

part 'order.g.dart';

abstract class Order implements Built<Order, OrderBuilder> {
  int get id;
  int get userId;
  int get branchId;
  int get orderNUmber;
  int get supplierId;
  int get subTotal;
  int get supplierInvoiceNumber;
  DateTime get deliverDate;
  int get taxRate;
  int get taxAmount;
  int get discountRate;
  int get discountAmount;
  int get cashReceived;
  int get saleTotal;
  int get customerSaving;
  int get paymentId;
  String get orderNote;
  String get status;
  int get customerChangeDue;
  Order._();
  factory Order([void Function(OrderBuilder) updates]) = _$Order;
}
