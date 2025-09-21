import ctypes
import time
import logging
from typing import List, Any, Optional, Dict

import dxcam
import numpy as np
from win32gui import EnumWindows, GetWindowText
import ddddocr
from PIL import Image

# 设置默认日志级别为WARNING
logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)
logger.setLevel(logging.WARNING)  # 添加这一行

TARGET_FPS = 30
REGION = (0, 0, 324, 24)

WM_KEYDOWN = 0x0100
WM_KEYUP = 0x0101

KEY_COLOR_MAP = [{"key": "CTRL-F1", "R": 130, "G": 115, "B": 124},
                 {"key": "CTRL-F2", "R": 102, "G": 253, "B": 136},
                 {"key": "CTRL-F3", "R": 66, "G": 134, "B": 253},
                 {"key": "CTRL-F5", "R": 123, "G": 195, "B": 3},
                 {"key": "CTRL-F6", "R": 241, "G": 208, "B": 124},
                 {"key": "CTRL-F7", "R": 1, "G": 142, "B": 135},
                 {"key": "CTRL-F8", "R": 128, "G": 18, "B": 30},
                 {"key": "CTRL-F9", "R": 136, "G": 5, "B": 190},
                 {"key": "CTRL-F10", "R": 246, "G": 14, "B": 129},
                 {"key": "CTRL-F11", "R": 244, "G": 124, "B": 235},
                 {"key": "SHIFT-F1", "R": 229, "G": 132, "B": 1},
                 {"key": "SHIFT-F2", "R": 35, "G": 117, "B": 19},
                 {"key": "SHIFT-F3", "R": 30, "G": 27, "B": 153},
                 {"key": "SHIFT-F5", "R": 129, "G": 245, "B": 241},
                 {"key": "SHIFT-F6", "R": 1, "G": 241, "B": 142},
                 {"key": "SHIFT-F7", "R": 246, "G": 109, "B": 114},
                 {"key": "SHIFT-F8", "R": 147, "G": 91, "B": 243},
                 {"key": "SHIFT-F9", "R": 184, "G": 251, "B": 58},
                 {"key": "SHIFT-F10", "R": 187, "G": 191, "B": 194},
                 {"key": "SHIFT-F11", "R": 46, "G": 40, "B": 61},
                 {"key": "SHIFT-,", "R": 50, "G": 189, "B": 190},
                 {"key": "SHIFT-.", "R": 74, "G": 41, "B": 251},
                 {"key": "SHIFT-/", "R": 185, "G": 82, "B": 53},
                 {"key": "SHIFT-;", "R": 69, "G": 213, "B": 65},
                 {"key": "SHIFT-'", "R": 66, "G": 100, "B": 177},
                 {"key": "SHIFT-[", "R": 191, "G": 165, "B": 67},
                 {"key": "SHIFT-]", "R": 145, "G": 36, "B": 107},
                 {"key": "SHIFT-=", "R": 115, "G": 114, "B": 41},
                 {"key": "CTRL-,", "R": 191, "G": 104, "B": 181},
                 {"key": "CTRL-.", "R": 135, "G": 170, "B": 245},
                 {"key": "CTRL-/", "R": 211, "G": 0, "B": 194},
                 {"key": "CTRL-;", "R": 60, "G": 143, "B": 85},
                 {"key": "CTRL-'", "R": 147, "G": 201, "B": 113},
                 {"key": "CTRL-[", "R": 1, "G": 104, "B": 242},
                 {"key": "CTRL-]", "R": 4, "G": 182, "B": 60},
                 {"key": "CTRL-=", "R": 4, "G": 186, "B": 245},
                 {"key": "CTRL-NUMPAD1", "R": 250, "G": 200, "B": 41},
                 {"key": "CTRL-NUMPAD2", "R": 252, "G": 211, "B": 191},
                 {"key": "CTRL-NUMPAD3", "R": 193, "G": 249, "B": 160},
                 {"key": "CTRL-NUMPAD4", "R": 149, "G": 23, "B": 253},
                 {"key": "CTRL-NUMPAD5", "R": 13, "G": 95, "B": 90},
                 {"key": "CTRL-NUMPAD6", "R": 211, "G": 203, "B": 254},
                 {"key": "CTRL-NUMPAD7", "R": 95, "G": 7, "B": 139},
                 {"key": "CTRL-NUMPAD8", "R": 230, "G": 155, "B": 161},
                 {"key": "CTRL-NUMPAD9", "R": 62, "G": 252, "B": 192},
                 {"key": "CTRL-NUMPAD0", "R": 67, "G": 191, "B": 127},
                 {"key": "SHIFT-NUMPAD1", "R": 247, "G": 68, "B": 48},
                 {"key": "SHIFT-NUMPAD2", "R": 2, "G": 87, "B": 181},
                 {"key": "SHIFT-NUMPAD3", "R": 80, "G": 251, "B": 16},
                 {"key": "SHIFT-NUMPAD4", "R": 123, "G": 202, "B": 171},
                 {"key": "SHIFT-NUMPAD5", "R": 180, "G": 49, "B": 1},
                 {"key": "SHIFT-NUMPAD6", "R": 240, "G": 6, "B": 59},
                 {"key": "SHIFT-NUMPAD7", "R": 5, "G": 3, "B": 103},
                 {"key": "SHIFT-NUMPAD8", "R": 236, "G": 64, "B": 180},
                 {"key": "SHIFT-NUMPAD9", "R": 17, "G": 243, "B": 66},
                 {"key": "SHIFT-NUMPAD0", "R": 106, "G": 63, "B": 202},
                 {"key": "CTRL-SHIFT-NUMPAD1", "R": 155, "G": 59, "B": 161},
                 {"key": "CTRL-SHIFT-NUMPAD2", "R": 179, "G": 212, "B": 8},
                 {"key": "CTRL-SHIFT-NUMPAD3", "R": 67, "G": 79, "B": 104},
                 {"key": "CTRL-SHIFT-NUMPAD4", "R": 179, "G": 88, "B": 110},
                 {"key": "CTRL-SHIFT-NUMPAD5", "R": 135, "G": 167, "B": 54},
                 {"key": "CTRL-SHIFT-NUMPAD6", "R": 175, "G": 114, "B": 7},
                 {"key": "CTRL-SHIFT-NUMPAD7", "R": 73, "G": 17, "B": 200},
                 {"key": "CTRL-SHIFT-NUMPAD8", "R": 96, "G": 147, "B": 184},
                 {"key": "CTRL-SHIFT-NUMPAD9", "R": 244, "G": 147, "B": 71},
                 {"key": "CTRL-SHIFT-NUMPAD0", "R": 61, "G": 184, "B": 19},
                 {"key": "CTRL-SHIFT-F2", "R": 91, "G": 19, "B": 84},
                 {"key": "CTRL-SHIFT-F3", "R": 30, "G": 49, "B": 211},
                 {"key": "CTRL-SHIFT-F5", "R": 201, "G": 250, "B": 214},
                 {"key": "CTRL-SHIFT-F6", "R": 84, "G": 217, "B": 252},
                 {"key": "CTRL-SHIFT-F7", "R": 50, "G": 253, "B": 121},
                 {"key": "CTRL-SHIFT-F8", "R": 100, "G": 60, "B": 145},
                 {"key": "CTRL-SHIFT-F9", "R": 11, "G": 162, "B": 3},
                 {"key": "CTRL-SHIFT-F10", "R": 142, "G": 250, "B": 3},
                 {"key": "CTRL-SHIFT-F11", "R": 193, "G": 141, "B": 219},
                 {"key": "ALT-NUMPAD1", "R": 32, "G": 42, "B": 3},
                 {"key": "ALT-NUMPAD2", "R": 119, "G": 80, "B": 81},
                 {"key": "ALT-NUMPAD3", "R": 200, "G": 28, "B": 85},
                 {"key": "ALT-NUMPAD4", "R": 247, "G": 239, "B": 76},
                 {"key": "ALT-NUMPAD5", "R": 172, "G": 157, "B": 126},
                 {"key": "ALT-NUMPAD6", "R": 107, "G": 239, "B": 87},
                 {"key": "ALT-NUMPAD7", "R": 3, "G": 79, "B": 26},
                 {"key": "ALT-NUMPAD8", "R": 162, "G": 126, "B": 82},
                 {"key": "ALT-NUMPAD9", "R": 148, "G": 127, "B": 170},
                 {"key": "ALT-NUMPAD0", "R": 218, "G": 63, "B": 134},
                 {"key": "ALT-F1", "R": 182, "G": 163, "B": 3},
                 {"key": "ALT-F2", "R": 188, "G": 34, "B": 225},
                 {"key": "ALT-F3", "R": 49, "G": 144, "B": 145},
                 # {"key": "ALT-F4", "R": 255, "G": 19, "B": 183},
                 {"key": "ALT-F5", "R": 157, "G": 248, "B": 107},
                 {"key": "ALT-F6", "R": 85, "G": 90, "B": 248},
                 {"key": "ALT-F7", "R": 195, "G": 94, "B": 246},
                 {"key": "ALT-F8", "R": 96, "G": 193, "B": 212},
                 {"key": "ALT-F9", "R": 24, "G": 87, "B": 136},
                 {"key": "ALT-F10", "R": 200, "G": 11, "B": 142},
                 {"key": "ALT-F11", "R": 70, "G": 61, "B": 25},
                 # {"key": "ALT-F12", "R": 7, "G": 182, "B": 110},
                 {"key": "CTRL-F12", "R": 37, "G": 122, "B": 217},
                 # {"key": "SHIFT-F12", "R": 15, "G": 6, "B": 50},
                 {"key": "SHIFT-F4", "R": 141, "G": 82, "B": 1},
                 {"key": "CTRL-F4", "R": 14, "G": 159, "B": 192},
                 {"key": "CTRL-SHIFT-F4", "R": 146, "G": 212, "B": 47},
                 {"key": "CTRL-SHIFT-F1", "R": 19, "G": 245, "B": 209},
                 # {"key": "CTRL-SHIFT-F12", "R": 155, "G": 0, "B": 135},
                 {"key": "ALT-,", "R": 243, "G": 252, "B": 139},
                 {"key": "ALT-.", "R": 109, "G": 137, "B": 1},
                 {"key": "ALT-/", "R": 243, "G": 51, "B": 97},
                 {"key": "ALT-;", "R": 200, "G": 201, "B": 94},
                 {"key": "ALT-'", "R": 227, "G": 110, "B": 50},
                 {"key": "ALT-[", "R": 169, "G": 2, "B": 42},
                 {"key": "ALT-]", "R": 222, "G": 35, "B": 29},
                 {"key": "ALT-=", "R": 106, "G": 241, "B": 190},
                 {"key": "ALT-SHIFT-NUMPAD1", "R": 38, "G": 79, "B": 249},
                 {"key": "ALT-SHIFT-NUMPAD2", "R": 211, "G": 146, "B": 106},
                 {"key": "ALT-SHIFT-NUMPAD3", "R": 111, "G": 174, "B": 109},
                 {"key": "ALT-SHIFT-NUMPAD4", "R": 37, "G": 221, "B": 161},
                 {"key": "ALT-SHIFT-NUMPAD5", "R": 19, "G": 205, "B": 14},
                 {"key": "ALT-SHIFT-NUMPAD6", "R": 99, "G": 5, "B": 241},
                 {"key": "ALT-SHIFT-NUMPAD7", "R": 232, "G": 43, "B": 224},
                 {"key": "ALT-SHIFT-NUMPAD8", "R": 220, "G": 230, "B": 11},
                 {"key": "ALT-SHIFT-NUMPAD9", "R": 9, "G": 45, "B": 85},
                 {"key": "ALT-SHIFT-NUMPAD0", "R": 42, "G": 227, "B": 243},
                 {"key": "ALT-SHIFT-F1", "R": 87, "G": 4, "B": 38},
                 {"key": "ALT-SHIFT-F2", "R": 237, "G": 108, "B": 179},
                 {"key": "ALT-SHIFT-F3", "R": 182, "G": 206, "B": 153},
                 {"key": "ALT-SHIFT-F4", "R": 41, "G": 85, "B": 58},
                 {"key": "ALT-SHIFT-F5", "R": 134, "G": 164, "B": 197},
                 {"key": "ALT-SHIFT-F6", "R": 32, "G": 30, "B": 254},
                 {"key": "ALT-SHIFT-F7", "R": 255, "G": 166, "B": 234},
                 {"key": "ALT-SHIFT-F8", "R": 201, "G": 238, "B": 119},
                 {"key": "ALT-SHIFT-F9", "R": 85, "G": 174, "B": 255},
                 {"key": "ALT-SHIFT-F10", "R": 81, "G": 207, "B": 164},
                 {"key": "ALT-SHIFT-F11", "R": 16, "G": 144, "B": 94},
                 # {"key": "ALT-SHIFT-F12", "R": 83, "G": 102, "B": 135},
                 {"key": "CTRL-SHIFT-,", "R": 252, "G": 183, "B": 3},
                 {"key": "CTRL-SHIFT-.", "R": 243, "G": 72, "B": 7},
                 {"key": "CTRL-SHIFT-/", "R": 231, "G": 84, "B": 219},
                 {"key": "CTRL-SHIFT-;", "R": 39, "G": 251, "B": 32},
                 {"key": "CTRL-SHIFT-'", "R": 225, "G": 161, "B": 30},
                 {"key": "CTRL-SHIFT-[", "R": 194, "G": 52, "B": 172},
                 {"key": "CTRL-SHIFT-]", "R": 8, "G": 179, "B": 151},
                 {"key": "CTRL-SHIFT-=", "R": 53, "G": 181, "B": 230},
                 {"key": "ALT-SHIFT-,", "R": 144, "G": 154, "B": 15},
                 {"key": "ALT-SHIFT-.", "R": 140, "G": 131, "B": 234},
                 {"key": "ALT-SHIFT-/", "R": 135, "G": 88, "B": 188},
                 {"key": "ALT-SHIFT-;", "R": 187, "G": 169, "B": 248},
                 {"key": "ALT-SHIFT-'", "R": 8, "G": 15, "B": 214},
                 {"key": "ALT-SHIFT-[", "R": 81, "G": 88, "B": 61},
                 {"key": "ALT-SHIFT-]", "R": 252, "G": 163, "B": 107},
                 {"key": "ALT-SHIFT-=", "R": 207, "G": 105, "B": 133}, ]

