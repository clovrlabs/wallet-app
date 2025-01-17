import 'package:clovrlabs_wallet/bloc/connect_pay/connect_pay_model.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/wallet_avatar.dart';
import 'package:clovrlabs_wallet/widgets/delay_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'animations/pending_share.dart';
import 'animations/pulse_animation.dart';

/*
ConnectedPeer is a widget that shows both sides with presence awareness indicator.
*/
class ConnectedPeer extends StatelessWidget {
  final PaymentSessionState _paymentSessionData;
  final bool _renderPayer;
  final Function() _onShareInvite;

  const ConnectedPeer(
      this._renderPayer, this._paymentSessionData, this._onShareInvite);

  @override
  Widget build(BuildContext context) {
    String imageURL = _renderPayer
        ? _paymentSessionData.payerData.imageURL
        : _paymentSessionData.payeeData.imageURL;
    bool showShare = !_renderPayer &&
        !_me &&
        !_paymentSessionData.invitationSent &&
        imageURL == null;
    bool showAlien = !_renderPayer && imageURL == null;

    return Container(
        child: Column(children: <Widget>[
      Stack(alignment: AlignmentDirectional.center, children: <Widget>[
        Positioned(
            child: AnimatedOpacity(
                opacity: showShare && _paymentSessionData.invitationReady
                    ? 1.0
                    : 0.0,
                duration: Duration(milliseconds: 1000),
                child: PulseAnimationDecorator(Container(), 55.0, 45.0))),
        Positioned(
            child: AnimatedOpacity(
                duration: Duration(milliseconds: 1000),
                opacity: !showShare ? 1.0 : 0.0,
                child: UnknownAvatar())),
        Positioned(
            child: !showShare && !showAlien
                ? buildPeerAvatar(imageURL)
                : SizedBox()),
        Positioned(
            child: showShare
                ? _ShareInviteWidget(
                    !_paymentSessionData.invitationReady ||
                        _paymentSessionData.sessionSecret == null,
                    _onShareInvite)
                : SizedBox()),
        _paymentSessionData.invitationReady || _renderPayer
            ? Positioned(
                bottom: 25.0,
                right: 25.0,
                height: 24.0,
                width: 24.0,
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.white, width: 3.0),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                )))
            : SizedBox(),
        _paymentSessionData.invitationReady || _renderPayer || _online
            ? Positioned(
                bottom: 25.0,
                right: 25.0,
                height: 24.0,
                width: 24.0,
                child: _online
                    ? DelayRender(
                        duration:
                            PaymentSessionState.connectionEmulationDuration,
                        child: Container(
                            decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          border: Border.all(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        )))
                    : SizedBox())
            : SizedBox()
      ])
    ]));
  }

  Widget buildPeerAvatar(String imageURL) {
    if (_me || _renderPayer) {
      return ClovrLabsAvatar(imageURL,
          radius: 30.0, backgroundColor: theme.sessionAvatarBackgroundColor);
    }

    return AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: 1.0,
        child: ClovrLabsAvatar(imageURL,
            radius: 30.0, backgroundColor: theme.sessionAvatarBackgroundColor));
  }

  bool get _online => _renderPayer
      ? _paymentSessionData.payerData.status.online
      : _paymentSessionData.payeeData.status.online;

  bool get _me => _paymentSessionData.payer ? _renderPayer : !_renderPayer;
}

class _ShareInviteWidget extends StatelessWidget {
  final bool _loading;
  final Function() _onShareInvite;

  const _ShareInviteWidget(this._loading, this._onShareInvite);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: <Widget>[
      Positioned(
          child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: _loading ? 1.0 : 0.0,
        child: AvatarDecorator(
          PendingShareIndicator(),
        ),
      )),
      Positioned(
          child: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: _loading ? 0.0 : 1.0,
        child: AvatarDecorator(IconButton(
          icon: Icon(Icons.share, color: theme.ClovrLabsWalletColors.dark_grey[500]),
          onPressed: () => _onShareInvite(),
        )),
      ))
    ]);
  }
}

class AvatarDecorator extends StatelessWidget {
  final Widget child;

  const AvatarDecorator(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
            color: theme.sessionAvatarBackgroundColor, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: child,
        ));
  }
}

class UnknownAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AvatarDecorator(
      Image.asset("src/images/unknown.png"),
    );
  }
}
