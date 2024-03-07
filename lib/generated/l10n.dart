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

  /// `Select language`
  String get language_choose_language {
    return Intl.message(
      'Select language',
      name: 'language_choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Setup complete`
  String get language_finish_setting {
    return Intl.message(
      'Setup complete',
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

  /// `Connect device`
  String get ivm_service_device_connect {
    return Intl.message(
      'Connect device',
      name: 'ivm_service_device_connect',
      desc: '',
      args: [],
    );
  }

  /// `Paired devices`
  String get ivm_service_paired_device {
    return Intl.message(
      'Paired devices',
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

  /// `Please turn on Bluetooth.`
  String get ivm_service_please_enable_ble {
    return Intl.message(
      'Please turn on Bluetooth.',
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

  /// `Available Devices`
  String get available_device {
    return Intl.message(
      'Available Devices',
      name: 'available_device',
      desc: '',
      args: [],
    );
  }

  /// `Searching`
  String get available_device_searching {
    return Intl.message(
      'Searching',
      name: 'available_device_searching',
      desc: '',
      args: [],
    );
  }

  /// `No available devices`
  String get available_device_no_found {
    return Intl.message(
      'No available devices',
      name: 'available_device_no_found',
      desc: '',
      args: [],
    );
  }

  /// `Search again`
  String get available_device_research {
    return Intl.message(
      'Search again',
      name: 'available_device_research',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get available_device_search {
    return Intl.message(
      'Search',
      name: 'available_device_search',
      desc: '',
      args: [],
    );
  }

  /// `Enter device number for quick search`
  String get available_device_type_device_number_quickly_find_content {
    return Intl.message(
      'Enter device number for quick search',
      name: 'available_device_type_device_number_quickly_find_content',
      desc: '',
      args: [],
    );
  }

  /// `Pairing Successful`
  String get available_device_paired {
    return Intl.message(
      'Pairing Successful',
      name: 'available_device_paired',
      desc: '',
      args: [],
    );
  }

  /// `Pairing Failed`
  String get available_device_failed {
    return Intl.message(
      'Pairing Failed',
      name: 'available_device_failed',
      desc: '',
      args: [],
    );
  }

  /// `Action menu`
  String get common_action_menu {
    return Intl.message(
      'Action menu',
      name: 'common_action_menu',
      desc: '',
      args: [],
    );
  }

  /// `Set Ball Valve ID`
  String get available_device_set_ball_id {
    return Intl.message(
      'Set Ball Valve ID',
      name: 'available_device_set_ball_id',
      desc: '',
      args: [],
    );
  }

  /// `Please re-pair the device.`
  String get available_device_please_retry {
    return Intl.message(
      'Please re-pair the device.',
      name: 'available_device_please_retry',
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
  String get available_device_no_paired_device_content {
    return Intl.message(
      'No Paired Devices',
      name: 'available_device_no_paired_device_content',
      desc: '',
      args: [],
    );
  }

  /// `Please connect a device first.`
  String get available_device_please_connect_first_content {
    return Intl.message(
      'Please connect a device first.',
      name: 'available_device_please_connect_first_content',
      desc: '',
      args: [],
    );
  }

  /// `This list only shows previously paired devices.`
  String get available_device_show_devices_paired_content {
    return Intl.message(
      'This list only shows previously paired devices.',
      name: 'available_device_show_devices_paired_content',
      desc: '',
      args: [],
    );
  }

  /// `Ball Valve Setting`
  String get ball_valve_setting {
    return Intl.message(
      'Ball Valve Setting',
      name: 'ball_valve_setting',
      desc: '',
      args: [],
    );
  }

  /// `To set the Ball Valve ID to record data correctly.`
  String get ball_valve_setting_set_id_content {
    return Intl.message(
      'To set the Ball Valve ID to record data correctly.',
      name: 'ball_valve_setting_set_id_content',
      desc: '',
      args: [],
    );
  }

  /// `The ID cannot be edited after setting.`
  String get ball_valve_setting_id_cannot_edited {
    return Intl.message(
      'The ID cannot be edited after setting.',
      name: 'ball_valve_setting_id_cannot_edited',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message(
      'Notice',
      name: 'notice',
      desc: '',
      args: [],
    );
  }

  /// `Settings are not saved. Are you sure to skip?`
  String get ball_valve_setting_save_skip_content {
    return Intl.message(
      'Settings are not saved. Are you sure to skip?',
      name: 'ball_valve_setting_save_skip_content',
      desc: '',
      args: [],
    );
  }

  /// `Yes, skip to menu`
  String get ball_valve_setting_yes_and_skip {
    return Intl.message(
      'Yes, skip to menu',
      name: 'ball_valve_setting_yes_and_skip',
      desc: '',
      args: [],
    );
  }

  /// `Setting Confirm`
  String get ball_valve_setting_comfirm {
    return Intl.message(
      'Setting Confirm',
      name: 'ball_valve_setting_comfirm',
      desc: '',
      args: [],
    );
  }

  /// `Is the Ball Valve ID correct?`
  String get ball_valve_setting_is_id_correct {
    return Intl.message(
      'Is the Ball Valve ID correct?',
      name: 'ball_valve_setting_is_id_correct',
      desc: '',
      args: [],
    );
  }

  /// `Yes, confirm setting`
  String get ball_valve_setting_confirm_setting {
    return Intl.message(
      'Yes, confirm setting',
      name: 'ball_valve_setting_confirm_setting',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter`
  String get ball_valve_setting_reenter {
    return Intl.message(
      'Re-enter',
      name: 'ball_valve_setting_reenter',
      desc: '',
      args: [],
    );
  }

  /// `Device Information`
  String get about_device {
    return Intl.message(
      'Device Information',
      name: 'about_device',
      desc: '',
      args: [],
    );
  }

  /// `Temp. Abnormal`
  String get ball_valve_setting_temp_abnormal {
    return Intl.message(
      'Temp. Abnormal',
      name: 'ball_valve_setting_temp_abnormal',
      desc: '',
      args: [],
    );
  }

  /// `The device's temperature is abnormally high. Please contact the manufacturer.`
  String get ball_valve_setting_temp_higher {
    return Intl.message(
      'The device\'s temperature is abnormally high. Please contact the manufacturer.',
      name: 'ball_valve_setting_temp_higher',
      desc: '',
      args: [],
    );
  }

  /// `The Ball Valve usage reached maintenance threshold. Please perform required maintenance, then reset cycle count when complete.`
  String get ball_valve_setting_maintenance_threshold {
    return Intl.message(
      'The Ball Valve usage reached maintenance threshold. Please perform required maintenance, then reset cycle count when complete.',
      name: 'ball_valve_setting_maintenance_threshold',
      desc: '',
      args: [],
    );
  }

  /// `Product info.`
  String get about_device_product_info {
    return Intl.message(
      'Product info.',
      name: 'about_device_product_info',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturing date`
  String get about_device_date_manufacture {
    return Intl.message(
      'Manufacturing date',
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

  /// `Pairing date`
  String get about_device_matching_date {
    return Intl.message(
      'Pairing date',
      name: 'about_device_matching_date',
      desc: '',
      args: [],
    );
  }

  /// `Valve info.`
  String get about_device_info {
    return Intl.message(
      'Valve info.',
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

  /// `Cycle counter`
  String get about_device_cycle_counter {
    return Intl.message(
      'Cycle counter',
      name: 'about_device_cycle_counter',
      desc: '',
      args: [],
    );
  }

  /// `IVM total use`
  String get about_device_total_use {
    return Intl.message(
      'IVM total use',
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

  /// `This is the latest data.`
  String get about_device_info_newest {
    return Intl.message(
      'This is the latest data.',
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

  /// `Refresh Data`
  String get about_device_data_refresh {
    return Intl.message(
      'Refresh Data',
      name: 'about_device_data_refresh',
      desc: '',
      args: [],
    );
  }

  /// `The displayed time is the most recent data retrieved from the device. To view new data, please refresh again in 5 minutes.`
  String get about_device_lastest_data_please_refresh_after_5_min_content {
    return Intl.message(
      'The displayed time is the most recent data retrieved from the device. To view new data, please refresh again in 5 minutes.',
      name: 'about_device_lastest_data_please_refresh_after_5_min_content',
      desc: '',
      args: [],
    );
  }

  /// `Automated Testing`
  String get auto_test {
    return Intl.message(
      'Automated Testing',
      name: 'auto_test',
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

  /// `Failed`
  String get common_fail {
    return Intl.message(
      'Failed',
      name: 'common_fail',
      desc: '',
      args: [],
    );
  }

  /// `RS485 Connection`
  String get auto_test_rs485_connection {
    return Intl.message(
      'RS485 Connection',
      name: 'auto_test_rs485_connection',
      desc: '',
      args: [],
    );
  }

  /// `Valve Position`
  String get auto_test_valve_position {
    return Intl.message(
      'Valve Position',
      name: 'auto_test_valve_position',
      desc: '',
      args: [],
    );
  }

  /// `Device faulty, please contact manufacturer.`
  String get auto_test_device_faulty {
    return Intl.message(
      'Device faulty, please contact manufacturer.',
      name: 'auto_test_device_faulty',
      desc: '',
      args: [],
    );
  }

  /// `IVM Temp.`
  String get auto_test_ivm_temp {
    return Intl.message(
      'IVM Temp.',
      name: 'auto_test_ivm_temp',
      desc: '',
      args: [],
    );
  }

  /// `Start test`
  String get auto_test_start_test {
    return Intl.message(
      'Start test',
      name: 'auto_test_start_test',
      desc: '',
      args: [],
    );
  }

  /// `Connection Interrupted`
  String get ble_connection_lost {
    return Intl.message(
      'Connection Interrupted',
      name: 'ble_connection_lost',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth disconnected. Please retry the connection to use the system's automated testing function.`
  String get ble_disconnected_content {
    return Intl.message(
      'Bluetooth disconnected. Please retry the connection to use the system\'s automated testing function.',
      name: 'ble_disconnected_content',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect now`
  String get ble_reconnect_now {
    return Intl.message(
      'Reconnect now',
      name: 'ble_reconnect_now',
      desc: '',
      args: [],
    );
  }

  /// `Back to menu`
  String get common_back_menu {
    return Intl.message(
      'Back to menu',
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

  /// `Please return to the start page and redo the Bluetooth pairing process.`
  String get ble_plesae_return_start_screen_repairing_content {
    return Intl.message(
      'Please return to the start page and redo the Bluetooth pairing process.',
      name: 'ble_plesae_return_start_screen_repairing_content',
      desc: '',
      args: [],
    );
  }

  /// `Back to start`
  String get common_back_start {
    return Intl.message(
      'Back to start',
      name: 'common_back_start',
      desc: '',
      args: [],
    );
  }

  /// `Automated testing  in progress…`
  String get auto_test_in_progress {
    return Intl.message(
      'Automated testing  in progress…',
      name: 'auto_test_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Test Completed`
  String get auto_test_completed {
    return Intl.message(
      'Test Completed',
      name: 'auto_test_completed',
      desc: '',
      args: [],
    );
  }

  /// `Up-to-date status.`
  String get auto_test_status_newest {
    return Intl.message(
      'Up-to-date status.',
      name: 'auto_test_status_newest',
      desc: '',
      args: [],
    );
  }

  /// `Automated testing Failed`
  String get auto_test_fail {
    return Intl.message(
      'Automated testing Failed',
      name: 'auto_test_fail',
      desc: '',
      args: [],
    );
  }

  /// `Please retry.`
  String get auto_test_please_retry {
    return Intl.message(
      'Please retry.',
      name: 'auto_test_please_retry',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance Record`
  String get maintenance_records {
    return Intl.message(
      'Maintenance Record',
      name: 'maintenance_records',
      desc: '',
      args: [],
    );
  }

  /// `Current valve`
  String get maintenance_records_current_valve {
    return Intl.message(
      'Current valve',
      name: 'maintenance_records_current_valve',
      desc: '',
      args: [],
    );
  }

  /// `Historical valve`
  String get maintenance_records_past_valve {
    return Intl.message(
      'Historical valve',
      name: 'maintenance_records_past_valve',
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

  /// `T & E`
  String get record_chart_t_e {
    return Intl.message(
      'T & E',
      name: 'record_chart_t_e',
      desc: '',
      args: [],
    );
  }

  /// `Traceability`
  String get traceability {
    return Intl.message(
      'Traceability',
      name: 'traceability',
      desc: '',
      args: [],
    );
  }

  /// `Current Ball Valve's ID`
  String get traceability_current_ball_valve_id {
    return Intl.message(
      'Current Ball Valve\'s ID',
      name: 'traceability_current_ball_valve_id',
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

  /// `Please enter the product serial No. you purchased to search about the valve's traceability.`
  String get traceability_please_enter_serial_no_conent {
    return Intl.message(
      'Please enter the product serial No. you purchased to search about the valve\'s traceability.',
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

  /// `The serial No. could not be identified. Please double check the valve's serial No.`
  String get traceability_serial_number_could_not_identified_conent {
    return Intl.message(
      'The serial No. could not be identified. Please double check the valve\'s serial No.',
      name: 'traceability_serial_number_could_not_identified_conent',
      desc: '',
      args: [],
    );
  }

  /// `Valve's serial No. should contain 12 characters.`
  String get traceability_serial_no_should_12_chars_content {
    return Intl.message(
      'Valve\'s serial No. should contain 12 characters.',
      name: 'traceability_serial_no_should_12_chars_content',
      desc: '',
      args: [],
    );
  }

  /// `Device Setting`
  String get device_settings_ {
    return Intl.message(
      'Device Setting',
      name: 'device_settings_',
      desc: '',
      args: [],
    );
  }

  /// `Setting item`
  String get device_settings_item {
    return Intl.message(
      'Setting item',
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

  /// `Close`
  String get device_settings_close {
    return Intl.message(
      'Close',
      name: 'device_settings_close',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get device_settings_open {
    return Intl.message(
      'Open',
      name: 'device_settings_open',
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

  /// `Switch point setting`
  String get device_settings_sp_setting {
    return Intl.message(
      'Switch point setting',
      name: 'device_settings_sp_setting',
      desc: '',
      args: [],
    );
  }

  /// `SP angle-1`
  String get device_settings_sp_1 {
    return Intl.message(
      'SP angle-1',
      name: 'device_settings_sp_1',
      desc: '',
      args: [],
    );
  }

  /// `SP angle-2`
  String get device_settings_sp_2 {
    return Intl.message(
      'SP angle-2',
      name: 'device_settings_sp_2',
      desc: '',
      args: [],
    );
  }

  /// `SP Out of Range`
  String get device_settings_sp_out_of_range {
    return Intl.message(
      'SP Out of Range',
      name: 'device_settings_sp_out_of_range',
      desc: '',
      args: [],
    );
  }

  /// `The angle of switch point should be between opening & closing angle. Please check the switch point angle again.`
  String get device_settings_sp_setting_chaek {
    return Intl.message(
      'The angle of switch point should be between opening & closing angle. Please check the switch point angle again.',
      name: 'device_settings_sp_setting_chaek',
      desc: '',
      args: [],
    );
  }

  /// `Device Location`
  String get device_settings_device_lacation {
    return Intl.message(
      'Device Location',
      name: 'device_settings_device_lacation',
      desc: '',
      args: [],
    );
  }

  /// `Add a location description to enhance device identification. (Limit: 50 characters)`
  String get device_settings_device_lacation_content {
    return Intl.message(
      'Add a location description to enhance device identification. (Limit: 50 characters)',
      name: 'device_settings_device_lacation_content',
      desc: '',
      args: [],
    );
  }

  /// `Add location description here`
  String get device_settings_add_description {
    return Intl.message(
      'Add location description here',
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

  /// `Set different colors for each state (except for fault states) to enhance operational recognition.`
  String get device_settings_led_indicator_conent {
    return Intl.message(
      'Set different colors for each state (except for fault states) to enhance operational recognition.',
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

  /// `Replace Ball Valve`
  String get replace_ball_valve {
    return Intl.message(
      'Replace Ball Valve',
      name: 'replace_ball_valve',
      desc: '',
      args: [],
    );
  }

  /// `After replacing the ball valve, you need to set the new ball valve's serial No. to synchronize the correct data.`
  String get replace_ball_valve_enter_new_id {
    return Intl.message(
      'After replacing the ball valve, you need to set the new ball valve\'s serial No. to synchronize the correct data.',
      name: 'replace_ball_valve_enter_new_id',
      desc: '',
      args: [],
    );
  }

  /// `Replace Confirm`
  String get replace_ball_valve_confirm {
    return Intl.message(
      'Replace Confirm',
      name: 'replace_ball_valve_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Save Successfully`
  String get replace_ball_valve_seccess {
    return Intl.message(
      'Save Successfully',
      name: 'replace_ball_valve_seccess',
      desc: '',
      args: [],
    );
  }

  /// `Setting is saved.`
  String get replace_ball_valve_setting_saved {
    return Intl.message(
      'Setting is saved.',
      name: 'replace_ball_valve_setting_saved',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance notify`
  String get maintenance_notify {
    return Intl.message(
      'Maintenance notify',
      name: 'maintenance_notify',
      desc: '',
      args: [],
    );
  }

  /// `The maintenance indicator light will turn on to notify when the Ball Valve usage reaches the configured threshold value.`
  String get maintenance_notify_configured_threshold {
    return Intl.message(
      'The maintenance indicator light will turn on to notify when the Ball Valve usage reaches the configured threshold value.',
      name: 'maintenance_notify_configured_threshold',
      desc: '',
      args: [],
    );
  }

  /// `Cycle counter time(s)`
  String get maintenance_notify_cycle_counter {
    return Intl.message(
      'Cycle counter time(s)',
      name: 'maintenance_notify_cycle_counter',
      desc: '',
      args: [],
    );
  }

  /// `Current cycle counter time(s)`
  String get maintenance_notify_cycle_counter_times {
    return Intl.message(
      'Current cycle counter time(s)',
      name: 'maintenance_notify_cycle_counter_times',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get maintenance_notify_reset {
    return Intl.message(
      'Reset',
      name: 'maintenance_notify_reset',
      desc: '',
      args: [],
    );
  }

  /// `Initial setting`
  String get maintenance_notify_initial_setting {
    return Intl.message(
      'Initial setting',
      name: 'maintenance_notify_initial_setting',
      desc: '',
      args: [],
    );
  }

  /// `Address ID`
  String get address_id {
    return Intl.message(
      'Address ID',
      name: 'address_id',
      desc: '',
      args: [],
    );
  }

  /// `Baud rate`
  String get baud_rate {
    return Intl.message(
      'Baud rate',
      name: 'baud_rate',
      desc: '',
      args: [],
    );
  }

  /// `Terminal resistor switch`
  String get terminal_resistor_switch {
    return Intl.message(
      'Terminal resistor switch',
      name: 'terminal_resistor_switch',
      desc: '',
      args: [],
    );
  }

  /// `STEM`
  String get stem {
    return Intl.message(
      'STEM',
      name: 'stem',
      desc: '',
      args: [],
    );
  }

  /// `Calibrate angle`
  String get calibrate_angle {
    return Intl.message(
      'Calibrate angle',
      name: 'calibrate_angle',
      desc: '',
      args: [],
    );
  }

  /// `Setting Hint`
  String get setting_hint {
    return Intl.message(
      'Setting Hint',
      name: 'setting_hint',
      desc: '',
      args: [],
    );
  }

  /// `RS485 Identification ID. Please enter a value between 1-255. RS485 Address IDs in the same series cannot be duplicated.`
  String get rs485_enter_id_content {
    return Intl.message(
      'RS485 Identification ID. Please enter a value between 1-255. RS485 Address IDs in the same series cannot be duplicated.',
      name: 'rs485_enter_id_content',
      desc: '',
      args: [],
    );
  }

  /// `The communication speed of RS485 cable. Generally higher baud rates mean faster transmission, but lower rates can better maintain stability with longer cable runs. Suggested baud rates based on cable length:`
  String get rs485_cable_length_content {
    return Intl.message(
      'The communication speed of RS485 cable. Generally higher baud rates mean faster transmission, but lower rates can better maintain stability with longer cable runs. Suggested baud rates based on cable length:',
      name: 'rs485_cable_length_content',
      desc: '',
      args: [],
    );
  }

  /// `Must not exceed 1100 m`
  String get rs485_suggested_baud_rates_based_on_cable_length {
    return Intl.message(
      'Must not exceed 1100 m',
      name: 'rs485_suggested_baud_rates_based_on_cable_length',
      desc: '',
      args: [],
    );
  }

  /// `The above recommended values are based on using: 24 AWG, twisted pair, unshielded, 52.4 pF/meter cable.`
  String get rs485_recommended_values_content {
    return Intl.message(
      'The above recommended values are based on using: 24 AWG, twisted pair, unshielded, 52.4 pF/meter cable.',
      name: 'rs485_recommended_values_content',
      desc: '',
      args: [],
    );
  }

  /// `When the IVM is the last device in the series, please turn on the termination resistor switch for this item.`
  String get rs485_termination_resistor_sontent {
    return Intl.message(
      'When the IVM is the last device in the series, please turn on the termination resistor switch for this item.',
      name: 'rs485_termination_resistor_sontent',
      desc: '',
      args: [],
    );
  }

  /// `Firmware Update`
  String get fw_update {
    return Intl.message(
      'Firmware Update',
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

  /// `Format Error`
  String get fw_update_select_file_content {
    return Intl.message(
      'Format Error',
      name: 'fw_update_select_file_content',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect file format. Please select a .bin file.`
  String get fw_update_select_file {
    return Intl.message(
      'Incorrect file format. Please select a .bin file.',
      name: 'fw_update_select_file',
      desc: '',
      args: [],
    );
  }

  /// `Download Error`
  String get fw_update_file_error {
    return Intl.message(
      'Download Error',
      name: 'fw_update_file_error',
      desc: '',
      args: [],
    );
  }

  /// `Unable to download file from server. Please check your internet connection.`
  String get fw_update_file_error_content {
    return Intl.message(
      'Unable to download file from server. Please check your internet connection.',
      name: 'fw_update_file_error_content',
      desc: '',
      args: [],
    );
  }

  /// `Firmware Update`
  String get fw_update_download_error {
    return Intl.message(
      'Firmware Update',
      name: 'fw_update_download_error',
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

  /// `Yes, update now`
  String get fw_update_dialog_yes {
    return Intl.message(
      'Yes, update now',
      name: 'fw_update_dialog_yes',
      desc: '',
      args: [],
    );
  }

  /// `No, update later`
  String get fw_update_dialog_no {
    return Intl.message(
      'No, update later',
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

  /// `Already at the latest firmware version.`
  String get fw_update_version_is_newest {
    return Intl.message(
      'Already at the latest firmware version.',
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
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'sv'),
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
