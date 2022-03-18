import 'package:car_wash/constans.dart';
import 'package:car_wash/models/order_model.dart';
import 'package:car_wash/provider/orders_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Order> myOrders = [];
  bool isLoading = false;
  OrdersProvider _ordersProvider = serviceLocator<OrdersProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMyOrders();
  }
  
  Future<void> fetchMyOrders() async {
    setState(() {
      isLoading = true;
    });
    List<Order> _order = await _ordersProvider.fetchAll(context);
    _order.sort((a, b) => b.date!.compareTo(a.date!) == 0 ? b.status == null ? 1 : b.date!.compareTo(a.date!) : b.date!.compareTo(a.date!));
    setState(() {
      myOrders = _order;
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: fetchMyOrders,
        child:Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(30)),
        child: Column(
            children: [
              Expanded(
                  child: isLoading
                      ?  Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ) : myOrders.length > 0
                      ? ListView.builder(
                      itemCount: myOrders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0x1A53B175),
                                    border: Border.all(
                                        width: 1,
                                        color: Color(0xB353B175)),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(20, 14, 20, 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/calendar_today.svg"),
                                          SizedBox(
                                            width:
                                            getProportionateScreenWidth(
                                                10),
                                          ),
                                          Text(
                                            "${DateFormat('yyyy-MM-dd').format(myOrders[index].date!)} ${myOrders[index].time!.hour < 10 ? '0${myOrders[index].time!.hour}' : myOrders[index].time!.hour}:${myOrders[index].time!.minute < 10 ? '0${myOrders[index].time!.minute}' : myOrders[index].time!.minute}",
                                            style: TextStyle(
                                                fontSize:
                                                getProportionateScreenWidth(
                                                    20),
                                                fontWeight: FontWeight.w800),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: getProportionateScreenWidth(
                                              10)),
                                      Row(
                                        children: [
                                          Container(
                                            width:
                                            getProportionateScreenWidth(
                                                150),
                                            child: Text(
                                              "${myOrders[index].carWashName!.name}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                  getProportionateScreenWidth(
                                                      16)),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "${myOrders[index].status == null ? 'Pending' : myOrders[index].status == 'ACCEPTED' ? 'ACCEPTED' : 'DECLINED'}",
                                              style: TextStyle(
                                                  color: myOrders[index].status ==
                                                      null
                                                      ? Colors.blue
                                                      : myOrders[index].status ==
                                                      "ACCEPTED"
                                                      ? Color(0xB353B175)
                                                      : myOrders[index]
                                                      .status ==
                                                      "DECLINED"
                                                      ? Colors.red
                                                      : Colors.blue,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                  getProportionateScreenWidth(
                                                      16)),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: getProportionateScreenWidth(
                                              10)),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/local_offer_black.svg"),
                                          SizedBox(
                                              width:
                                              getProportionateScreenWidth(
                                                  10)),
                                          Text(
                                            "${myOrders[index].price} tg",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize:
                                                getProportionateScreenWidth(
                                                    16)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: getProportionateScreenWidth(
                                              10)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        );
                      }) : Center(child: Text('No Orders'),)
              )])));
  }
}
