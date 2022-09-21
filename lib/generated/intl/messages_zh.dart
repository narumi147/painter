// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m1(error) => "导入失败:\n${error}";

  static String m2(shown, total) => "显示${shown}/总计${total}";

  static String m3(shown, ignore, total) => "显示${shown}/忽略${ignore}/总计${total}";

  static String m0(a, b) => "${a}${b}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_app": MessageLookupByLibrary.simpleMessage("关于"),
        "about_feedback": MessageLookupByLibrary.simpleMessage("反馈"),
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "add_feedback_details_warning":
            MessageLookupByLibrary.simpleMessage("请填写反馈内容"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "change_log": MessageLookupByLibrary.simpleMessage("更新历史"),
        "check_file_hash": MessageLookupByLibrary.simpleMessage("验证文件完整性"),
        "check_update": MessageLookupByLibrary.simpleMessage("检查更新"),
        "clear": MessageLookupByLibrary.simpleMessage("清空"),
        "clear_cache": MessageLookupByLibrary.simpleMessage("清除缓存"),
        "clear_cache_finish": MessageLookupByLibrary.simpleMessage("缓存已清理"),
        "clear_data": MessageLookupByLibrary.simpleMessage("清除数据"),
        "confirm": MessageLookupByLibrary.simpleMessage("确定"),
        "copied": MessageLookupByLibrary.simpleMessage("已复制"),
        "copy": MessageLookupByLibrary.simpleMessage("复制"),
        "copy_plan_menu": MessageLookupByLibrary.simpleMessage("拷贝自其它规划"),
        "counts": MessageLookupByLibrary.simpleMessage("计数"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("深色模式"),
        "dark_mode_dark": MessageLookupByLibrary.simpleMessage("深色"),
        "dark_mode_light": MessageLookupByLibrary.simpleMessage("浅色"),
        "dark_mode_system": MessageLookupByLibrary.simpleMessage("系统"),
        "database": MessageLookupByLibrary.simpleMessage("数据库"),
        "dataset_version": MessageLookupByLibrary.simpleMessage("数据版本"),
        "date": MessageLookupByLibrary.simpleMessage("日期"),
        "debug": MessageLookupByLibrary.simpleMessage("Debug"),
        "debug_fab": MessageLookupByLibrary.simpleMessage("Debug FAB"),
        "debug_menu": MessageLookupByLibrary.simpleMessage("Debug Menu"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "demands": MessageLookupByLibrary.simpleMessage("需求"),
        "display_grid": MessageLookupByLibrary.simpleMessage("网格"),
        "display_list": MessageLookupByLibrary.simpleMessage("列表"),
        "display_setting": MessageLookupByLibrary.simpleMessage("显示设置"),
        "display_show_window_fab":
            MessageLookupByLibrary.simpleMessage("显示多窗口按钮"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "downloaded": MessageLookupByLibrary.simpleMessage("已下载"),
        "downloading": MessageLookupByLibrary.simpleMessage("下载中"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "failed": MessageLookupByLibrary.simpleMessage("失败"),
        "faq": MessageLookupByLibrary.simpleMessage("FAQ"),
        "filename": MessageLookupByLibrary.simpleMessage("文件名"),
        "filter": MessageLookupByLibrary.simpleMessage("筛选"),
        "gallery_tab_name": MessageLookupByLibrary.simpleMessage("首页"),
        "general_all": MessageLookupByLibrary.simpleMessage("所有"),
        "general_close": MessageLookupByLibrary.simpleMessage("关闭"),
        "general_default": MessageLookupByLibrary.simpleMessage("默认"),
        "general_others": MessageLookupByLibrary.simpleMessage("其他"),
        "general_special": MessageLookupByLibrary.simpleMessage("特殊"),
        "general_type": MessageLookupByLibrary.simpleMessage("类型"),
        "help": MessageLookupByLibrary.simpleMessage("帮助"),
        "icons": MessageLookupByLibrary.simpleMessage("图标"),
        "ignore": MessageLookupByLibrary.simpleMessage("忽略"),
        "import_data": MessageLookupByLibrary.simpleMessage("导入"),
        "import_data_error": m1,
        "import_data_success": MessageLookupByLibrary.simpleMessage("成功导入数据"),
        "import_from_clipboard": MessageLookupByLibrary.simpleMessage("从剪切板"),
        "import_from_file": MessageLookupByLibrary.simpleMessage("从文件"),
        "import_image": MessageLookupByLibrary.simpleMessage("导入图片"),
        "language": MessageLookupByLibrary.simpleMessage("简体中文"),
        "language_en": MessageLookupByLibrary.simpleMessage("Chinese"),
        "link": MessageLookupByLibrary.simpleMessage("链接"),
        "list_count_shown_all": m2,
        "list_count_shown_hidden_all": m3,
        "not_found": MessageLookupByLibrary.simpleMessage("Not Found"),
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "open": MessageLookupByLibrary.simpleMessage("打开"),
        "outdated": MessageLookupByLibrary.simpleMessage("已过期"),
        "overview": MessageLookupByLibrary.simpleMessage("概览"),
        "random": MessageLookupByLibrary.simpleMessage("随机"),
        "rarity": MessageLookupByLibrary.simpleMessage("稀有度"),
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "reset": MessageLookupByLibrary.simpleMessage("重置"),
        "restore": MessageLookupByLibrary.simpleMessage("恢复"),
        "results": MessageLookupByLibrary.simpleMessage("结果"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "saved": MessageLookupByLibrary.simpleMessage("已保存"),
        "screen_size": MessageLookupByLibrary.simpleMessage("屏幕尺寸"),
        "screenshots": MessageLookupByLibrary.simpleMessage("截图"),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "select_lang": MessageLookupByLibrary.simpleMessage("选择语言"),
        "setting_always_on_top": MessageLookupByLibrary.simpleMessage("置顶显示"),
        "setting_auto_rotate": MessageLookupByLibrary.simpleMessage("自动旋转"),
        "settings_data": MessageLookupByLibrary.simpleMessage("数据"),
        "settings_documents": MessageLookupByLibrary.simpleMessage("使用文档"),
        "settings_general": MessageLookupByLibrary.simpleMessage("通用"),
        "settings_language": MessageLookupByLibrary.simpleMessage("语言"),
        "settings_tab_name": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "show_carousel": MessageLookupByLibrary.simpleMessage("显示轮播图"),
        "show_frame_rate": MessageLookupByLibrary.simpleMessage("显示刷新率"),
        "show_outdated": MessageLookupByLibrary.simpleMessage("显示已过期"),
        "sort_order": MessageLookupByLibrary.simpleMessage("排序"),
        "statistics_title": MessageLookupByLibrary.simpleMessage("统计"),
        "success": MessageLookupByLibrary.simpleMessage("成功"),
        "test_info_pad": MessageLookupByLibrary.simpleMessage("测试信息"),
        "testing": MessageLookupByLibrary.simpleMessage("测试ing"),
        "time_close": MessageLookupByLibrary.simpleMessage("关闭"),
        "time_end": MessageLookupByLibrary.simpleMessage("结束"),
        "time_start": MessageLookupByLibrary.simpleMessage("开始"),
        "toggle_dark_mode": MessageLookupByLibrary.simpleMessage("切换深色模式"),
        "tooltip_refresh_sliders":
            MessageLookupByLibrary.simpleMessage("刷新轮播图"),
        "update": MessageLookupByLibrary.simpleMessage("更新"),
        "update_already_latest":
            MessageLookupByLibrary.simpleMessage("已经是最新版本"),
        "update_msg_error": MessageLookupByLibrary.simpleMessage("更新失败"),
        "update_msg_no_update": MessageLookupByLibrary.simpleMessage("无可用更新"),
        "update_msg_succuss": MessageLookupByLibrary.simpleMessage("已更新"),
        "userdata": MessageLookupByLibrary.simpleMessage("用户数据"),
        "version": MessageLookupByLibrary.simpleMessage("版本"),
        "warning": MessageLookupByLibrary.simpleMessage("警告"),
        "words_separate": m0
      };
}
