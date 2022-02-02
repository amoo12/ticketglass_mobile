import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketglass_mobile/src/models/event.dart';
import 'package:ticketglass_mobile/src/models/order.dart';
import 'package:ticketglass_mobile/src/widgets/custom_icons.dart';
import 'package:ticketglass_mobile/src/widgets/custom_toast.dart';

class TicketDetails extends StatelessWidget {
  TicketDetails({Key? key}) : super(key: key);

  static const routeName = '/ticket_details';
  FToast fToast = FToast();

  late Order order;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    order = args['order'] as Order;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.blueGrey[50],
            child: Material(
              color: Colors.blueGrey[50],
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: order.txId));
                  fToast.init(context);
                  showToast(fToast, 'copied to clipboard');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Order tx:',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Flexible(
                        child: Text(
                          order.txId.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.items[index].ticketType!.name!,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                CustomIcons.ticket_alt,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('QAR ' + order.items[index].ticketType!.price!)
                        ],
                      ),
                    ),
                    // leading: Text('fsdlkjfhs'),
                    subtitle: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(100)),
                      child: Text('NFT Index #' + order.items[index].nftIndex!),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.grey,
                  );
                },
                itemCount: order.items.length),
          ),
        ],
      ),
    );
  }
}
