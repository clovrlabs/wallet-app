import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/account/add_funds_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/add_funds_model.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_model.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/logger.dart';
import 'package:clovrlabs_wallet/services/breezlib/breez_bridge.dart';
import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:clovrlabs_wallet/services/permissions.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/colors_ext.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/styles/dev_screen_remote_confs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import '../../app/locator.dart';
import '../../widgets/styles/app_color_scheme.dart';
import '../../widgets/text_form_field_app.dart';
import 'default_commands.dart';

bool allowRebroadcastRefunds = false;
final _cliInputController = TextEditingController();
final FocusNode _cliEntryFocusNode = FocusNode();

class Choice {
  const Choice({this.title, this.icon, this.function});

  final String title;
  final IconData icon;
  final Function function;
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// ignore: must_be_immutable
class DevView extends StatefulWidget {
  BreezBridge _breezBridge;
  Permissions _permissionsService;

  DevView() {
    ServiceInjector injector = ServiceInjector();
    _breezBridge = injector.breezBridge;
    _permissionsService = injector.permissions;
  }

  void _select(Choice choice) {
    choice.function();
  }

  @override
  DevViewState createState() {
    return DevViewState();
  }
}

class DevViewState extends State<DevView> {
  static const FORCE_RESCAN_FILE_NAME = "FORCE_RESCAN";
  String _cliText = '';
  String _lastCommand = '';
  TextStyle _cliTextStyle = theme.smallTextStyle;

  var _richCliText = <TextSpan>[];

  bool _showDefaultCommands = true;

  @override
  void initState() {
    super.initState();
  }

  void _sendCommand(String command) {
    FocusScope.of(context).requestFocus(FocusNode());
    _lastCommand = command;
    widget._breezBridge.sendCommand(command).then((reply) {
      setState(() {
        _showDefaultCommands = false;
        _cliTextStyle = theme.smallTextStyle;
        _cliText = reply;
        _richCliText = <TextSpan>[
          TextSpan(text: _cliText),
        ];
      });
    }).catchError((error) {
      setState(() {
        _showDefaultCommands = false;
        _cliText = error;
        _cliTextStyle = theme.warningStyle;
        _richCliText = <TextSpan>[
          TextSpan(text: _cliText),
        ];
      });
    });
  }

