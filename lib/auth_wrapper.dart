import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticketglass_mobile/src/auth/login.dart';
import 'package:ticketglass_mobile/src/organizer/events_list.dart';

import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/user_pages/events_list_view.dart';
import 'package:ticketglass_mobile/src/widgets/custom_toast.dart';
import 'src/user_pages/events_list_view.dart';

class Wrapper extends ConsumerWidget {
   Wrapper({Key? key}) : super(key: key);

  final FToast fToast = FToast();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return either home or authenticate widget
    final _authState = ref.watch(authStateProvider);



    return _authState.when(
      data: (user) {
        if (user != null) {
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
                  fToast.init(context);
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