VK_DICT = {
    "SHIFT": 0x10,
    "CTRL": 0x11,
    "ALT": 0x12,
    "NUMPAD0": 0x60,
    "NUMPAD1": 0x61,
    "NUMPAD2": 0x62,
    "NUMPAD3": 0x63,
    "NUMPAD4": 0x64,
    "NUMPAD5": 0x65,
    "NUMPAD6": 0x66,
    "NUMPAD7": 0x67,
    "NUMPAD8": 0x68,
    "NUMPAD9": 0x69,
    "F1": 0x70,
    "F2": 0x71,
    "F3": 0x72,
    "F4": 0x73,
    "F5": 0x74,
    "F6": 0x75,
    "F7": 0x76,
    "F8": 0x77,
    "F9": 0x78,
    "F10": 0x79,
    "F11": 0x7a,
    "F12": 0x7b,
    "'": 0xde,
    ",": 0xbc,
    ".": 0xbe,
    "/": 0xbf,
    ";": 0xba,
    "[": 0xdb,
    "]": 0xdd,
    "=": 0xbb,
    "0": 0x30,
    "1": 0x31,
    "2": 0x32,
    "3": 0x33,
    "4": 0x34,
    "5": 0x35,
    "6": 0x36,
    "7": 0x37,
    "8": 0x38,
    "9": 0x39,
    "A": 0x41,
    "B": 0x42,
    "C": 0x43,
    "D": 0x44,
    "E": 0x45,
    "F": 0x46,
    "G": 0x47,
    "H": 0x48,
    "I": 0x49,
    "J": 0x4A,
    "K": 0x4B,
    "L": 0x4C,
    "M": 0x4D,
    "N": 0x4E,
    "O": 0x4F,
    "P": 0x50,
    "Q": 0x51,
    "R": 0x52,
    "S": 0x53,
    "T": 0x54,
    "U": 0x55,
    "V": 0x56,
    "W": 0x57,
    "X": 0x58,
    "Y": 0x59,
    "Z": 0x5A,
    "`": 0xC0,

}