  Widget _renderBody(DevScreenRemoteConfs remoteConfigs) {
    if (_showDefaultCommands) {
      return Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ListView(
              children: defaultCliCommandsText(
            (command) {
              _cliInputController.text = command + " ";
              FocusScope.of(_scaffoldKey.currentState.context)
                  .requestFocus(_cliEntryFocusNode);
            },
            remoteConfigs.txtItemColor.toColor(),
          )));
    }
    return ListView(
      children: [
        RichText(
            text: TextSpan(
                style: _cliTextStyle.copyWith(
                  color: remoteConfigs.txtItemColor.toColor(),
                ),
                children: _richCliText))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    UserProfileBloc userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final remoteConfigs = locator.get<AppConfigScheme>().devScreenRemoteConfs;

    return StreamBuilder<BackupState>(
      stream: backupBloc.backupStateStream,
      builder: (ctx, backupSnapshot) => StreamBuilder(
          stream: accBloc.accountStream,
          builder: (accCtx, accSnapshot) {
            AccountModel account = accSnapshot.data;
            return StreamBuilder(
                stream: accBloc.accountSettingsStream,
                builder: (context, settingsSnapshot) {
                  return StreamBuilder(
                      stream: addFundsBloc.addFundsSettingsStream,
                      builder: (context, addFundsSettingsSnapshot) {
                        return StreamBuilder<ClovrUserModel>(
                            stream: userBloc.userStream,
                            builder: (context, userSnapshot) {
                              return Scaffold(
                                key: _scaffoldKey,
                                appBar: AppBar(
                                  iconTheme:
                                      Theme.of(context).appBarTheme.iconTheme,
                                  backgroundColor:
                                      remoteConfigs.bgColor.toColor(),
                                  leading: backBtn.BackButton(
                                    color:
                                        remoteConfigs.backArrowColor.toColor(),
                                  ),
                                  elevation: 0.0,
                                  actions: <Widget>[
                                    PopupMenuButton<Choice>(
                                      onSelected: widget._select,
                                      color: remoteConfigs.colorContextMenu
                                          .toColor(),
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: remoteConfigs.colorContextMenu
                                            .toColor(),
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return getChoices(
                                                accBloc,
                                                settingsSnapshot.data,
                                                account,
                                                addFundsBloc,
                                                addFundsSettingsSnapshot.data,
                                                userBloc,
                                                userSnapshot.data)
                                            .map((Choice choice) {
                                          return PopupMenuItem<Choice>(
                                            value: choice,
                                            child: Text(choice.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ],
                                  title: Text(
                                    "Developers",
                                    // style: Theme.of(context)
                                    //     .appBarTheme
                                    //     .toolbarTextStyle
                                    //     .,
                                  ),
                                ),
                                backgroundColor:
                                    remoteConfigs.bgColor.toColor(),
                                body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                                child: TextFormFieldApp(
                                              focusNode: _cliEntryFocusNode,
                                              peerController:
                                                  _cliInputController,
                                              highlightColor: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                              hintColor: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                              label:
                                                  'Enter a command or use the links below',
                                              onChanged: (command) {
                                                _sendCommand(command);
                                              },
                                              indicatorColor: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                              primaryColor: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                              errorColor: remoteConfigs
                                                  .txtErrorColor
                                                  .toColor(),
                                              enabledBorder: remoteConfigs
                                                  .editTxt
                                                  .toColor(),
                                              disabledBorder: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                              cursorColor: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                              txtColor: remoteConfigs
                                                  .editTxtHint
                                                  .toColor(),
                                            )),
                                            IconButton(
                                              color: remoteConfigs
                                                  .btExecuteColor
                                                  .toColor(),
                                              icon: Icon(Icons.play_arrow),
                                              tooltip: 'Run',
                                              onPressed: () {
                                                _sendCommand(
                                                  _cliInputController.text,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              color: remoteConfigs.btCloseColor
                                                  .toColor(),
                                              icon: Icon(Icons.clear),
                                              tooltip: 'Clear',
                                              onPressed: () {
                                                setState(() {
                                                  _cliInputController.clear();
                                                  _showDefaultCommands = true;
                                                  _lastCommand = '';
                                                  _cliText = "";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 10.0,
                                                left: 10.0,
                                                right: 10.0),
                                            child: Container(
                                              padding: _showDefaultCommands
                                                  ? EdgeInsets.all(0.0)
                                                  : EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                border: _showDefaultCommands
                                                    ? null
                                                    : Border.all(
                                                        width: 1.0,
                                                        color: remoteConfigs
                                                            .bgColor
                                                            .toColor(),
                                                      ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  _showDefaultCommands
                                                      ? Container()
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .content_copy),
                                                              tooltip:
                                                                  'Copy to Clipboard',
                                                              iconSize: 19.0,
                                                              onPressed: () {
                                                                ServiceInjector()
                                                                    .device
                                                                    .setClipboardText(
                                                                        _cliText);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    'Copied to clipboard.',
                                                                    style: theme
                                                                        .snackBarStyle,
                                                                  ),
                                                                  backgroundColor:
                                                                      remoteConfigs
                                                                          .bgColor
                                                                          .toColor(),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                ));
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.share),
                                                              iconSize: 19.0,
                                                              tooltip: 'Share',
                                                              onPressed: () {
                                                                _shareFile(
                                                                    _lastCommand
                                                                        .split(
                                                                            " ")[0],
                                                                    _cliText);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                  Expanded(
                                                      child: _renderBody(
                                                          remoteConfigs))
                                                ],
                                              ),
                                            ),
                                          )),
                                    ]),
                              );
                            });
                      });
                });
          }),
    );
  }

  List<Choice> getChoices(
      AccountBloc accBloc,
      AccountSettings settings,
      AccountModel account,
      AddFundsBloc addFundsBloc,
      AddFundsSettings addFundsSettings,
      UserProfileBloc userBloc,
      ClovrUserModel userModel) {
    List<Choice> choices = <Choice>[];
    choices.addAll([
      Choice(title: 'Share Logs', icon: Icons.share, function: shareLog),
      // The code commented temporary
      /*
      Choice(
          title: 'Show Initial Screen',
          icon: Icons.phone_android,
          function: _gotoInitialScreen),
      Choice(
          title:
              '${settings.showConnectProgress ? "Hide" : "Show"} Connect Progress',
          icon: Icons.phone_android,
          function: () {
            toggleConnectProgress(accBloc, settings);
          }),
          */
      Choice(
          title: 'Describe Graph',
          icon: Icons.phone_android,
          function: _describeGraph),
      Choice(
          title: 'Update Graph',
          icon: Icons.phone_android,
          function: _refreshGraph),
      Choice(
          title: 'Download Graph',
          icon: Icons.phone_android,
          function: _downloadGraph),
    ]);

    // if (Platform.isAndroid) {
    //   choices.add(Choice(
    //       title: 'Battery Optimization',
    //       icon: Icons.phone_android,
    //       function: _showOptimizationsSettings));
    // }
    // if (settings.ignoreWalletBalance) {
    //   choices.add(Choice(
    //       title: "Show Excess Funds",
    //       icon: Icons.phone_android,
    //       function: () => _setShowExcessFunds(accBloc, settings)));
    // }
    if (settings.failedPaymentBehavior != BugReportBehavior.PROMPT) {
      choices.add(Choice(
          title: 'Reset Payment Report',
          icon: Icons.phone_android,
          function: () {
            _resetBugReportBehavior(accBloc, settings);
          }));
    }
    ;
    // choices.add(Choice(
    //     title:
    //         "${addFundsSettings.moonpayIpCheck ? "Disable" : "Enable"} MoonPay IP Check",
    //     icon: Icons.network_check,
    //     function: () => _enableMoonpayIpCheck(addFundsBloc, addFundsSettings)));
    // choices.add(Choice(
    //     title: 'Reset Refunds Status',
    //     icon: Icons.phone_android,
    //     function: () {
    //       allowRebroadcastRefunds = true;
    //     }));
    // choices.add(Choice(
    //     title: "Recover Chain Information",
    //     icon: Icons.phone_android,
    //     function: () async {
    //       ResetChainService resetAction = ResetChainService();
    //       accBloc.userActionsSink.add(resetAction);
    //       await resetAction.future;
    //       _promptForRestart();
    //     }));
    choices.add(Choice(
        title: "Refresh Private Channels",
        icon: Icons.phone_android,
        function: () async {
          await widget._breezBridge.populateChannePolicy();
        }));
    // choices.add(Choice(
    //     title: "Reset Unconfirmed Swap",
    //     icon: Icons.phone_android,
    //     function: () async {
    //       await widget._breezBridge.setNonBlockingUnconfirmedSwaps();
    //       await widget._breezBridge
    //           .resetUnconfirmedReverseSwapClaimTransaction();
    //     }));

    choices.add(Choice(
        title: "Export DB Files",
        icon: Icons.phone_android,
        function: () async {
          Directory tempDir = await getTemporaryDirectory();
          tempDir = await tempDir.createTemp("graph");
          var walletFiles =
              await ServiceInjector().breezBridge.getWalletDBpFilePath();
          var encoder = ZipFileEncoder();
          var zipFile = '${tempDir.path}/wallet-files.zip';
          encoder.create(zipFile);
          var i = 1;
          walletFiles.forEach((f) {
            var file = File(f);
            encoder.addFile(file,
                "${i.toString()}_${file.path.split(Platform.pathSeparator).last}");
            i += 1;
          });
          encoder.close();
          ShareExtend.share(zipFile, "file");
        }));

    // choices.add(Choice(
    //   title: "Export Product Catalog DB",
    //   icon: Icons.file_upload,
    //   function: () async {
    //     final databasePath = await getDatabasePath();
    //     ShareExtend.share(databasePath, "file");
    //   },
    // ));

    // choices.add(Choice(
    //   title: "Import Product Catalog DB",
    //   icon: Icons.file_download,
    //   function: () async {
    //     final fileResult = await FilePicker.platform.pickFiles(
    //       dialogTitle: "Select Product Catalog DB",
    //     );
    //     if (fileResult != null && fileResult.files.length > 0) {
    //       final file = fileResult.files.first;
    //       if (file.path.endsWith(".db")) {
    //         final databasePath = await getDatabasePath();
    //         await File(file.path).copy(databasePath);
    //       } else {
    //         log.warning("Invalid file type for product catalog DB");
    //       }
    //     } else {
    //       log.info("No file selected for product catalog DB");
    //     }
    //   },
    // ));

    // choices.add(Choice(
    //     title: "Set Height Hint",
    //     icon: Icons.phone_android,
    //     function: () async {
    //       final success = await Navigator.of(context).push(FadeInRoute(
    //         builder: (_) => SetHeightHintPage(),
    //       ));
    //       if (success == true) {
    //         _promptForRestart();
    //       }
    //     }));
    // choices.add(Choice(
    //     title: "Restore Channels",
    //     icon: Icons.phone_android,
    //     function: () async {
    //       _restoreChannelsBackup();
    //     }));
    // choices.add(Choice(
    //     title: 'Show Tutorials',
    //     icon: Icons.phone_android,
    //     function: () {
    //       UserProfileBloc bloc = AppBlocsProvider.of<UserProfileBloc>(context);
    //       bloc.userActionsSink.add(SetSeenPaymentStripTutorial(false));
    //     }));
    choices.add(Choice(
        title: 'Log Cache',
        icon: Icons.phone_android,
        function: _printCacheUsage));

    choices.add(Choice(
        title: 'Download Backup',
        icon: Icons.phone_android,
        function: () {
          _downloadSnapshot(accBloc);
        }));

    return choices;
  }

/*  void _gotoInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', true);
    Navigator.of(_scaffoldKey.currentState.context)
        .pushReplacementNamed("/splash");
  }*/

  void _shareFile(String command, String text) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("command");
    String filePath = '${tempDir.path}/$command.json';
    File file = File(filePath);
    await file.writeAsString(text, flush: true);
    ShareExtend.share(filePath, "file");
  }

  void _showOptimizationsSettings() async {
    widget._permissionsService.requestOptimizationSettings();
  }

  void toggleConnectProgress(AccountBloc bloc, AccountSettings settings) {
    bloc.accountSettingsSink.add(
        settings.copyWith(showConnectProgress: !settings.showConnectProgress));
  }

  void _resetBugReportBehavior(AccountBloc bloc, AccountSettings settings) {
    bloc.accountSettingsSink.add(
        settings.copyWith(failedPaymentBehavior: BugReportBehavior.PROMPT));
  }

  void _setShowExcessFunds(AccountBloc bloc, AccountSettings settings,
      {bool ignore = false}) {
    bloc.accountSettingsSink
        .add(settings.copyWith(ignoreWalletBalance: ignore));
  }

  void _enableMoonpayIpCheck(
      AddFundsBloc bloc, AddFundsSettings addFundsSettings) {
    bloc.addFundsSettingsSink.add(addFundsSettings.copyWith(
        moonpayIpCheck: !addFundsSettings.moonpayIpCheck));
  }

  void _restoreChannelsBackup() async {
    var filePath = await widget._breezBridge.getChanBackupPath();
    _sendCommand("restorechanbackup --multi_file $filePath");
  }

  void _describeGraph() async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("graph");
    bool userCancelled = false;
    String filePath = '${tempDir.path}/graph.json';
    Navigator.push(
            context,
            createLoaderRoute(context,
                message: "Generating graph data...", opacity: 0.8))
        .whenComplete(() => userCancelled = true);

    widget._breezBridge
        .sendCommand("describegraph $filePath --include_unannounced")
        .then((_) {
      var encoder = ZipFileEncoder();
      encoder.create('${tempDir.path}/graph.zip');
      encoder.addFile(File(filePath));
      encoder.close();
      File("${tempDir.path}/graph.json").deleteSync();
      if (!userCancelled) {
        return shareFile("${tempDir.path}/graph.zip");
      }
    }).whenComplete(() {
      if (!userCancelled) {
        Navigator.pop(context);
      }
    });
  }

