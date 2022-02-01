import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticketglass_mobile/src/providers/auth_state_provider.dart';
import 'package:ticketglass_mobile/src/services/auth_service.dart';
import 'package:ticketglass_mobile/src/widgets/buttons.dart';
import 'package:ticketglass_mobile/src/widgets/progress_indicator.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  // _logout() async{
  //     await AuthenticationService().signout();
  // }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authServicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.height ,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Expanded(child: SizedBox(height: 10,
            
            )),
            SizedBox(
              width: double.infinity,
              child: ButtonWidget(
                
                text: 'Logout',
                onPressed: () async {
                  customProgressIdicator(context);
                  await _auth.signout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                },
              ),
            ),
            // version
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text('version: 0.1', style: TextStyle(
                color: Colors.grey,
                fontSize: 16
              ),))
          
          ],
        ),
      ),
    );
  }
}