MOD_MAP = {
    "CTRL": 0x0002,  # MOD_CONTROL
    "CONTROL": 0x0002,
    "SHIFT": 0x0004,  # MOD_SHIFT
    "ALT": 0x0001,  # MOD_ALT
}

user32 = ctypes.WinDLL('user32', use_last_error=True)


def is_admin() -> bool:
    try:
        # 使用Windows API检查是否具有管理员令牌
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except AttributeError:
        # 非Windows系统总是返回False
        return False


def parse_hotkey(keybind_str):
    """
    解析快捷键字符串为（修饰符组合值, 虚拟键码）
    示例：'CTRL-SHIFT-F12' -> (0x0002|0x0004, 0x7b)
    """
    parts = keybind_str.upper().split('-')
    modifiers = 0
    vk_code = None

    for part in parts:
        if part in MOD_MAP:
            modifiers |= MOD_MAP[part]
        elif part in VK_DICT:
            vk_code = VK_DICT[part]
        else:
            raise ValueError(f"无效的键位标识: {part} in {keybind_str}")

    if vk_code is None:
        raise ValueError(f"未找到主键: {keybind_str}")

    return modifiers, vk_code


def check_hotkey_conflicts(key_list):
    for idx, item in enumerate(key_list, start=1):
        keybind = item['key']
        try:
            mod, vk = parse_hotkey(keybind)
            # 尝试注册热键（使用唯一递增ID）
            if user32.RegisterHotKey(None, idx, mod, vk):
                user32.UnregisterHotKey(None, idx)  # 立即释放
            else:
                # 获取错误信息（可选记录日志）
                error_code = ctypes.get_last_error()
                logger.warning(f"注册热键失败: {error_code}")
                logger.warning(keybind)
        except Exception as e:
            # 非法快捷键配置（自动过滤）
            pass