  void _downloadSnapshot(AccountBloc accBloc) async {
    final nodeID = await accBloc.getPersistentNodeID();
    final downloaded = await widget._breezBridge.downloadBackup(nodeID);
    _shareBackup(downloaded.files);
  }

  Future _shareBackup(List<String> files) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("backup");
    var encoder = ZipFileEncoder();
    var zipFile = '${tempDir.path}/backup.zip';
    encoder.create(zipFile);
    files.forEach((f) {
      var file = File(f);
      encoder.addFile(file, "${file.path.split(Platform.pathSeparator).last}");
    });
    encoder.close();
    ShareExtend.share(zipFile, "file");
  }

  void _refreshGraph() async {
    await FlutterDownloader.cancelAll();
    await widget._breezBridge.deleteDownloads();
    Navigator.push(context,
        createLoaderRoute(context, message: "Deleting graph...", opacity: 0.8));
    widget._breezBridge.deleteGraph().whenComplete(() {
      Navigator.pop(context);
      // _promptForRestart();
    });
  }

  void _downloadGraph() async {
    await widget._breezBridge.syncGraphIfNeeded().whenComplete(() {
      log.info("download complete");
    });
  }

  void _printCacheUsage() async {
    Directory tempDir = await getTemporaryDirectory();
    var stats = await tempDir.stat();
    log.info("temp dir size = ${stats.size / 1024}kb");
    var children = tempDir.listSync();
    children.forEach((child) async {
      var childStats = await child.stat();
      var idDir = (child is Directory);
      log.info(
          '${idDir ? "Directory - " : "File - "} path: ${child.path}: ${childStats.size / 1024}kb');
      if (child is Directory) {
        var secondLevelChildren = child.listSync();
        secondLevelChildren.forEach((secondLevelChild) async {
          var idChildDir = (secondLevelChild is Directory);
          var secondLevelChildStats = await secondLevelChild.stat();
          log.info(
              "\t${idChildDir ? "Directory - " : "File - "} path: ${secondLevelChild.path}: ${secondLevelChildStats.size / 1024}kb");
        });
      }
    });
  }

  Future _promptForRestart() {
    return promptAreYouSure(
            context,
            null,
            Text("Please restart to resynchronize.",
                style: Theme.of(context).dialogTheme.contentTextStyle),
            cancelText: "CANCEL",
            okText: "EXIT")
        .then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return;
    });
  }
}
