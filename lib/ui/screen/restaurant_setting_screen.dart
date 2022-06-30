import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/preference_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/provider/scheduling_provider.dart';
import 'package:restaurant_catalog_submission_akhir/resource/style/custom_style.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/custom_dialog_widget.dart';
import 'package:restaurant_catalog_submission_akhir/ui/widget/platform_widget.dart';

class RestaurantSettingScreen extends StatelessWidget {
  static const String routeName = '/restaurant_setting';

  const RestaurantSettingScreen({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting',
          style: appTextStyle,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Setting',
          style: appTextStyle,
        ),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: Text(
                  'Dark Theme',
                  style: subTitleTextStyle,
                ),
                trailing: Switch.adaptive(
                    value: provider.isDarkTheme,
                    onChanged: (value) {
                      provider.enableDarkTheme(value);
                    }),
              ),
            ),
            Material(
              child: ListTile(
                title: Text(
                  'Notification',
                  style: subTitleTextStyle,
                ),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                        value: scheduled.isScheduled,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            scheduled.scheduledReminder(value);
                          }
                        });
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
