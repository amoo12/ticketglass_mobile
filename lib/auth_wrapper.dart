import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticketglass_mobile/src/auth/login.dart';

import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'src/sample_feature/sample_item_list_view.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return either home or authenticate widget
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
      data: (value) {
        if (value != null) {
          return SampleItemListView();
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