check_hotkey_conflicts(KEY_COLOR_MAP)


def build_color_key_mapping() -> Dict[str, str]:
    color_to_key = {}
    for key_data in KEY_COLOR_MAP:
        r: int = int(key_data.get("R", 0))
        g: int = int(key_data.get("G", 0))
        b: int = int(key_data.get("B", 0))
        color: str = f"{r}, {g}, {b}"
        color_to_key[color] = key_data["key"]
    return color_to_key


COLOR_TO_KEY = build_color_key_mapping()


# print(COLOR_TO_KEY)


def press_key_hwnd(hwnd: int, skey: str) -> None:
    """向指定窗口按下按键

    Args:
        hwnd: 窗口句柄
        skey: 虚拟按键名称

    Raises:
        KeyError: 当skey不在VK_DICT中时
        OSError: 当PostMessageW调用失败时
    """
    key = VK_DICT.get(skey)
    if key is None:
        raise KeyError(f"Virtual key '{skey}' not found in VK_DICT")

    result = ctypes.windll.user32.PostMessageW(hwnd, WM_KEYDOWN, key, 0)
    if result == 0:
        raise OSError(f"Failed to send key down message for '{skey}'")


def release_key_hwnd(hwnd: int, skey: str) -> None:
    """向指定窗口释放按键

    Args:
        hwnd: 窗口句柄
        skey: 虚拟按键名称

    Raises:
        KeyError: 当skey不在VK_DICT中时
        OSError: 当PostMessageW调用失败时
    """
    key = VK_DICT.get(skey)
    if key is None:
        raise KeyError(f"Virtual key '{skey}' not found in VK_DICT")

    result = ctypes.windll.user32.PostMessageW(hwnd, WM_KEYUP, key, 0)
    if result == 0:
        raise OSError(f"Failed to send key up message for '{skey}'")


