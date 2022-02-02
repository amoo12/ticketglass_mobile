import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketglass_mobile/src/auth/login.dart';
import 'package:ticketglass_mobile/src/organizer/events_list.dart';

import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/providers/connection_state_provider.dart';
import 'package:ticketglass_mobile/src/user_pages/events_list_view.dart';
import 'package:ticketglass_mobile/src/widgets/connection_snackbar.dart';
import 'package:ticketglass_mobile/src/widgets/custom_toast.dart';
import 'src/user_pages/events_list_view.dart';

class Wrapper extends ConsumerStatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  final FToast fToast = FToast();

  late StreamSubscription _connectionChangeStream;
  bool isOffline = false;
  void connectionChanged(dynamic hasConnection) {
if (hasConnection == false) {
      connectionSnackbar(context, false);
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      connectionSnackbar(context, true);
    }
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  void initState() {
    super.initState();
    fToast.init(context);

    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  @override
  Widget build(BuildContext context) {
    // return either home or authenticate widget

    final _authState = ref.watch(authStateProvider);

    return _authState.when(
      data: (user) {
        if (user != null) {
          // if (!isOffline) {
          return FutureBuilder<IdTokenResult>(
              future: user.getIdTokenResult(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  IdTokenResult idTokenResult = snapshot.data!;
                  if (idTokenResult.claims?['admin'] == true ||
                      idTokenResult.claims?['organizer'] == true) {
                    return EventsList();
                  } else {
                    return OrdersList();
                  }
                } else if (snapshot.hasError) {
                  showToast(fToast, 'something went wrong! try again');
                  return Login();
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              });
        }
        //   connectionSnackbar(context);
        //   return null;
        // }
        return Login();
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (_, __) {
        return const Scaffold(
          body: Center(
            child: Text("OOPS"),
          ),
        );
      },
    );
  }
}

