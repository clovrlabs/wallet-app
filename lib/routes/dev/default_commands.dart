import 'package:clovrlabs_wallet/utils/colors_ext.dart';
import 'package:flutter/material.dart';

import '../../app/locator.dart';
import '../../widgets/styles/app_color_scheme.dart';

class Command extends StatelessWidget {
  final String command;
  final Function(String command) onTap;
  final remoteConfigs = locator.get<AppConfigScheme>().devScreenRemoteConfs;

  Command(this.command, this.onTap, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          this.onTap(command);
        },
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Text(
              command,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: remoteConfigs.txtSubItemColor.toColor(),
              ),
            )));
  }
}

class Category extends StatelessWidget {
  final String name;

  const Category(this.name, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(name, style: Theme.of(context).textTheme.headline6);
  }
}

List<Widget> defaultCliCommandsText(
        Function(String command) onCommand, Color color) =>
    [
      ExpansionTile(
          iconColor: color,
          title: Text(
            "General",
            style: (TextStyle(color: color)),
          ),
          children: <Widget>[
            Command("getinfo", onCommand),
            Command("debuglevel", onCommand),
            Command("stop", onCommand),
          ]),
      ExpansionTile(
          iconColor: color,
          title: Text(
            "Channels",
            style: (TextStyle(color: color)),
          ),
          children: <Widget>[
            Command("openchannel", onCommand),
            Command("closechannel", onCommand),
            Command("closeallchannels", onCommand),
            Command("abandonchannel", onCommand),
            Command("channelbalance", onCommand),
            Command("pendingchannels", onCommand),
            Command("listchannels", onCommand),
            Command("closedchannels", onCommand),
            Command("getchaninfo", onCommand),
            Command("getnetworkinfo", onCommand),
            Command("feereport", onCommand),
            Command("updatechanpolicy", onCommand),
          ]),
      ExpansionTile(
          iconColor: color,
          title: Text(
            "On-chain",
            style: (TextStyle(color: color)),
          ),
          children: <Widget>[
            Command("estimatefee", onCommand),
            Command("sendmany", onCommand),
            Command("listunspent", onCommand),
            Command("listchaintxns", onCommand),
          ]),
      ExpansionTile(
          iconColor: color,
          title: Text(
            "Payments",
            style: (TextStyle(color: color)),
          ),
          children: <Widget>[
            Command("sendpayment", onCommand),
            Command("payinvoice", onCommand),
            Command("sendtoroute", onCommand),
            Command("addinvoice", onCommand),
            Command("lookupinvoice", onCommand),
            Command("listinvoices", onCommand),
            Command("queryroutes", onCommand),
            Command("decodepayreq", onCommand),
            Command("fwdinghistory", onCommand),
            Command("querymc", onCommand),
            Command("queryprob", onCommand),
            Command("resetmc", onCommand),
            Command("buildroute", onCommand),
            Command("cancelinvoice", onCommand),
            Command("addholdinvoice", onCommand),
            Command("settleinvoice", onCommand),
          ]),
      ExpansionTile(
          title: Text(
            "Peers",
            style: (TextStyle(color: color)),
          ),
          children: <Widget>[
            Command("connect", onCommand),
            Command("disconnect", onCommand),
            Command("listpeers", onCommand),
            Command("describegraph", onCommand),
            Command("getnodeinfo", onCommand),
          ]),
      ExpansionTile(
          title: Text(
            "Wallet",
            style: (TextStyle(color: color)),
          ),
          children: <Widget>[
            Command("newaddress", onCommand),
            Command("walletbalance", onCommand),
            Command("signmessage", onCommand),
            Command("verifymessage", onCommand),
            Command("wallet pendingsweeps", onCommand),
            Command("wallet bumpfee", onCommand)
          ]),
    ];