def get_windows_by_title(title: str) -> List[int]:
    windows: List[tuple] = []

    # 回调函数用于收集窗口信息
    def enum_callback(hwnd: int, _: Any) -> None:
        windows.append((hwnd, GetWindowText(hwnd)))

    EnumWindows(enum_callback, None)
    return [hwnd for hwnd, window_title in windows
            if title.lower() in window_title.lower()]


class Keyboard:
    """键盘操作类

    提供窗口查找和按键发送功能。
    """

    def __init__(self) -> None:
        """初始化Keyboard实例"""
        self.hwnd: Optional[int] = None

    def find_window(self, title: str) -> bool:
        """查找指定标题的窗口

        Args:
            title: 窗口标题（支持模糊匹配）

        Returns:
            是否找到窗口

        """
        try:
            windows = get_windows_by_title(title)
            if windows:
                self.hwnd = windows[0]
                return True
            else:
                return False
        except Exception:
            # 如果枚举窗口过程中出现异常，返回False
            self.hwnd = None
            return False

    def send_hot_key(self, hot_key: str) -> None:
        """发送组合键

        Args:
            hot_key: 组合键字符串，用'-'分隔各个按键，如"CTRL-C"

        Raises:
            ValueError: 当hwnd未设置时
            KeyError: 当按键名称不存在时
            OSError: 当发送消息失败时
        """
        if self.hwnd is None:
            raise ValueError("Window handle not set. Call find_window() first.")

        key_list: List[str] = hot_key.split("-")

        # 按顺序按下所有键
        for skey in key_list:
            press_key_hwnd(self.hwnd, skey)

        # 短暂延迟确保按键被正确识别
        time.sleep(0.01)

        # 按相反顺序释放所有键（模拟真实按键行为）
        for skey in reversed(key_list):
            release_key_hwnd(self.hwnd, skey)


