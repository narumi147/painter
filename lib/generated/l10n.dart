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

extension _LocaleEx on Locale {
  String get canonicalizedName {
    if (scriptCode == null) {
      return Intl.canonicalizedLocale(toString());
    }
    return toString();
  }
}

class S {
  final Locale locale;
  final String localeName;

  S(this.locale) : localeName = locale.canonicalizedName;

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale, {bool override = false}) {
    final localeName = locale.canonicalizedName;
    return initializeMessages(localeName).then((_) {
      final localizations = S(locale);
      if (override || S._current == null) {
        Intl.defaultLocale = localeName;
        S._current = localizations;
      }
      return localizations;
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

  /// `简体中文`
  String get language {
    return Intl.message(
      '简体中文',
      name: 'language',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `Chinese`
  String get language_en {
    return Intl.message(
      'Chinese',
      name: 'language_en',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `关于`
  String get about_app {
    return Intl.message(
      '关于',
      name: 'about_app',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `反馈`
  String get about_feedback {
    return Intl.message(
      '反馈',
      name: 'about_feedback',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `添加`
  String get add {
    return Intl.message(
      '添加',
      name: 'add',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `请填写反馈内容`
  String get add_feedback_details_warning {
    return Intl.message(
      '请填写反馈内容',
      name: 'add_feedback_details_warning',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `更新历史`
  String get change_log {
    return Intl.message(
      '更新历史',
      name: 'change_log',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `验证文件完整性`
  String get check_file_hash {
    return Intl.message(
      '验证文件完整性',
      name: 'check_file_hash',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `检查更新`
  String get check_update {
    return Intl.message(
      '检查更新',
      name: 'check_update',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `清空`
  String get clear {
    return Intl.message(
      '清空',
      name: 'clear',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `清除缓存`
  String get clear_cache {
    return Intl.message(
      '清除缓存',
      name: 'clear_cache',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `缓存已清理`
  String get clear_cache_finish {
    return Intl.message(
      '缓存已清理',
      name: 'clear_cache_finish',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `清除数据`
  String get clear_data {
    return Intl.message(
      '清除数据',
      name: 'clear_data',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `确定`
  String get confirm {
    return Intl.message(
      '确定',
      name: 'confirm',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `已复制`
  String get copied {
    return Intl.message(
      '已复制',
      name: 'copied',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `复制`
  String get copy {
    return Intl.message(
      '复制',
      name: 'copy',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `拷贝自其它规划`
  String get copy_plan_menu {
    return Intl.message(
      '拷贝自其它规划',
      name: 'copy_plan_menu',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `计数`
  String get counts {
    return Intl.message(
      '计数',
      name: 'counts',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `深色模式`
  String get dark_mode {
    return Intl.message(
      '深色模式',
      name: 'dark_mode',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `深色`
  String get dark_mode_dark {
    return Intl.message(
      '深色',
      name: 'dark_mode_dark',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `浅色`
  String get dark_mode_light {
    return Intl.message(
      '浅色',
      name: 'dark_mode_light',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `系统`
  String get dark_mode_system {
    return Intl.message(
      '系统',
      name: 'dark_mode_system',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `数据库`
  String get database {
    return Intl.message(
      '数据库',
      name: 'database',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `数据版本`
  String get dataset_version {
    return Intl.message(
      '数据版本',
      name: 'dataset_version',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `日期`
  String get date {
    return Intl.message(
      '日期',
      name: 'date',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `Debug`
  String get debug {
    return Intl.message(
      'Debug',
      name: 'debug',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `Debug FAB`
  String get debug_fab {
    return Intl.message(
      'Debug FAB',
      name: 'debug_fab',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `Debug Menu`
  String get debug_menu {
    return Intl.message(
      'Debug Menu',
      name: 'debug_menu',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `删除`
  String get delete {
    return Intl.message(
      '删除',
      name: 'delete',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `需求`
  String get demands {
    return Intl.message(
      '需求',
      name: 'demands',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `网格`
  String get display_grid {
    return Intl.message(
      '网格',
      name: 'display_grid',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `列表`
  String get display_list {
    return Intl.message(
      '列表',
      name: 'display_list',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `显示设置`
  String get display_setting {
    return Intl.message(
      '显示设置',
      name: 'display_setting',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `显示多窗口按钮`
  String get display_show_window_fab {
    return Intl.message(
      '显示多窗口按钮',
      name: 'display_show_window_fab',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `完成`
  String get done {
    return Intl.message(
      '完成',
      name: 'done',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `下载`
  String get download {
    return Intl.message(
      '下载',
      name: 'download',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `已下载`
  String get downloaded {
    return Intl.message(
      '已下载',
      name: 'downloaded',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `下载中`
  String get downloading {
    return Intl.message(
      '下载中',
      name: 'downloading',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `编辑`
  String get edit {
    return Intl.message(
      '编辑',
      name: 'edit',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `失败`
  String get failed {
    return Intl.message(
      '失败',
      name: 'failed',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `文件名`
  String get filename {
    return Intl.message(
      '文件名',
      name: 'filename',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `筛选`
  String get filter {
    return Intl.message(
      '筛选',
      name: 'filter',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `首页`
  String get gallery_tab_name {
    return Intl.message(
      '首页',
      name: 'gallery_tab_name',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `所有`
  String get general_all {
    return Intl.message(
      '所有',
      name: 'general_all',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `关闭`
  String get general_close {
    return Intl.message(
      '关闭',
      name: 'general_close',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `默认`
  String get general_default {
    return Intl.message(
      '默认',
      name: 'general_default',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `其他`
  String get general_others {
    return Intl.message(
      '其他',
      name: 'general_others',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `特殊`
  String get general_special {
    return Intl.message(
      '特殊',
      name: 'general_special',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `类型`
  String get general_type {
    return Intl.message(
      '类型',
      name: 'general_type',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `帮助`
  String get help {
    return Intl.message(
      '帮助',
      name: 'help',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `图标`
  String get icons {
    return Intl.message(
      '图标',
      name: 'icons',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `忽略`
  String get ignore {
    return Intl.message(
      '忽略',
      name: 'ignore',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `导入`
  String get import_data {
    return Intl.message(
      '导入',
      name: 'import_data',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `导入失败:\n{error}`
  String import_data_error(Object error) {
    return Intl.message(
      '导入失败:\n$error',
      name: 'import_data_error',
      desc: '',
      locale: localeName,
      args: [error],
    );
  }

  /// `成功导入数据`
  String get import_data_success {
    return Intl.message(
      '成功导入数据',
      name: 'import_data_success',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `从剪切板`
  String get import_from_clipboard {
    return Intl.message(
      '从剪切板',
      name: 'import_from_clipboard',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `从文件`
  String get import_from_file {
    return Intl.message(
      '从文件',
      name: 'import_from_file',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `导入图片`
  String get import_image {
    return Intl.message(
      '导入图片',
      name: 'import_image',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `链接`
  String get link {
    return Intl.message(
      '链接',
      name: 'link',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `显示{shown}/总计{total}`
  String list_count_shown_all(Object shown, Object total) {
    return Intl.message(
      '显示$shown/总计$total',
      name: 'list_count_shown_all',
      desc: '',
      locale: localeName,
      args: [shown, total],
    );
  }

  /// `显示{shown}/忽略{ignore}/总计{total}`
  String list_count_shown_hidden_all(
      Object shown, Object ignore, Object total) {
    return Intl.message(
      '显示$shown/忽略$ignore/总计$total',
      name: 'list_count_shown_hidden_all',
      desc: '',
      locale: localeName,
      args: [shown, ignore, total],
    );
  }

  /// `Not Found`
  String get not_found {
    return Intl.message(
      'Not Found',
      name: 'not_found',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `确定`
  String get ok {
    return Intl.message(
      '确定',
      name: 'ok',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `打开`
  String get open {
    return Intl.message(
      '打开',
      name: 'open',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `已过期`
  String get outdated {
    return Intl.message(
      '已过期',
      name: 'outdated',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `概览`
  String get overview {
    return Intl.message(
      '概览',
      name: 'overview',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `随机`
  String get random {
    return Intl.message(
      '随机',
      name: 'random',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `稀有度`
  String get rarity {
    return Intl.message(
      '稀有度',
      name: 'rarity',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `重命名`
  String get rename {
    return Intl.message(
      '重命名',
      name: 'rename',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `重置`
  String get reset {
    return Intl.message(
      '重置',
      name: 'reset',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `恢复`
  String get restore {
    return Intl.message(
      '恢复',
      name: 'restore',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `结果`
  String get results {
    return Intl.message(
      '结果',
      name: 'results',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `保存`
  String get save {
    return Intl.message(
      '保存',
      name: 'save',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `已保存`
  String get saved {
    return Intl.message(
      '已保存',
      name: 'saved',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `屏幕尺寸`
  String get screen_size {
    return Intl.message(
      '屏幕尺寸',
      name: 'screen_size',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `截图`
  String get screenshots {
    return Intl.message(
      '截图',
      name: 'screenshots',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `搜索`
  String get search {
    return Intl.message(
      '搜索',
      name: 'search',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `选择语言`
  String get select_lang {
    return Intl.message(
      '选择语言',
      name: 'select_lang',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `置顶显示`
  String get setting_always_on_top {
    return Intl.message(
      '置顶显示',
      name: 'setting_always_on_top',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `自动旋转`
  String get setting_auto_rotate {
    return Intl.message(
      '自动旋转',
      name: 'setting_auto_rotate',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `数据`
  String get settings_data {
    return Intl.message(
      '数据',
      name: 'settings_data',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `使用文档`
  String get settings_documents {
    return Intl.message(
      '使用文档',
      name: 'settings_documents',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `通用`
  String get settings_general {
    return Intl.message(
      '通用',
      name: 'settings_general',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `语言`
  String get settings_language {
    return Intl.message(
      '语言',
      name: 'settings_language',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `设置`
  String get settings_tab_name {
    return Intl.message(
      '设置',
      name: 'settings_tab_name',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `分享`
  String get share {
    return Intl.message(
      '分享',
      name: 'share',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `显示轮播图`
  String get show_carousel {
    return Intl.message(
      '显示轮播图',
      name: 'show_carousel',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `显示刷新率`
  String get show_frame_rate {
    return Intl.message(
      '显示刷新率',
      name: 'show_frame_rate',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `显示已过期`
  String get show_outdated {
    return Intl.message(
      '显示已过期',
      name: 'show_outdated',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `排序`
  String get sort_order {
    return Intl.message(
      '排序',
      name: 'sort_order',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `统计`
  String get statistics_title {
    return Intl.message(
      '统计',
      name: 'statistics_title',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `成功`
  String get success {
    return Intl.message(
      '成功',
      name: 'success',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `测试信息`
  String get test_info_pad {
    return Intl.message(
      '测试信息',
      name: 'test_info_pad',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `测试ing`
  String get testing {
    return Intl.message(
      '测试ing',
      name: 'testing',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `关闭`
  String get time_close {
    return Intl.message(
      '关闭',
      name: 'time_close',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `结束`
  String get time_end {
    return Intl.message(
      '结束',
      name: 'time_end',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `开始`
  String get time_start {
    return Intl.message(
      '开始',
      name: 'time_start',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `切换深色模式`
  String get toggle_dark_mode {
    return Intl.message(
      '切换深色模式',
      name: 'toggle_dark_mode',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `刷新轮播图`
  String get tooltip_refresh_sliders {
    return Intl.message(
      '刷新轮播图',
      name: 'tooltip_refresh_sliders',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `更新`
  String get update {
    return Intl.message(
      '更新',
      name: 'update',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `已经是最新版本`
  String get update_already_latest {
    return Intl.message(
      '已经是最新版本',
      name: 'update_already_latest',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `更新失败`
  String get update_msg_error {
    return Intl.message(
      '更新失败',
      name: 'update_msg_error',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `无可用更新`
  String get update_msg_no_update {
    return Intl.message(
      '无可用更新',
      name: 'update_msg_no_update',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `已更新`
  String get update_msg_succuss {
    return Intl.message(
      '已更新',
      name: 'update_msg_succuss',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `用户数据`
  String get userdata {
    return Intl.message(
      '用户数据',
      name: 'userdata',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `版本`
  String get version {
    return Intl.message(
      '版本',
      name: 'version',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `警告`
  String get warning {
    return Intl.message(
      '警告',
      name: 'warning',
      desc: '',
      locale: localeName,
      args: [],
    );
  }

  /// `{a}{b}`
  String words_separate(Object a, Object b) {
    return Intl.message(
      '$a$b',
      name: 'words_separate',
      desc: '',
      locale: localeName,
      args: [a, b],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'en'),
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
