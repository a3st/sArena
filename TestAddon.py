import shutil
import os

ADDON_NAME = "sArena"
WOW_DIR_PATH = os.path.abspath("C:\\Program Files (x86)\\World of Warcraft\\_classic_")

if __name__ == "__main__":
    source_dir_path = os.path.join(os.path.dirname(__file__), ADDON_NAME)
    dest_dir_path = os.path.join(WOW_DIR_PATH, "Interface", "AddOns", ADDON_NAME)

    shutil.copytree(source_dir_path, dest_dir_path, dirs_exist_ok=True)
    print("Complete!")