def initialize_components():
    """初始化OCR、摄像头和键盘组件"""
    logger.info("正在初始化组件...")
    ocr = ddddocr.DdddOcr()
    camera = dxcam.create(region=REGION)
    camera.start(target_fps=TARGET_FPS)
    keyboard = Keyboard()
    keyboard.find_window("魔兽世界")
    logger.info("组件初始化完成")
    return ocr, camera, keyboard


def normalize_hotkey(text):
    """
    将OCR识别出的按键文本标准化为标准按键组合格式
    例如: ALTZ -> ALT-Z, SHIFT1 -> SHIFT-1
    """
    text = text.upper()

    # 如果已经包含"-"则认为已经是标准格式
    if "-" in text:
        return text

    # 常见的修饰键
    modifiers = ["CTRL", "SHIFT", "ALT"]

    # 检查是否以修饰键开头
    for mod in modifiers:
        if text.startswith(mod):
            # 提取修饰键后的部分
            key_part = text[len(mod):]
            if key_part:
                return f"{mod}-{key_part}"

    # 如果没有识别出修饰键组合，则直接返回原文字
    return text


def process_ocr_mode(ocr, right_part, keyboard):
    """处理OCR模式"""
    logger.debug("进入OCR模式")
    ocr_error = False
    # result = ocr.recognize(right_part, detail=0, paragraph=True)
    # ocr_text = result[0]
    # ocr_text=ocr_text.strip()
    # ocr_text=ocr_text.upper()
    # if "ERROR" in ocr_text:
    #     logger.warning("OCR识别错误")
    #     return
    # 标准化OCR识别结果
    img = Image.fromarray(right_part)
    ocr_text = ocr.classification(img)
    # print(result)
    #
    # exit(1)
    normalized_text = normalize_hotkey(ocr_text)
    keys = normalized_text.split("-")
    for key in keys:
        x = VK_DICT.get(key, None)
        if x is None:
            logger.warning(f"无效的按键: {normalized_text}")
            ocr_error = True
    if not ocr_error:
        logger.debug(f"发送OCR识别的按键组合: {normalized_text}")
        keyboard.send_hot_key(normalized_text)
    else:
        logger.warning("OCR识别失败")


def process_color_mode(code, keyboard):
    """处理颜色模式"""
    logger.debug(f"检测到颜色: {code}")
    code_key = f"{code[0]}, {code[1]}, {code[2]}"
    key_bind = COLOR_TO_KEY.get(code_key, None)
    if key_bind:
        logger.debug(f"匹配到键位: {key_bind}")
        keyboard.send_hot_key(key_bind)
    else:
        logger.warning(f"无效的颜色: {code}")


def process_frame(frame, ocr, keyboard):
    """处理单个帧"""
    left_part = frame[:, :24, :]
    right_part = frame[:, 24:, :]

    if np.all(left_part == left_part[0, 0]):
        logger.debug("检测到纯色背景")
        code = left_part[0, 0]
        if code[0] == 128 and code[1] == 128 and code[2] == 128:
            process_ocr_mode(ocr, right_part, keyboard)
        elif code[0] == 255 and code[1] == 255 and code[2] == 255:
            logger.debug("纯白闲置")
        elif code[0] == 0 and code[1] == 0 and code[2] == 0:
            logger.debug("纯黑闲置")
        else:
            process_color_mode(code, keyboard)
    else:
        pixels = left_part.reshape(-1, 3)
        unique_count = len(np.unique(pixels, axis=0))
        logger.warning(f"检测到{unique_count}种颜色")


def main() -> None:

    if not is_admin():
        print("必须用管理员身份运行脚本")
        exit(32)

    # 初始化组件
    ocr, camera, keyboard = initialize_components()

    try:
        while True:
            frame = camera.get_latest_frame()
            process_frame(frame, ocr, keyboard)
    except KeyboardInterrupt:
        logger.info("程序被用户中断")
    finally:
        camera.stop()
        logger.info("摄像头已停止")


if __name__ == "__main__":
    main()
