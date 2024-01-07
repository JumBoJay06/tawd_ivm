// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get key {
    return Intl.message(
      'English',
      name: 'key',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Choose Language`
  String get language_choose_language {
    return Intl.message(
      'Choose Language',
      name: 'language_choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Finish Setting`
  String get language_finish_setting {
    return Intl.message(
      'Finish Setting',
      name: 'language_finish_setting',
      desc: '',
      args: [],
    );
  }

  /// `IVM Service`
  String get ivm_service {
    return Intl.message(
      'IVM Service',
      name: 'ivm_service',
      desc: '',
      args: [],
    );
  }

  /// `Device Connect`
  String get ivm_service_device_connect {
    return Intl.message(
      'Device Connect',
      name: 'ivm_service_device_connect',
      desc: '',
      args: [],
    );
  }

  /// `Paired Device`
  String get ivm_service_paired_device {
    return Intl.message(
      'Paired Device',
      name: 'ivm_service_paired_device',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth Off`
  String get ivm_service_ble_off {
    return Intl.message(
      'Bluetooth Off',
      name: 'ivm_service_ble_off',
      desc: '',
      args: [],
    );
  }

  /// `Please enable Bluetooth in your device's settings.`
  String get ivm_service_please_enable_ble {
    return Intl.message(
      'Please enable Bluetooth in your device\'s settings.',
      name: 'ivm_service_please_enable_ble',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get common_settings {
    return Intl.message(
      'Settings',
      name: 'common_settings',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get common_cancel {
    return Intl.message(
      'Cancel',
      name: 'common_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Avaliable Device`
  String get avaliable_device {
    return Intl.message(
      'Avaliable Device',
      name: 'avaliable_device',
      desc: '',
      args: [],
    );
  }

  /// `Device Searching`
  String get avaliable_device_searching {
    return Intl.message(
      'Device Searching',
      name: 'avaliable_device_searching',
      desc: '',
      args: [],
    );
  }

  /// `No devices found`
  String get avaliable_device_no_found {
    return Intl.message(
      'No devices found',
      name: 'avaliable_device_no_found',
      desc: '',
      args: [],
    );
  }

  /// `Re-search`
  String get avaliable_device_research {
    return Intl.message(
      'Re-search',
      name: 'avaliable_device_research',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get avaliable_device_search {
    return Intl.message(
      'Search',
      name: 'avaliable_device_search',
      desc: '',
      args: [],
    );
  }

  /// `Type device number to quickly find`
  String get avaliable_device_type_device_number_quickly_find_content {
    return Intl.message(
      'Type device number to quickly find',
      name: 'avaliable_device_type_device_number_quickly_find_content',
      desc: '',
      args: [],
    );
  }

  /// `Device paired`
  String get avaliable_device_paired {
    return Intl.message(
      'Device paired',
      name: 'avaliable_device_paired',
      desc: '',
      args: [],
    );
  }

  /// `Pairing Failed`
  String get avaliable_device_failed {
    return Intl.message(
      'Pairing Failed',
      name: 'avaliable_device_failed',
      desc: '',
      args: [],
    );
  }

  /// `Action Menu`
  String get common_action_menu {
    return Intl.message(
      'Action Menu',
      name: 'common_action_menu',
      desc: '',
      args: [],
    );
  }

  /// `Please retry to pair device.`
  String get avaliable_device_please_retry {
    return Intl.message(
      'Please retry to pair device.',
      name: 'avaliable_device_please_retry',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get common_ok {
    return Intl.message(
      'OK',
      name: 'common_ok',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get common_close {
    return Intl.message(
      'Close',
      name: 'common_close',
      desc: '',
      args: [],
    );
  }

  /// `No Paired Devices`
  String get avaliable_device_no_paired_device_content {
    return Intl.message(
      'No Paired Devices',
      name: 'avaliable_device_no_paired_device_content',
      desc: '',
      args: [],
    );
  }

  /// `Please connect a device first.`
  String get avaliable_device_please_connect_first_content {
    return Intl.message(
      'Please connect a device first.',
      name: 'avaliable_device_please_connect_first_content',
      desc: '',
      args: [],
    );
  }

  /// `The list shows devices ever been paired only.`
  String get avaliable_device_show_devices_paired_content {
    return Intl.message(
      'The list shows devices ever been paired only.',
      name: 'avaliable_device_show_devices_paired_content',
      desc: '',
      args: [],
    );
  }

  /// `Product Info`
  String get about_device_product_info {
    return Intl.message(
      'Product Info',
      name: 'about_device_product_info',
      desc: '',
      args: [],
    );
  }

  /// `Date of Manufacture`
  String get about_device_date_manufacture {
    return Intl.message(
      'Date of Manufacture',
      name: 'about_device_date_manufacture',
      desc: '',
      args: [],
    );
  }

  /// `Ball Valve ID`
  String get about_device_ball_id {
    return Intl.message(
      'Ball Valve ID',
      name: 'about_device_ball_id',
      desc: '',
      args: [],
    );
  }

  /// `Matching Date`
  String get about_device_matching_date {
    return Intl.message(
      'Matching Date',
      name: 'about_device_matching_date',
      desc: '',
      args: [],
    );
  }

  /// `Valve Info`
  String get about_device_info {
    return Intl.message(
      'Valve Info',
      name: 'about_device_info',
      desc: '',
      args: [],
    );
  }

  /// `Angle`
  String get about_device_angle {
    return Intl.message(
      'Angle',
      name: 'about_device_angle',
      desc: '',
      args: [],
    );
  }

  /// `Torque`
  String get about_device_torque {
    return Intl.message(
      'Torque',
      name: 'about_device_torque',
      desc: '',
      args: [],
    );
  }

  /// `Emission Detection`
  String get about_device_emission_detection {
    return Intl.message(
      'Emission Detection',
      name: 'about_device_emission_detection',
      desc: '',
      args: [],
    );
  }

  /// `Cycle Counter`
  String get about_device_cycle_counter {
    return Intl.message(
      'Cycle Counter',
      name: 'about_device_cycle_counter',
      desc: '',
      args: [],
    );
  }

  /// `IVM Total Use`
  String get about_device_total_use {
    return Intl.message(
      'IVM Total Use',
      name: 'about_device_total_use',
      desc: '',
      args: [],
    );
  }

  /// `time(s)`
  String get common_times {
    return Intl.message(
      'time(s)',
      name: 'common_times',
      desc: '',
      args: [],
    );
  }

  /// `Refreshed`
  String get about_device_refreshed {
    return Intl.message(
      'Refreshed',
      name: 'about_device_refreshed',
      desc: '',
      args: [],
    );
  }

  /// `Data Refreshed`
  String get about_device_date_refreshed {
    return Intl.message(
      'Data Refreshed',
      name: 'about_device_date_refreshed',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Failed`
  String get about_device_refreshed_failed {
    return Intl.message(
      'Refresh Failed',
      name: 'about_device_refreshed_failed',
      desc: '',
      args: [],
    );
  }

  /// `The data is up to date.`
  String get about_device_info_newest {
    return Intl.message(
      'The data is up to date.',
      name: 'about_device_info_newest',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get about_device_refresh {
    return Intl.message(
      'Refresh',
      name: 'about_device_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Data Refresh`
  String get about_device_data_refresh {
    return Intl.message(
      'Data Refresh',
      name: 'about_device_data_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Time last fetched from device.\nTo view new data, please refresh after 5 minutes again.`
  String get about_device_lastest_data_please_refresh_after_5_min_content {
    return Intl.message(
      'Time last fetched from device.\nTo view new data, please refresh after 5 minutes again.',
      name: 'about_device_lastest_data_please_refresh_after_5_min_content',
      desc: '',
      args: [],
    );
  }

  /// `Self Test`
  String get selt_test {
    return Intl.message(
      'Self Test',
      name: 'selt_test',
      desc: '',
      args: [],
    );
  }

  /// `Pass`
  String get common_pass {
    return Intl.message(
      'Pass',
      name: 'common_pass',
      desc: '',
      args: [],
    );
  }

  /// `Fail`
  String get common_fail {
    return Intl.message(
      'Fail',
      name: 'common_fail',
      desc: '',
      args: [],
    );
  }

  /// `RS485 Connection`
  String get selt_test_rs485_connection {
    return Intl.message(
      'RS485 Connection',
      name: 'selt_test_rs485_connection',
      desc: '',
      args: [],
    );
  }

  /// `Valve Position`
  String get selt_test_valve_position {
    return Intl.message(
      'Valve Position',
      name: 'selt_test_valve_position',
      desc: '',
      args: [],
    );
  }

  /// `Device faulty, contact manufacturer.`
  String get selt_test_device_faulty {
    return Intl.message(
      'Device faulty, contact manufacturer.',
      name: 'selt_test_device_faulty',
      desc: '',
      args: [],
    );
  }

  /// `IVM Service Temp.`
  String get selt_test_ivm_temp {
    return Intl.message(
      'IVM Service Temp.',
      name: 'selt_test_ivm_temp',
      desc: '',
      args: [],
    );
  }

  /// `Start Test`
  String get selt_test_start_test {
    return Intl.message(
      'Start Test',
      name: 'selt_test_start_test',
      desc: '',
      args: [],
    );
  }

  /// `Connection Lost`
  String get ble_connection_lost {
    return Intl.message(
      'Connection Lost',
      name: 'ble_connection_lost',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth disconnected. Please retry connecting to resume using the test feature.`
  String get ble_disconnected_content {
    return Intl.message(
      'Bluetooth disconnected. Please retry connecting to resume using the test feature.',
      name: 'ble_disconnected_content',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect Now`
  String get ble_reconnect_now {
    return Intl.message(
      'Reconnect Now',
      name: 'ble_reconnect_now',
      desc: '',
      args: [],
    );
  }

  /// `Back to Menu`
  String get common_back_menu {
    return Intl.message(
      'Back to Menu',
      name: 'common_back_menu',
      desc: '',
      args: [],
    );
  }

  /// `Unable Reconnect`
  String get ble_unable_reconnect {
    return Intl.message(
      'Unable Reconnect',
      name: 'ble_unable_reconnect',
      desc: '',
      args: [],
    );
  }

  /// `Please return to the start screen and redo the pairing process.`
  String get ble_plesae_return_start_screen_repairing_content {
    return Intl.message(
      'Please return to the start screen and redo the pairing process.',
      name: 'ble_plesae_return_start_screen_repairing_content',
      desc: '',
      args: [],
    );
  }

  /// `Back to Start`
  String get common_back_start {
    return Intl.message(
      'Back to Start',
      name: 'common_back_start',
      desc: '',
      args: [],
    );
  }

  /// `Self-Test in progress...`
  String get selt_test_in_progress {
    return Intl.message(
      'Self-Test in progress...',
      name: 'selt_test_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Test Completed`
  String get selt_test_completed {
    return Intl.message(
      'Test Completed',
      name: 'selt_test_completed',
      desc: '',
      args: [],
    );
  }

  /// `Status is up to date.`
  String get selt_test_status_newest {
    return Intl.message(
      'Status is up to date.',
      name: 'selt_test_status_newest',
      desc: '',
      args: [],
    );
  }

  /// `Self-Test Failed`
  String get selt_test_fail {
    return Intl.message(
      'Self-Test Failed',
      name: 'selt_test_fail',
      desc: '',
      args: [],
    );
  }

  /// `Please retry.`
  String get selt_test_please_retry {
    return Intl.message(
      'Please retry.',
      name: 'selt_test_please_retry',
      desc: '',
      args: [],
    );
  }

  /// `Operational Records`
  String get operational_records {
    return Intl.message(
      'Operational Records',
      name: 'operational_records',
      desc: '',
      args: [],
    );
  }

  /// `Current Valve`
  String get operational_records_current_valve {
    return Intl.message(
      'Current Valve',
      name: 'operational_records_current_valve',
      desc: '',
      args: [],
    );
  }

  /// `Past Valve`
  String get operational_records_past_valve {
    return Intl.message(
      'Past Valve',
      name: 'operational_records_past_valve',
      desc: '',
      args: [],
    );
  }

  /// `Record Chart`
  String get record_chart_ {
    return Intl.message(
      'Record Chart',
      name: 'record_chart_',
      desc: '',
      args: [],
    );
  }

  /// `Emission`
  String get record_chart_emission {
    return Intl.message(
      'Emission',
      name: 'record_chart_emission',
      desc: '',
      args: [],
    );
  }

  /// `This chart shows the last 300 records.`
  String get record_chart_last_300_records {
    return Intl.message(
      'This chart shows the last 300 records.',
      name: 'record_chart_last_300_records',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get common_date {
    return Intl.message(
      'Date',
      name: 'common_date',
      desc: '',
      args: [],
    );
  }

  /// `Traceability`
  String get traceability_ {
    return Intl.message(
      'Traceability',
      name: 'traceability_',
      desc: '',
      args: [],
    );
  }

  /// `Serial No. Required`
  String get traceability_required_serial_no {
    return Intl.message(
      'Serial No. Required',
      name: 'traceability_required_serial_no',
      desc: '',
      args: [],
    );
  }

  /// `Serial No.`
  String get traceability_serial_no {
    return Intl.message(
      'Serial No.',
      name: 'traceability_serial_no',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the serial number of your purchased product to check traceability.`
  String get traceability_please_enter_serial_no_conent {
    return Intl.message(
      'Please enter the serial number of your purchased product to check traceability.',
      name: 'traceability_please_enter_serial_no_conent',
      desc: '',
      args: [],
    );
  }

  /// `Serial No. Incorrect`
  String get traceability_serial_no_incorrect {
    return Intl.message(
      'Serial No. Incorrect',
      name: 'traceability_serial_no_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `The serial number could not be identified. Please double check the number on the device.`
  String get traceability_serial_number_could_not_identified_conent {
    return Intl.message(
      'The serial number could not be identified. Please double check the number on the device.',
      name: 'traceability_serial_number_could_not_identified_conent',
      desc: '',
      args: [],
    );
  }

  /// `Serical No. should contain 12 chars.`
  String get traceability_serial_no_should_12_chars_content {
    return Intl.message(
      'Serical No. should contain 12 chars.',
      name: 'traceability_serial_no_should_12_chars_content',
      desc: '',
      args: [],
    );
  }

  /// `Device Settings`
  String get device_settings_ {
    return Intl.message(
      'Device Settings',
      name: 'device_settings_',
      desc: '',
      args: [],
    );
  }

  /// `Setting Item`
  String get device_settings_item {
    return Intl.message(
      'Setting Item',
      name: 'device_settings_item',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get device_settings_unit {
    return Intl.message(
      'Unit',
      name: 'device_settings_unit',
      desc: '',
      args: [],
    );
  }

  /// `Limit`
  String get device_settings_limit {
    return Intl.message(
      'Limit',
      name: 'device_settings_limit',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get device_settings__open {
    return Intl.message(
      'Open',
      name: 'device_settings__open',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get device_settings_close {
    return Intl.message(
      'Close',
      name: 'device_settings_close',
      desc: '',
      args: [],
    );
  }

  /// `Alert Value`
  String get device_settings_alert_value {
    return Intl.message(
      'Alert Value',
      name: 'device_settings_alert_value',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get common_save {
    return Intl.message(
      'Save',
      name: 'common_save',
      desc: '',
      args: [],
    );
  }

  /// `Valve Torque`
  String get device_settings_valve_torque {
    return Intl.message(
      'Valve Torque',
      name: 'device_settings_valve_torque',
      desc: '',
      args: [],
    );
  }

  /// `Once the value of torque is below or above the set value, the LED indicator will show abnormal light.`
  String get device_settings_valve_torque_abnormal_content {
    return Intl.message(
      'Once the value of torque is below or above the set value, the LED indicator will show abnormal light.',
      name: 'device_settings_valve_torque_abnormal_content',
      desc: '',
      args: [],
    );
  }

  /// `Emission Detection`
  String get device_settings_emission_detection {
    return Intl.message(
      'Emission Detection',
      name: 'device_settings_emission_detection',
      desc: '',
      args: [],
    );
  }

  /// `Once the value of emission is below or above the set value, the LED indicator will show abnormal light.`
  String get device_settings_emission_detection_abnormal {
    return Intl.message(
      'Once the value of emission is below or above the set value, the LED indicator will show abnormal light.',
      name: 'device_settings_emission_detection_abnormal',
      desc: '',
      args: [],
    );
  }

  /// `Min. value`
  String get device_settings_min {
    return Intl.message(
      'Min. value',
      name: 'device_settings_min',
      desc: '',
      args: [],
    );
  }

  /// `Max. value`
  String get device_settings_max {
    return Intl.message(
      'Max. value',
      name: 'device_settings_max',
      desc: '',
      args: [],
    );
  }

  /// `Factory default`
  String get device_settings_factory_default {
    return Intl.message(
      'Factory default',
      name: 'device_settings_factory_default',
      desc: '',
      args: [],
    );
  }

  /// `Valve Position`
  String get device_settings_valve_position {
    return Intl.message(
      'Valve Position',
      name: 'device_settings_valve_position',
      desc: '',
      args: [],
    );
  }

  /// `Angle Setting`
  String get device_settings_angle_setting {
    return Intl.message(
      'Angle Setting',
      name: 'device_settings_angle_setting',
      desc: '',
      args: [],
    );
  }

  /// `The device will record each valve opening and closing operation based on the configured opening and closing angle thresholds.`
  String get device_settings_angle_setting_content {
    return Intl.message(
      'The device will record each valve opening and closing operation based on the configured opening and closing angle thresholds.',
      name: 'device_settings_angle_setting_content',
      desc: '',
      args: [],
    );
  }

  /// `Closing Angle`
  String get device_settings_closing_angle {
    return Intl.message(
      'Closing Angle',
      name: 'device_settings_closing_angle',
      desc: '',
      args: [],
    );
  }

  /// `Opening Angle`
  String get device_settings_opening_angle {
    return Intl.message(
      'Opening Angle',
      name: 'device_settings_opening_angle',
      desc: '',
      args: [],
    );
  }

  /// `Device Lacation`
  String get device_settings_device_lacation {
    return Intl.message(
      'Device Lacation',
      name: 'device_settings_device_lacation',
      desc: '',
      args: [],
    );
  }

  /// `Add lacation description to improve device identification. (Limit 80 chars)`
  String get device_settings_device_lacation_content {
    return Intl.message(
      'Add lacation description to improve device identification. (Limit 80 chars)',
      name: 'device_settings_device_lacation_content',
      desc: '',
      args: [],
    );
  }

  /// `Add lacation description here`
  String get device_settings_add_description {
    return Intl.message(
      'Add lacation description here',
      name: 'device_settings_add_description',
      desc: '',
      args: [],
    );
  }

  /// `LED indicator`
  String get device_settings_led_indicator {
    return Intl.message(
      'LED indicator',
      name: 'device_settings_led_indicator',
      desc: '',
      args: [],
    );
  }

  /// `Set different colors for each status (except Fault status) to improve action identification.`
  String get device_settings_led_indicator_conent {
    return Intl.message(
      'Set different colors for each status (except Fault status) to improve action identification.',
      name: 'device_settings_led_indicator_conent',
      desc: '',
      args: [],
    );
  }

  /// `Abnormal / Fault`
  String get device_settings_led_abnormal {
    return Intl.message(
      'Abnormal / Fault',
      name: 'device_settings_led_abnormal',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance notify`
  String get device_settings_led_maintenande_notify {
    return Intl.message(
      'Maintenance notify',
      name: 'device_settings_led_maintenande_notify',
      desc: '',
      args: [],
    );
  }

  /// `Valve Open`
  String get device_settings_led_valve_open {
    return Intl.message(
      'Valve Open',
      name: 'device_settings_led_valve_open',
      desc: '',
      args: [],
    );
  }

  /// `Value Close`
  String get device_settings_led_valve_close {
    return Intl.message(
      'Value Close',
      name: 'device_settings_led_valve_close',
      desc: '',
      args: [],
    );
  }

  /// `RS485 Disconnected`
  String get device_settings_led_rs485_disconnected {
    return Intl.message(
      'RS485 Disconnected',
      name: 'device_settings_led_rs485_disconnected',
      desc: '',
      args: [],
    );
  }

  /// `RS485 Connected`
  String get device_settings_led_rs485_connected {
    return Intl.message(
      'RS485 Connected',
      name: 'device_settings_led_rs485_connected',
      desc: '',
      args: [],
    );
  }

  /// `BLE Disconnected`
  String get device_settings_led_ble_disconnected {
    return Intl.message(
      'BLE Disconnected',
      name: 'device_settings_led_ble_disconnected',
      desc: '',
      args: [],
    );
  }

  /// `BLE Connected`
  String get device_settings_led_ble_connected {
    return Intl.message(
      'BLE Connected',
      name: 'device_settings_led_ble_connected',
      desc: '',
      args: [],
    );
  }

  /// `Short Flash`
  String get device_settings_led_short_flash {
    return Intl.message(
      'Short Flash',
      name: 'device_settings_led_short_flash',
      desc: '',
      args: [],
    );
  }

  /// `Long Flash`
  String get device_settings_led_long_flash {
    return Intl.message(
      'Long Flash',
      name: 'device_settings_led_long_flash',
      desc: '',
      args: [],
    );
  }

  /// `Constant`
  String get device_settings_led_constant {
    return Intl.message(
      'Constant',
      name: 'device_settings_led_constant',
      desc: '',
      args: [],
    );
  }

  /// `Breathing`
  String get device_settings_led_breathing {
    return Intl.message(
      'Breathing',
      name: 'device_settings_led_breathing',
      desc: '',
      args: [],
    );
  }

  /// `FW Update`
  String get fw_update {
    return Intl.message(
      'FW Update',
      name: 'fw_update',
      desc: '',
      args: [],
    );
  }

  /// `Firmware version`
  String get fw_update_version {
    return Intl.message(
      'Firmware version',
      name: 'fw_update_version',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get fw_update_update {
    return Intl.message(
      'Update',
      name: 'fw_update_update',
      desc: '',
      args: [],
    );
  }

  /// `Last updated date`
  String get fw_update_last_updated_date {
    return Intl.message(
      'Last updated date',
      name: 'fw_update_last_updated_date',
      desc: '',
      args: [],
    );
  }

  /// `Select file to update`
  String get fw_update_select_file_content {
    return Intl.message(
      'Select file to update',
      name: 'fw_update_select_file_content',
      desc: '',
      args: [],
    );
  }

  /// `Select file`
  String get fw_update_select_file {
    return Intl.message(
      'Select file',
      name: 'fw_update_select_file',
      desc: '',
      args: [],
    );
  }

  /// `Format Error`
  String get fw_update_file_error {
    return Intl.message(
      'Format Error',
      name: 'fw_update_file_error',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect file format. Please select a .bin file.`
  String get fw_update_file_error_content {
    return Intl.message(
      'Incorrect file format. Please select a .bin file.',
      name: 'fw_update_file_error_content',
      desc: '',
      args: [],
    );
  }

  /// `Firmware Update`
  String get fw_update_dialog_title {
    return Intl.message(
      'Firmware Update',
      name: 'fw_update_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Update firmware to ...?`
  String get fw_update_dialog_content {
    return Intl.message(
      'Update firmware to ...?',
      name: 'fw_update_dialog_content',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Update Now`
  String get fw_update_dialog_yes {
    return Intl.message(
      'Yes, Update Now',
      name: 'fw_update_dialog_yes',
      desc: '',
      args: [],
    );
  }

  /// `No, Later`
  String get fw_update_dialog_no {
    return Intl.message(
      'No, Later',
      name: 'fw_update_dialog_no',
      desc: '',
      args: [],
    );
  }

  /// `Updating firmware...`
  String get fw_update_updating {
    return Intl.message(
      'Updating firmware...',
      name: 'fw_update_updating',
      desc: '',
      args: [],
    );
  }

  /// `Update Completed`
  String get fw_update_completed {
    return Intl.message(
      'Update Completed',
      name: 'fw_update_completed',
      desc: '',
      args: [],
    );
  }

  /// `Firmware is up to date.`
  String get fw_update_version_is_newest {
    return Intl.message(
      'Firmware is up to date.',
      name: 'fw_update_version_is_newest',
      desc: '',
      args: [],
    );
  }

  /// `Update Failed`
  String get fw_update_fail {
    return Intl.message(
      'Update Failed',
      name: 'fw_update_fail',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
